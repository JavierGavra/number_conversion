part of 'number_system_arithmetic_bloc.dart';

class NumberSystemArithmeticState extends Equatable {
  final String resultFormatted;
  final NumberBaseArithmeticResultModel model;

  const NumberSystemArithmeticState({
    required this.resultFormatted,
    required this.model,
  });

  NumberSystemArithmeticState.initial()
      : this(resultFormatted: "0", model: Decimal(0).addition(Decimal(0)));

  @override
  List<Object> get props => [resultFormatted, model];
}
