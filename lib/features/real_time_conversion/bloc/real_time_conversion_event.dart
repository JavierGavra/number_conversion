part of 'real_time_conversion_bloc.dart';

sealed class RealTimeConversionEvent extends Equatable {
  const RealTimeConversionEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ClearEvent extends RealTimeConversionEvent {}

class BinaryEvent extends RealTimeConversionEvent {
  final String binary;

  const BinaryEvent(this.binary);

  @override
  List<Object?> get props => [binary];
}

class DecimalEvent extends RealTimeConversionEvent {
  final String decimal;

  const DecimalEvent(this.decimal);

  @override
  List<Object?> get props => [decimal];
}

class OctalEvent extends RealTimeConversionEvent {
  final String octal;

  const OctalEvent(this.octal);

  @override
  List<Object?> get props => [octal];
}

class HexadecimalEvent extends RealTimeConversionEvent {
  final String hexadecimal;

  const HexadecimalEvent(this.hexadecimal);

  @override
  List<Object?> get props => [hexadecimal];
}
