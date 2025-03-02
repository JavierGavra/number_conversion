part of 'number_conversion_bloc.dart';

sealed class NumberConversionEvent extends Equatable {
  const NumberConversionEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ClearEvent extends NumberConversionEvent {}

class BinaryEvent extends NumberConversionEvent {
  final String binary;

  const BinaryEvent(this.binary);

  @override
  List<Object?> get props => [binary];
}

class DecimalEvent extends NumberConversionEvent {
  final String decimal;

  const DecimalEvent(this.decimal);

  @override
  List<Object?> get props => [decimal];
}

class OctalEvent extends NumberConversionEvent {
  final String octal;

  const OctalEvent(this.octal);

  @override
  List<Object?> get props => [octal];
}

class HexadecimalEvent extends NumberConversionEvent {
  final String hexadecimal;

  const HexadecimalEvent(this.hexadecimal);

  @override
  List<Object?> get props => [hexadecimal];
}
