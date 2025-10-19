part of 'conversion_with_step_bloc.dart';

class ConversionWithStepState extends Equatable {
  final String from;
  final String resultFormatted;
  final NumberBaseConvertResultModel model;

  const ConversionWithStepState({
    required this.from,
    required this.resultFormatted,
    required this.model,
  });

  ConversionWithStepState.initial()
      : this(model: Decimal(0).toBinary(), from: "0", resultFormatted: "0000");

  @override
  List<Object> get props => [model];
}
