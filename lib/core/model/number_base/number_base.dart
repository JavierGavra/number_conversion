import '../../../extension/string_extension.dart';

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
  static const int binary = 2;
  static const int octal = 8;
  static const int decimal = 10;
  static const int hexadecimal = 16;
}

class NumberBaseResultModel {
  final String result;
  final String step;

  const NumberBaseResultModel({required this.result, required this.step});
}
