part of 'number_base.dart';

final class Decimal implements NumberBaseCovert {
  final base = NumberBaseType.decimal;
  int value;

  Decimal(this.value);

  String _convertByBase(int base) {
    int value = this.value;
    String result = "";
    int remainder;

    do {
      remainder = value % base;
      value ~/= base;

      if (base == 16 && remainder > 9) {
        result += String.fromCharCode(remainder + 55);
      } else {
        result += remainder.toString();
      }
    } while (value != 0);

    return result.reverse();
  }

  @override
  String toBinary() => _convertByBase(NumberBaseType.binary);

  @override
  String toOctal() => _convertByBase(NumberBaseType.octal);

  @override
  String toDecimal() => value.toString();

  @override
  String toHexadecimal()  => _convertByBase(NumberBaseType.hexadecimal);
}