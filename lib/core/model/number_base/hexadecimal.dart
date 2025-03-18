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
    String hexadecimal = value;
    String result = "";
    List<String> listOf4Bits = [];

    for (int i = 0; i < hexadecimal.length; i++) {
      int decimal = _hexCharToDecimal(hexadecimal[i]);
      listOf4Bits.add(_decimalToBinary(decimal).padLeft(4, "0"));
    }

    for (var element in listOf4Bits) {
      result += element;
    }

    return result == "0000" ? "0" : result.replaceFirst(RegExp(r'^0+'), '');
  }

  @override
  String toOctal() {
    String binary = toBinary();
    String result = "";
    List<String> listOf3bits = [];

    for (int i = binary.length; i > 0; i -= 3) {
      if (i < 3) {
        listOf3bits.add(binary.substring(0, i).padLeft(3, "0"));
        continue;
      }

      listOf3bits.add(binary.substring(i - 3, i));
    }
    listOf3bits = listOf3bits.reversed.toList();

    for (int i = 0; i < listOf3bits.length; i++) {
      int decimal = _binaryToDecimal(listOf3bits[i]);
      result += decimal.toString();
    }

    return result;
  }

  @override
  String toDecimal() {
    String hexadecimal = value;
    int result = 0;
    int i = 0;
    List<int> listOfDecimal = [];

    for (int j = 0; j < hexadecimal.length; j++) {
      listOfDecimal.add(_hexCharToDecimal(hexadecimal[j]));
    }

    for (int j = hexadecimal.length - 1; j >= 0; j--) {
      num resultPerDecimal = listOfDecimal[j] * pow(16, i);
      result += resultPerDecimal.toInt();
      i++;
    }
    return result.toString();
  }

  @override
  String toHexadecimal() => value;
}
