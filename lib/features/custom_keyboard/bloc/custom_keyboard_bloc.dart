import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'custom_keyboard_event.dart';
part 'custom_keyboard_state.dart';

class CustomKeyboardBloc
    extends Bloc<CustomKeyboardEvent, CustomKeyboardState> {
  CustomKeyboardBloc() : super(CustomKeyboardState.initial()) {
    on<InitialEvent>(_initialHandler);
    on<TypingEvent>(_typingHandler);
    on<ClearEvent>(_clearHandler);
    on<BackspaceEvent>(_backspaceHandler);
  }

  Future<void> _initialHandler(
    InitialEvent event,
    Emitter<CustomKeyboardState> emit,
  ) async {
    if (event.initialText != null) {
      emit(CustomKeyboardState(
        status: CustomKeyboardStateStatus.typing,
        text: event.initialText!,
      ));
    } else {
      emit(CustomKeyboardState.initial());
    }
  }

  Future<void> _typingHandler(
    TypingEvent event,
    Emitter<CustomKeyboardState> emit,
  ) async {
    if (state.status == CustomKeyboardStateStatus.initial ||
        (state.text.length <= 1 && state.text == "0")) {
      emit(CustomKeyboardState(
        status: CustomKeyboardStateStatus.typing,
        text: event.newChar,
      ));
    } else {
      emit(CustomKeyboardState(
        status: CustomKeyboardStateStatus.typing,
        text: state.text + event.newChar,
      ));
    }
  }

  Future<void> _clearHandler(
    ClearEvent event,
    Emitter<CustomKeyboardState> emit,
  ) async {
    if (event.relpaceWith != null) {
      emit(CustomKeyboardState(
        status: CustomKeyboardStateStatus.initial,
        text: event.relpaceWith!,
      ));
    } else {
      emit(CustomKeyboardState.initial());
    }
  }

  Future<void> _backspaceHandler(
    BackspaceEvent event,
    Emitter<CustomKeyboardState> emit,
  ) async {
    int textLength = state.text.length;
    if (textLength <= 1) {
      emit(CustomKeyboardState(
        status: CustomKeyboardStateStatus.initial,
        text: '0',
      ));
    } else {
      emit(CustomKeyboardState(
        status: CustomKeyboardStateStatus.typing,
        text: state.text.substring(0, textLength - 1),
      ));
    }
  }
}
