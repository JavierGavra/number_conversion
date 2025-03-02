import '../extension/string_extension.dart';

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
  static int get binary => 2;
  static int get octal => 8;
  static int get decimal => 10;
  static int get hexadecimal => 16;
}
