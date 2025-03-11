import 'dart:math';

import '../../extension/string_extension.dart';

part 'decimal.dart';
part 'binary.dart';
part 'octal.dart';
part 'hexadecimal.dart';

abstract interface class NumberBaseCovert {
  NumberBaseResultModel toBinary();
  NumberBaseResultModel toOctal();
  NumberBaseResultModel toDecimal();
  NumberBaseResultModel toHexadecimal();
}

class NumberBaseType {
  static const int binary = 2;
  static const int octal = 8;
  static const int decimal = 10;
  static const int hexadecimal = 16;
}

class NumberBaseResultModel {
  final String initialValue;
  final int fromBase;
  final int toBase;
  final String result;
  final String step;

  const NumberBaseResultModel({
    required this.initialValue,
    required this.fromBase,
    required this.toBase,
    required this.result,
    required this.step,
  });

  const NumberBaseResultModel.noStep({
    required String initialValue,
    required int fromBase,
    required int toBase,
    required String result,
  }) : this(
          initialValue: initialValue,
          fromBase: fromBase,
          toBase: toBase,
          result: result,
          step: "#Tidak ada proses konversi#",
        );
}
