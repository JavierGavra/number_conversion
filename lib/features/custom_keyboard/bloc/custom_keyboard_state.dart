part of 'custom_keyboard_bloc.dart';

enum CustomKeyboardStateStatus { initial, typing }

class CustomKeyboardState extends Equatable {
  final CustomKeyboardStateStatus status;
  final String text;

  const CustomKeyboardState({required this.status, required this.text});

  const CustomKeyboardState.initial()
      : this(status: CustomKeyboardStateStatus.initial, text: "");

  @override
  List<Object> get props => [status, text];
}
