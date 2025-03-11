part of 'number_base.dart';

final class Decimal implements NumberBaseCovert {
  final base = NumberBaseType.decimal;
  int value;

  Decimal(this.value);

  NumberBaseResultModel _convertByBase(int base) {
    int value = this.value;
    String result = "";
    String step =
        "#Lakukan pembagian dengan basis angka yang diinginkan lalu ambil sisa pembagian#\n";
    int remainder;

    do {
      remainder = value % base;
      step += "$value / $base = ";

      value ~/= base;
      step += "$value, sisa $remainder";

      if (base == 16 && remainder > 9) {
        String letter = String.fromCharCode(remainder + 55);
        result += letter;
        step += " -> $letter";
      } else {
        result += remainder.toString();
      }

      step += "\n";
    } while (value != 0);

    step += "#Urutkan dari bawah#";

    return NumberBaseResultModel(
      result: result.reverse(),
      step: step,
    );
  }

  @override
  NumberBaseResultModel toBinary() => _convertByBase(NumberBaseType.binary);

  @override
  NumberBaseResultModel toOctal() => _convertByBase(NumberBaseType.octal);

  @override
  NumberBaseResultModel toDecimal() =>
      NumberBaseResultModel.noStep(value.toString());

  @override
  NumberBaseResultModel toHexadecimal() =>
      _convertByBase(NumberBaseType.hexadecimal);
}
