import 'dart:math';

import 'package:number_conversion/core/extension/string_extension.dart';

part 'decimal.dart';
part 'binary.dart';
part 'octal.dart';
part 'hexadecimal.dart';

abstract interface class NumberBaseCovert {
  String toBinary();
  String toOctal();
  String toDecimal();
  String toHexadecimal();
}

class NumberBaseType {
  static const binary = 2;
  static const octal = 8;
  static const decimal = 10;
  static const hexadecimal = 16;
}
