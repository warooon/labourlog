import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Ink(
          decoration: BoxDecoration(
            color: color ?? (isDark ? Colors.grey[800] : Colors.grey[300]),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            color:
                color == null
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.white,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
