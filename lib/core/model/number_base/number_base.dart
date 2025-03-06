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

abstract interface class NumberBaseCovertWithStep {
  NumberBaseResultWithStep toBinaryWithStep();
  NumberBaseResultWithStep toOctalWithStep();
  NumberBaseResultWithStep toDecimalWithStep();
  NumberBaseResultWithStep toHexadecimalWithStep();
}

class NumberBaseType {
  static int get binary => 2;
  static int get octal => 8;
  static int get decimal => 10;
  static int get hexadecimal => 16;
}

class NumberBaseResultWithStep {
  final String result;
  final String step;

  const NumberBaseResultWithStep({required this.result, required this.step});
}
