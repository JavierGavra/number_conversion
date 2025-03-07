part of 'custom_keyboard_bloc.dart';

sealed class CustomKeyboardEvent extends Equatable {
  const CustomKeyboardEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends CustomKeyboardEvent {
  final String? initialText;

  const InitialEvent({this.initialText});

  @override
  List<Object?> get props => [initialText];
}

class TypingEvent extends CustomKeyboardEvent {
  final String newChar;

  const TypingEvent({required this.newChar});

  @override
  List<Object> get props => [newChar];
}

class ClearEvent extends CustomKeyboardEvent {
  final String? relpaceWith;

  const ClearEvent({this.relpaceWith});

  @override
  List<Object?> get props => [relpaceWith];
}

class BackspaceEvent extends CustomKeyboardEvent {}
