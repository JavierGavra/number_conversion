part of 'conversion_with_step_bloc.dart';

sealed class ConversionWithStepEvent extends Equatable {
  const ConversionWithStepEvent();

  @override
  List<Object?> get props => [];
}

class ConversionEvent extends ConversionWithStepEvent {
  final int fromBase;
  final int toBase;
  final String value;

  const ConversionEvent({
    required this.fromBase,
    required this.toBase,
    required this.value,
  });

  @override
  List<Object?> get props => [fromBase, toBase, value];
}
