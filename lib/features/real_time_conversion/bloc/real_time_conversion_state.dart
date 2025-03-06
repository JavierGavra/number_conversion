part of 'real_time_conversion_bloc.dart';

enum RealTimeConversionStateStatus { binary, decimal, octal, hexadecimal }

class RealTimeConversionState extends Equatable {
  final RealTimeConversionStateStatus status;
  final String binary;
  final String decimal;
  final String octal;
  final String hexadecimal;

  const RealTimeConversionState({
    required this.status,
    required this.binary,
    required this.decimal,
    required this.octal,
    required this.hexadecimal,
  });

  const RealTimeConversionState.initial()
      : this(
          status: RealTimeConversionStateStatus.decimal,
          binary: "0",
          decimal: "0",
          octal: "0",
          hexadecimal: "0",
        );

  @override
  List<Object> get props => [status, binary, decimal, octal, hexadecimal];
}
