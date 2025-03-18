part of 'number_base.dart';

final class Binary implements NumberBaseCovert {
  final base = NumberBaseType.binary;
  late String value;

  Binary(this.value) : assert(!(value.toString().contains(RegExp(r'[2-9]'))));

  int _toDecimal(String value) {
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
  String toBinary() => value;

  @override
  String toOctal() {
    String binary = value.toString();
    List<String> listOf3bits = [];
    String result = "";

    for (int i = binary.length; i > 0; i -= 3) {
      if (i < 3) {
        listOf3bits.add(value.substring(0, i).padLeft(3, "0"));
        continue;
      }

      listOf3bits.add(binary.substring(i - 3, i));
    }
    listOf3bits = listOf3bits.reversed.toList();

    for (int i = 0; i < listOf3bits.length; i++) {
      int decimal = _toDecimal(listOf3bits[i]);
      result += decimal.toString();
    }

    return result;
  }

  @override
  String toDecimal() => _toDecimal(value).toString();

  @override
  String toHexadecimal() {
    String binary = value.toString();
    List<String> listOf4bits = [];
    String result = "";

    for (int i = binary.length; i > 0; i -= 4) {
      if (i < 4) {
        listOf4bits.add(value.substring(0, i).padLeft(4, "0"));
        continue;
      }

      listOf4bits.add(binary.substring(i - 4, i));
    }
    listOf4bits = listOf4bits.reversed.toList();

    for (int i = 0; i < listOf4bits.length; i++) {
      int decimal = _toDecimal(listOf4bits[i]);

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
