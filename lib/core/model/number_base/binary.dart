part of 'number_base.dart';

final class Binary implements NumberBaseCovert {
  final base = NumberBaseType.binary;
  late String value;

  Binary(this.value) : assert(!(value.toString().contains(RegExp(r'[2-9]'))));

  NumberBaseResultModel _toDecimal(String value) {
    int result = 0;
    String step = "#Hitung dari belakang agar mudah#\n";
    int i = 0;

    for (int j = value.length - 1; j >= 0; j--) {
      num resultPerBit = int.parse(value[j]) * pow(2, i);
      result += resultPerBit.toInt();

      step += "${value[j]} * (2^$i) = $resultPerBit\n";

      i++;
    }

    step += "#Jumlahkan semua hasil#";

    return NumberBaseResultModel(
      result: result.toString(),
      step: step,
    );
  }

  @override
  NumberBaseResultModel toBinary() =>
      NumberBaseResultModel.noStep(value.toString());

  @override
  NumberBaseResultModel toOctal() {
    String binary = value.toString();
    String step = "#Pisahkan binary menjadi 3 bit dari belakang#\n";
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

    step += "$listOf3bits\n";
    step += "#Lalu ubah masing-masing 3 bit menjadi octal#\n";

    for (int i = 0; i < listOf3bits.length; i++) {
      int decimal = int.parse(_toDecimal(listOf3bits[i]).result);
      result += decimal.toString();

      step += "${listOf3bits[i]} = $decimal\n";
    }

    step += "#Gabungkan hasil konversi dari atas#";

    return NumberBaseResultModel(result: result, step: step);
  }

  @override
  NumberBaseResultModel toDecimal() => _toDecimal(value);

  @override
  NumberBaseResultModel toHexadecimal() {
    String binary = value.toString();
    String step = "#Pisahkan binary menjadi 4 bit dari belakang#\n";
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

    step += "$listOf4bits\n";
    step += "#Lalu ubah masing-masing 4 bit menjadi hexadecimal#\n";

    for (int i = 0; i < listOf4bits.length; i++) {
      int decimal = int.parse(_toDecimal(listOf4bits[i]).result);

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

    return NumberBaseResultModel(result: result, step: step);
  }
}
