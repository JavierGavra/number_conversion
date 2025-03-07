import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conversion_with_step_event.dart';
part 'conversion_with_step_state.dart';

class ConversionWithStepBloc extends Bloc<ConversionWithStepEvent, int> {
  ConversionWithStepBloc() : super(0) {
    on<IncrementEvent>(_incrementHandler);
    on<DecrementEvent>(_decrementHandler);
  }

  Future<void> _incrementHandler(
    IncrementEvent event,
    Emitter<int> emit,
  ) async {
    emit(state + 1);
  }

  Future<void> _decrementHandler(
    DecrementEvent event,
    Emitter<int> emit,
  ) async {
    emit(state - 1);
  }
}
