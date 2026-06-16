import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// A small rounded pill showing an icon + label, used for metadata such as
/// cook time, servings, and difficulty.
class InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;

  const InfoPill({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppTheme.primary,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: filled ? Colors.white : color),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: filled ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
