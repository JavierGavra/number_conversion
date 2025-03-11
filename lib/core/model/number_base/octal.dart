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
  NumberBaseResultModel toBinary() {
    String octal = value.toString();
    String step = "#Ubah setiap elemen menjadi binary 3 bit#\n";
    String result = "";
    List<String> listOf3Bits = [];

    for (int i = 0; i < octal.length; i++) {
      listOf3Bits.add(_decimalToBinary(int.parse(octal[i])).padLeft(3, "0"));

      step += "${octal[i]} = ${listOf3Bits[i]}\n";
    }

    step += "\n$listOf3Bits\n";
    step += "#Lalu gabungkan masing-masing binary 3 bit menjadi 1 binary#";

    for (var element in listOf3Bits) {
      result += element;
    }

    return NumberBaseResultModel(
      initialValue: value.toString(),
      fromBase: base,
      toBase: NumberBaseType.binary,
      result: result == "000" ? "0" : result.replaceFirst(RegExp(r'^0+'), ''),
      step: step,
    );
  }

  @override
  NumberBaseResultModel toOctal() => NumberBaseResultModel.noStep(
        initialValue: value.toString(),
        fromBase: base,
        toBase: NumberBaseType.octal,
        result: value.toString(),
      );

  @override
  NumberBaseResultModel toDecimal() {
    String octal = value.toString();
    int result = 0;
    String step = "#Hitung dari belakang agar mudah#\n";
    int i = 0;

    for (int j = octal.length - 1; j >= 0; j--) {
      num resultPerDecimal = int.parse(octal[j]) * pow(8, i);
      result += resultPerDecimal.toInt();

      step += "${octal[j]} * (8^$i) = $resultPerDecimal\n";

      i++;
    }

    step += "#Jumlahkan semua hasil#";

    return NumberBaseResultModel(
      initialValue: value.toString(),
      fromBase: base,
      toBase: NumberBaseType.decimal,
      result: result.toString(),
      step: step,
    );
  }

  @override
  NumberBaseResultModel toHexadecimal() {
    NumberBaseResultModel binary = toBinary();
    String step = binary.step;
    String result = "";

    step += "\n${binary.result}\n";
    step += "#Lalu pisahkan binary menjadi 4 bit dari belakang#\n";
    List<String> listOf4bits = [];

    for (int i = binary.result.length; i > 0; i -= 4) {
      if (i < 4) {
        listOf4bits.add(binary.result.substring(0, i).padLeft(4, "0"));
        continue;
      }

      listOf4bits.add(binary.result.substring(i - 4, i));
    }
    listOf4bits = listOf4bits.reversed.toList();

    step += "$listOf4bits\n";
    step += "#Lalu ubah masing-masing 4 bit menjadi hexadecimal#\n";

    for (int i = 0; i < listOf4bits.length; i++) {
      int decimal = _binaryToDecimal(listOf4bits[i]);

      step += "${listOf4bits[i]} = $decimal";

      if (decimal > 9) {
        String letter = String.fromCharCode(decimal + 55);
        result += letter;
        step += " -> $letter";
      } else {
        result += decimal.toString();
      }

      step += "\n";
    }

    step += "#Gabungkan hasil konversi dari atas#";

    return NumberBaseResultModel(
      initialValue: value.toString(),
      fromBase: base,
      toBase: NumberBaseType.hexadecimal,
      result: result,
      step: step,
    );
  }
}
