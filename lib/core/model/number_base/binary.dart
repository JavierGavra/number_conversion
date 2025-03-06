part of 'number_base.dart';

final class Binary implements NumberBaseCovert {
  final base = NumberBaseType.binary;
  late BigInt value;

  Binary(String value) {
    assert(!(value.toString().contains(RegExp(r'[2-9]'))));
    this.value = BigInt.parse(value);
  }

  BigInt _toDecimal(BigInt value) {
    BigInt result = BigInt.zero;
    BigInt base = BigInt.one;

    while (value != BigInt.zero) {
      result += (value % BigInt.from(10)) * base;
      value ~/= BigInt.from(10);
      base *= BigInt.from(this.base);
    }

    return result;
  }

  @override
  String toBinary() => value.toString();

  @override
  String toOctal() {
    String binary = value.toString();

    if (binary == "0") return "0";

    while (binary.length % 3 != 0) {
      binary = '0$binary';
    }

    String result = "";
    for (int i = 0; i < binary.length; i += 3) {
      result += BigInt.parse(binary.substring(i, i + 3), radix: 2).toString();
    }

    return result;
  }

  @override
  String toDecimal() => _toDecimal(value).toString();

  @override
  String toHexadecimal() {
    String binary = value.toString();
    if (binary == "0") return "0";
    while (binary.length % 4 != 0) {
      binary = '0$binary';
    }

    String result = "";
    for (int i = 0; i < binary.length; i += 4) {
      int decimal = int.parse(binary.substring(i, i + 4), radix: 2);
      if (decimal > 9) {
        result += String.fromCharCode(decimal + 55);
      } else {
        result += decimal.toString();
      }
    }
    return result;
  }
}
