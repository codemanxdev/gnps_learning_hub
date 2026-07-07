import 'package:flutter/material.dart';

class TaskClearButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const TaskClearButton({
    super.key,
    required this.onPressed,
    this.label = 'Clear',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey.shade700,
      ),
    );
  }
}
