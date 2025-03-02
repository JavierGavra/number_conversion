part of 'number_conversion_bloc.dart';

enum NumberConversionStateStatus { binary, decimal, octal, hexadecimal }

class NumberConversionState extends Equatable {
  final NumberConversionStateStatus status;
  final String binary;
  final String decimal;
  final String octal;
  final String hexadecimal;

  const NumberConversionState({
    required this.status,
    required this.binary,
    required this.decimal,
    required this.octal,
    required this.hexadecimal,
  });

  const NumberConversionState.initial()
      : this(
          status: NumberConversionStateStatus.decimal,
          binary: "0",
          decimal: "0",
          octal: "0",
          hexadecimal: "0",
        );

  @override
  List<Object> get props => [status, binary, decimal, octal, hexadecimal];
}
