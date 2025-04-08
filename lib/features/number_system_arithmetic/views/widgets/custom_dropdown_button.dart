import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>>? menus;
  final ValueNotifier valueNotifier;
  final void Function(T?)? onChanged;

  const CustomDropdownButton({
    super.key,
    required this.label,
    required this.menus,
    required this.valueNotifier,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return DropdownButtonFormField<T>(
          value: value,
          iconEnabledColor: color.surfaceContainerHighest,
          style: TextStyle(color: color.surface),
          dropdownColor: color.secondary,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: color.surface),
            filled: true,
            fillColor: color.surfaceContainerHighest.withValues(alpha: 0.1),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.surface),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.surface),
            ),
          ),
          onChanged: onChanged,
          items: menus,
        );
      },
    );
  }
}
