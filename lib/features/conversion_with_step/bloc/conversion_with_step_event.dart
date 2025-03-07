part of 'conversion_with_step_bloc.dart';

sealed class ConversionWithStepEvent extends Equatable {
  const ConversionWithStepEvent();

  @override
  List<Object> get props => [];
}

class IncrementEvent extends ConversionWithStepEvent {}

class DecrementEvent extends ConversionWithStepEvent {}
