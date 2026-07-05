import 'package:flutter/material.dart';

enum LessonNodeState { locked, unlocked, current, completed }

class LessonNode extends StatelessWidget {
  final String title;
  final LessonNodeState state;
  final VoidCallback? onTap;
  final double size;

  const LessonNode({
    super.key,
    required this.title,
    required this.state,
    required this.onTap,
    this.size = 76,
  });

  Color _baseColor(BuildContext context) {
    switch (state) {
      case LessonNodeState.locked:
        return Colors.grey.shade400;
      case LessonNodeState.unlocked:
      case LessonNodeState.current:
        return Theme.of(context).colorScheme.primary;
      case LessonNodeState.completed:
        return Colors.amber.shade600;
    }
  }

  IconData _icon() {
    switch (state) {
      case LessonNodeState.locked:
        return Icons.lock_outline;
      case LessonNodeState.unlocked:
      case LessonNodeState.current:
        return Icons.star_rounded;
      case LessonNodeState.completed:
        return Icons.check_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _baseColor(context);
    final isTappable = onTap != null;

    final node = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 0,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
      ),
      child: Icon(_icon(), color: Colors.white, size: size * 0.45),
    );

    final labeled = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state == LessonNodeState.current) _StartBubble(color: color),
        node,
        const SizedBox(height: 6),
        SizedBox(
          width: size + 24,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: state == LessonNodeState.current ? FontWeight.bold : FontWeight.normal,
              color: state == LessonNodeState.locked ? Colors.grey : null,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Opacity(opacity: isTappable ? 1.0 : 0.7, child: labeled),
    );
  }
}

class _StartBubble extends StatefulWidget {
  final Color color;
  const _StartBubble({required this.color});

  @override
  State<_StartBubble> createState() => _StartBubbleState();
}

class _StartBubbleState extends State<_StartBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'START',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
        ),
      ),
    );
  }
}