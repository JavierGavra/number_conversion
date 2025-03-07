part of 'real_time_conversion_bloc.dart';

class RealTimeConversionState extends Equatable {
  final int from;
  final String binary;
  final String decimal;
  final String octal;
  final String hexadecimal;

  const RealTimeConversionState({
    required this.from,
    required this.binary,
    required this.decimal,
    required this.octal,
    required this.hexadecimal,
  });

  const RealTimeConversionState.initial()
      : this(
          from: NumberBaseType.decimal,
          binary: "0",
          decimal: "0",
          octal: "0",
          hexadecimal: "0",
        );

  @override
  List<Object> get props => [from, binary, decimal, octal, hexadecimal];
}
