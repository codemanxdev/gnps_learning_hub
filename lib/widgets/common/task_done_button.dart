import 'package:flutter/material.dart';

class TaskDoneButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const TaskDoneButton({
    super.key,
    required this.onPressed,
    this.label = 'Done',
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(100, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label),
    );
  }
}
