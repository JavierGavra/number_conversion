part of 'number_base.dart';

final class Octal implements NumberBaseCovert {
  final base = NumberBaseType.octal;
  int value;

  Octal(this.value) : assert(!(value.toString().contains(RegExp(r'[8-9]'))));

  String _decimalToBinary(int value) {
    String result = "";
    int remainder;

    do {
      remainder = value % 2;
      value ~/= 2;
      result += remainder.toString();
    } while (value != 0);

    result = result.reverse();

    return result;
  }

  int _binaryToDecimal(String value) {
    int result = 0;
    int i = 0;

    for (int j = value.length - 1; j >= 0; j--) {
      num resultPerBit = int.parse(value[j]) * pow(2, i);
      result += resultPerBit.toInt();
      i++;
    }

    return result;
  }

  @override
  String toBinary() {
    String octal = value.toString();
    String result = "";
    List<String> listOf3Bits = [];

    for (int i = 0; i < octal.length; i++) {
      listOf3Bits.add(_decimalToBinary(int.parse(octal[i])).padLeft(3, "0"));
    }

    for (var element in listOf3Bits) {
      result += element;
    }

    return result == "000" ? "0" : result.replaceFirst(RegExp(r'^0+'), '');
  }

  @override
  String toOctal() => value.toString();

  @override
  String toDecimal() {
    String octal = value.toString();
    int result = 0;
    int i = 0;

    for (int j = octal.length - 1; j >= 0; j--) {
      num resultPerDecimal = int.parse(octal[j]) * pow(8, i);
      result += resultPerDecimal.toInt();
      i++;
    }

    return result.toString();
  }

  @override
  String toHexadecimal() {
    String binary = toBinary();
    String result = "";
    List<String> listOf4bits = [];

    for (int i = binary.length; i > 0; i -= 4) {
      if (i < 4) {
        listOf4bits.add(binary.substring(0, i).padLeft(4, "0"));
        continue;
      }

      listOf4bits.add(binary.substring(i - 4, i));
    }
    listOf4bits = listOf4bits.reversed.toList();

    for (int i = 0; i < listOf4bits.length; i++) {
      int decimal = _binaryToDecimal(listOf4bits[i]);

      if (decimal > 9) {
        String letter = String.fromCharCode(decimal + 55);
        result += letter;
      } else {
        result += decimal.toString();
      }
    }

    return result;
  }
}
