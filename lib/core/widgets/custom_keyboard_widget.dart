import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/features/real_time_conversion/bloc/real_time_conversion_bloc.dart';
import 'package:number_conversion/core/model/keyboard_button_model.dart';

class CustomKeyboardWidget extends StatelessWidget {
  const CustomKeyboardWidget({super.key});

  List<List<KeyboardButtonModel>> _definekeyboardLayoutMatrix(
    RealTimeConversionState state,
  ) {
    if (state.status == RealTimeConversionStateStatus.binary) {
      return KeyboardLayoutMatrixModel.binary;
    } else if (state.status == RealTimeConversionStateStatus.octal) {
      return KeyboardLayoutMatrixModel.octal;
    } else if (state.status == RealTimeConversionStateStatus.hexadecimal) {
      return KeyboardLayoutMatrixModel.hexadecimal;
    } else {
      return KeyboardLayoutMatrixModel.decimal;
    }
  }

  void _performInputButton(
    BuildContext context,
    String input,
    RealTimeConversionState state,
  ) {
    String newInput;
    if (state.status == RealTimeConversionStateStatus.binary) {
      newInput = state.binary + input;
      context.read<RealTimeConversionBloc>().add(BinaryEvent(newInput));
    } else if (state.status == RealTimeConversionStateStatus.decimal) {
      newInput = state.decimal + input;
      context.read<RealTimeConversionBloc>().add(DecimalEvent(newInput));
    } else if (state.status == RealTimeConversionStateStatus.octal) {
      newInput = state.octal + input;
      context.read<RealTimeConversionBloc>().add(OctalEvent(newInput));
    } else if (state.status == RealTimeConversionStateStatus.hexadecimal) {
      if (state.hexadecimal == "0") {
        newInput = input;
      } else {
        newInput = state.hexadecimal + input;
      }
      context.read<RealTimeConversionBloc>().add(HexadecimalEvent(newInput));
    }
  }

  void _performBackspaceButton(
    BuildContext context,
    RealTimeConversionState state,
  ) {
    String newInput;
    if (state.status == RealTimeConversionStateStatus.binary) {
      newInput = (state.binary.length == 1)
          ? "0"
          : state.binary.substring(0, state.binary.length - 1);
      context.read<RealTimeConversionBloc>().add(BinaryEvent(newInput));
    } else if (state.status == RealTimeConversionStateStatus.decimal) {
      newInput = (state.decimal.length == 1)
          ? "0"
          : state.decimal.substring(0, state.decimal.length - 1);
      context.read<RealTimeConversionBloc>().add(DecimalEvent(newInput));
    } else if (state.status == RealTimeConversionStateStatus.octal) {
      newInput = (state.octal.length == 1)
          ? "0"
          : state.octal.substring(0, state.octal.length - 1);
      context.read<RealTimeConversionBloc>().add(OctalEvent(newInput));
    } else if (state.status == RealTimeConversionStateStatus.hexadecimal) {
      newInput = (state.hexadecimal.length == 1)
          ? "0"
          : state.hexadecimal.substring(0, state.hexadecimal.length - 1);
      context.read<RealTimeConversionBloc>().add(HexadecimalEvent(newInput));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RealTimeConversionBloc, RealTimeConversionState>(
      builder: (context, state) {
        final List<List<KeyboardButtonModel>> keyboardLayoutMatrix =
            _definekeyboardLayoutMatrix(state);

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
                      state: state,
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
                      state: state,
                    );
                  }),
                );
              }),

              // Clear - 0 - Backspace
              Row(
                spacing: 5,
                children: [
                  _buildAdditionalButton(context, label: "Clear", state: state),
                  _buildInputButton(
                    context,
                    keyboardButton: KeyboardButtonModel("0", true),
                    state: state,
                  ),
                  _buildAdditionalButton(context, label: "⌫", state: state),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputButton(
    BuildContext context, {
    required KeyboardButtonModel keyboardButton,
    required RealTimeConversionState state,
  }) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: FilledButton.tonal(
          onPressed: keyboardButton.status
              ? () => _performInputButton(context, keyboardButton.label, state)
              : null,
          style: FilledButton.styleFrom(
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
    required RealTimeConversionState state,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Expanded(
      child: SizedBox(
        height: 54,
        child: FilledButton.tonal(
          onPressed: () {
            if (label == "Clear") {
              context.read<RealTimeConversionBloc>().add(ClearEvent());
            } else if (label == "⌫") {
              _performBackspaceButton(context, state);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: color.tertiaryContainer,
            foregroundColor: color.onTertiaryContainer,
            iconColor: color.onTertiaryContainer,
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
