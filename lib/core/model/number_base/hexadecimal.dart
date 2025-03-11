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
  NumberBaseResultModel toBinary() {
    String hexadecimal = value;
    String step = "#Ubah setiap elemen menjadi binary 4 bit#\n";
    String result = "";
    List<String> listOf4Bits = [];

    for (int i = 0; i < hexadecimal.length; i++) {
      int decimal = _hexCharToDecimal(hexadecimal[i]);
      listOf4Bits.add(_decimalToBinary(decimal).padLeft(4, "0"));

      step += "${hexadecimal[i]} = ${listOf4Bits[i]}\n";
    }

    step += "\n$listOf4Bits\n";
    step += "#Lalu gabungkan masing-masing binary 4 bit menjadi 1 binary#";

    for (var element in listOf4Bits) {
      result += element;
    }

    return NumberBaseResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.binary,
      result: result == "0000" ? "0" : result.replaceFirst(RegExp(r'^0+'), ''),
      step: step,
    );
  }

  @override
  NumberBaseResultModel toOctal() {
    NumberBaseResultModel binary = toBinary();
    String step = binary.step;
    String result = "";

    step += "\n${binary.result}\n";
    step += "#Lalu pisahkan binary menjadi 3 bit dari belakang#\n";
    List<String> listOf3bits = [];

    for (int i = binary.result.length; i > 0; i -= 3) {
      if (i < 3) {
        listOf3bits.add(binary.result.substring(0, i).padLeft(3, "0"));
        continue;
      }

      listOf3bits.add(binary.result.substring(i - 3, i));
    }
    listOf3bits = listOf3bits.reversed.toList();

    step += "$listOf3bits\n";
    step += "#Lalu ubah masing-masing 3 bit menjadi octal#\n";

    for (int i = 0; i < listOf3bits.length; i++) {
      int decimal = _binaryToDecimal(listOf3bits[i]);
      result += decimal.toString();

      step += "${listOf3bits[i]} = $decimal\n";
    }

    step += "#Gabungkan hasil konversi dari atas#";

    return NumberBaseResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.octal,
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseResultModel toDecimal() {
    String hexadecimal = value;
    int result = 0;
    String step = "#Konversi masing-masing hexadecimal menjadi decimal#\n";
    int i = 0;
    List<int> listOfDecimal = [];

    for (int j = 0; j < hexadecimal.length; j++) {
      listOfDecimal.add(_hexCharToDecimal(hexadecimal[j]));
      step += "${hexadecimal[j]} = ${listOfDecimal[j]}\n";
    }
    step += "#Lalu hitung dari belakang agar mudah#\n";

    for (int j = hexadecimal.length - 1; j >= 0; j--) {
      num resultPerDecimal = listOfDecimal[j] * pow(16, i);
      result += resultPerDecimal.toInt();

      step += "${listOfDecimal[j]} * (16^$i) = $resultPerDecimal\n";

      i++;
    }

    step += "#Jumlahkan semua hasil#";

    return NumberBaseResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.decimal,
      result: result.toString(),
      step: step,
    );
  }

  @override
  NumberBaseResultModel toHexadecimal() => NumberBaseResultModel.noStep(
        initialValue: value,
        fromBase: base,
        toBase: NumberBaseType.hexadecimal,
        result: value,
      );
}
