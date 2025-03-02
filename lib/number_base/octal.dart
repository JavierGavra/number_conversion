part of 'number_base.dart';

final class Octal implements NumberBaseCovert {
  final base = NumberBaseType.octal;
  int value;

  Octal(this.value) : assert(!(value.toString().contains(RegExp(r'[8-9]'))));

  String _decimalToBinary3Digit(int value) {
    String result = "";
    int remainder;

    do {
      remainder = value % 2;
      value ~/= 2;
      result += remainder.toString();
    } while (value != 0);

    result = result.reverse();

    return result.padLeft(3, '0');
  }

  int _toDecimalFromBinary(int value) {
    int result = 0;
    int lastNumber = 0;

    int base = 1;
    while (value != 0) {
      lastNumber = value % 10;
      result += (lastNumber * base);

      value ~/= 10;

      base *= 2;
    }

    return result;
  }

  @override
  String toBinary() {
    String value = this.value.toString();
    String result = "";

    if (value == "0") return value;

    for (int i = 0; i < value.length; i++) {
      result += _decimalToBinary3Digit(int.parse(value[i]));
    }

    return result.replaceFirst(RegExp(r'^0+'), '');
  }

  @override
  String toOctal() => value.toString();

  @override
  String toDecimal() {
    int value = this.value;
    int result = 0;
    int lastNumber = 0;

    int base = 1;
    while (value != 0) {
      lastNumber = value % 10;
      result += (lastNumber * base);

      value ~/= 10;

      base *= this.base;
    }

    return result.toString();
  }

  @override
  String toHexadecimal() {
    String binary = toBinary();
    String result = "";

    if (binary == "0") return binary;

    while (binary.length % 4 != 0) {
      binary = '0$binary';
    }

    for (int i = 0; i < binary.length; i += 4) {
      String last4Bit = binary.substring(i, i + 4);
      int decimal = _toDecimalFromBinary(int.parse(last4Bit));
      if (decimal > 9) {
        result += String.fromCharCode(decimal.toInt() + 55);
      } else {
        result += decimal.toString();
      }
    }

    return result;
  }
}
