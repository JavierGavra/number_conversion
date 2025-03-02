part of 'number_base.dart';

final class Hexadecimal implements NumberBaseCovert {
  final base = NumberBaseType.hexadecimal;
  String value;

  Hexadecimal(this.value) {
    value = value.toUpperCase().replaceAll(RegExp(r'^(0x|0X)'), '');
    assert(value.contains(RegExp(r'^[A-F0-9]+$')));
  }

  int _hexCharToDecimal(String hexChar) {
    int charCodeUnit = hexChar.codeUnitAt(0);

    // 0 - 9
    if (charCodeUnit >= 48 && charCodeUnit <= 57) return charCodeUnit - 48;

    // A-F
    return charCodeUnit - 55;
  }

  int _binaryToDecimal(String binary) {
    int result = 0;
    int base = 1;
    for (int i = binary.length - 1; i >= 0; i--) {
      if (binary[i] == '1') {
        result += base;
      }
      base *= 2;
    }
    return result;
  }

  String _decimalToBinary(int value) {
    if (value == 0) return "0";
    List<String> result = [];
    do {
      result.add((value % 2).toString());
      value ~/= 2;
    } while (value != 0);
    return result.reversed.join();
  }

  @override
  String toBinary() {
    if (value == "0") return "0";
    String result = "";
    for (int i = 0; i < value.length; i++) {
      result += _decimalToBinary(_hexCharToDecimal(value[i])).padLeft(4, '0');
    }
    return result.replaceFirst(RegExp(r'^0+'), '');
  }

  @override
  String toOctal() {
    String binary = toBinary();
    if (binary == "0") return "0";
    while (binary.length % 3 != 0) {
      binary = '0$binary';
    }

    String result = "";
    for (int i = 0; i < binary.length; i += 3) {
      result += _binaryToDecimal(binary.substring(i, i + 3)).toString();
    }
    return result;
  }

  @override
  String toDecimal() {
    int result = 0;
    int baseMultiplier = 1;
    for (int i = value.length - 1; i >= 0; i--) {
      result += _hexCharToDecimal(value[i]) * baseMultiplier;
      baseMultiplier *= base;
    }
    return result.toString();
  }

  @override
  String toHexadecimal() => value;
}
