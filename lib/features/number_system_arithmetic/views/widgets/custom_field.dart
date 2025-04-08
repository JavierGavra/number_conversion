import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomField({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: screenSize.width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected
              ? color.primary.withValues(alpha: 0.3)
              : color.secondary.withValues(alpha: 0.2),
          border: Border.all(
            color: isSelected ? color.primaryContainer : color.surface,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? color.primaryContainer : color.onPrimary,
          ),
        ),
      ),
    );
  }
}
