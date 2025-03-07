part of 'conversion_with_step_bloc.dart';

sealed class ConversionWithStepState extends Equatable {
  const ConversionWithStepState();
  
  @override
  List<Object> get props => [];
}

final class ConversionWithStepInitial extends ConversionWithStepState {}
