import 'dart:math';

import '../../extension/string_extension.dart';
import '../number_base_convert_result_model.dart';
import '../number_base_arithmetic_result_model.dart';

part 'decimal.dart';
part 'binary.dart';
part 'octal.dart';
part 'hexadecimal.dart';

abstract interface class NumberBaseCovert {
  NumberBaseConvertResultModel toBinary();
  NumberBaseConvertResultModel toOctal();
  NumberBaseConvertResultModel toDecimal();
  NumberBaseConvertResultModel toHexadecimal();
}

abstract interface class NumberBaseArithmetic<T> {
  NumberBaseArithmeticResultModel addition(T other);
  NumberBaseArithmeticResultModel subtraction(T other);
  NumberBaseArithmeticResultModel multiplication(T other);
  NumberBaseArithmeticResultModel division(T other);
}

class NumberBaseType {
  static const int binary = 2;
  static const int octal = 8;
  static const int decimal = 10;
  static const int hexadecimal = 16;
}
