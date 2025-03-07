import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/model/keyboard_button_model.dart';
import 'package:number_conversion/core/model/keyboard_layout_matrix_model.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';

class CustomKeyboardWidget extends StatelessWidget {
  final int numberBaseType;

  const CustomKeyboardWidget({super.key, required this.numberBaseType});

  List<List<KeyboardButtonModel>> _defineKeyboardLayoutMatrix() {
    switch (numberBaseType) {
      case NumberBaseType.binary:
        return KeyboardLayoutMatrixModel.binary;
      case NumberBaseType.octal:
        return KeyboardLayoutMatrixModel.octal;
      case NumberBaseType.hexadecimal:
        return KeyboardLayoutMatrixModel.hexadecimal;
      default:
        return KeyboardLayoutMatrixModel.decimal;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<KeyboardButtonModel>> keyboardLayoutMatrix =
        _defineKeyboardLayoutMatrix();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          // A - F
          ...List.generate(2, (i) {
            i += 3;
            return Row(
              spacing: 5,
              children: List.generate(3, (j) {
                return _buildInputButton(
                  context,
                  keyboardButton: keyboardLayoutMatrix[i][j],
                );
              }),
            );
          }),

          Divider(),

          // 1 - 9
          ...List.generate(3, (i) {
            return Row(
              spacing: 5,
              children: List.generate(3, (j) {
                return _buildInputButton(
                  context,
                  keyboardButton: keyboardLayoutMatrix[i][j],
                );
              }),
            );
          }),

          // Clear - 0 - Backspace
          Row(
            spacing: 5,
            children: [
              _buildAdditionalButton(context, label: "Clear"),
              _buildInputButton(
                context,
                keyboardButton: KeyboardButtonModel("0", true),
              ),
              _buildAdditionalButton(context, label: "⌫"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputButton(
    BuildContext context, {
    required KeyboardButtonModel keyboardButton,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Expanded(
      child: SizedBox(
        height: 54,
        child: FilledButton(
          onPressed: keyboardButton.status
              ? () => context
                  .read<CustomKeyboardBloc>()
                  .add(TypingEvent(newChar: keyboardButton.label))
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: color.surface,
            foregroundColor: color.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            keyboardButton.label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalButton(
    BuildContext context, {
    required String label,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Expanded(
      child: SizedBox(
        height: 54,
        child: FilledButton(
          onPressed: () {
            if (label == "Clear") {
              context
                  .read<CustomKeyboardBloc>()
                  .add(ClearEvent(relpaceWith: "0"));
            } else if (label == "⌫") {
              context.read<CustomKeyboardBloc>().add(BackspaceEvent());
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: color.primaryContainer,
            foregroundColor: color.onPrimaryContainer,
            iconColor: color.onPrimaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
