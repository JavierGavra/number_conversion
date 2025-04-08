part of 'number_system_arithmetic_bloc.dart';

sealed class NumberSystemArithmeticEvent extends Equatable {
  const NumberSystemArithmeticEvent();

  @override
  List<Object> get props => [];
}

class CalculateEvent extends NumberSystemArithmeticEvent {
  final int numberBase;
  final String operator;
  final String field1;
  final String field2;

  const CalculateEvent({
    required this.numberBase,
    required this.operator,
    required this.field1,
    required this.field2,
  });

  @override
  List<Object> get props => [numberBase, operator, field1, field2];
}
