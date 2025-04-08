part of 'number_base.dart';

final class Binary implements NumberBaseCovert, NumberBaseArithmetic<Binary> {
  final base = NumberBaseType.binary;
  late String value;

  Binary(this.value) : assert(!(value.toString().contains(RegExp(r'[2-9]'))));

  NumberBaseConvertResultModel _toDecimal(String value) {
    int result = 0;
    String step = "#Hitung dari kanan agar mudah#\n";
    int i = 0;

    for (int j = value.length - 1; j >= 0; j--) {
      num resultPerBit = int.parse(value[j]) * pow(2, i);
      result += resultPerBit.toInt();

      step += "${value[j]} * (2^$i) = $resultPerBit\n";

      i++;
    }

    step += "#Jumlahkan semua hasil#";

    return NumberBaseConvertResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.decimal,
      result: result.toString(),
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toBinary() =>
      NumberBaseConvertResultModel.noStep(
        initialValue: value,
        fromBase: base,
        toBase: NumberBaseType.binary,
        result: value,
      );

  @override
  NumberBaseConvertResultModel toOctal() {
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

    return NumberBaseConvertResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.octal,
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toDecimal() => _toDecimal(value);

  @override
  NumberBaseConvertResultModel toHexadecimal() {
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

    return NumberBaseConvertResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.hexadecimal,
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseArithmeticResultModel addition(Binary other) {
    String binaryA = value;
    String binaryB = other.value;
    String step =
        "#Pastikan panjang kedua binary sama. jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int carry = 0;

    while (binaryA.length < binaryB.length) {
      binaryA = "0$binaryA";
    }
    while (binaryA.length > binaryB.length) {
      binaryB = "0$binaryB";
    }

    step += "A: $binaryA\nB: $binaryB\n";
    step +=
        "#Lakukan penjumlahan dari kanan ke kiri dengan aturan basis angka 2#";
    step +=
        "#Jika hasil lebih dari 1, simpan kelebihan (carry) untuk ditambahkan ke angka berikutnya#\n";

    for (int i = binaryA.length - 1; i >= 0; i--) {
      int bitA = int.parse(binaryA[i]);
      int bitB = int.parse(binaryB[i]);

      int sum = bitA + bitB + carry;
      int newBit = sum % 2;
      step +=
          "Digit ke-${binaryA.length - i}: $bitA + $bitB + carry($carry) = $newBit";

      carry = sum ~/ 2;
      if (carry > 0) step += " -> simpan $carry";

      result = newBit.toString() + result;
      step += "\n";
    }

    step += "#Susun angka dari bawah#";

    if (carry > 0) {
      step += "#Karena carry masih memiliki nilai, tambahkan carry di depan#";
      result = "$carry$result";
    }

    return NumberBaseArithmeticResultModel(
      base: base,
      operator: "+",
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseArithmeticResultModel subtraction(Binary other) {
    String binaryA = value;
    String binaryB = other.value;
    String step =
        "#Pastikan panjang kedua binary sama. Jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    while (binaryA.length < binaryB.length) {
      binaryA = "0$binaryA";
    }
    while (binaryA.length > binaryB.length) {
      binaryB = "0$binaryB";
    }

    step += "A: $binaryA\nB: $binaryB\n";

    if (binaryA.compareTo(binaryB) < 0) {
      step +=
          "#Karena A lebih kecil dari B, hasil akan negatif. Tukar A dan B lalu lanjutkan perhitungan#\n";
      isNegative = true;
      String temp = binaryA;
      binaryA = binaryB;
      binaryB = temp;
    }

    step +=
        "#Lakukan pengurangan dari kanan ke kiri dengan aturan basis angka 2#";
    step +=
        "#Jika pada digit ke-n nilai A kurang dari B, maka pinjam 1 dari kiri#\n";

    for (int i = binaryA.length - 1; i >= 0; i--) {
      int bitA = int.parse(binaryA[i]);
      int bitB = int.parse(binaryB[i]);
      int newDigit;

      step +=
          "Digit ke-${binaryA.length - i}: $bitA - borrow($borrow) - $bitB = ";

      if (bitA - borrow < bitB) {
        newDigit = (bitA - borrow + 2 - bitB);
        step += "(pinjam 1) → $newDigit\n";
        borrow = 1;
      } else {
        newDigit = (bitA - borrow - bitB);
        step += "$newDigit\n";
        borrow = 0;
      }
      result = "$newDigit$result";
    }

    result = result.replaceFirst(RegExp(r'^0+'), '');
    if (result.isEmpty) result = "0";

    if (isNegative) result = "- $result";

    step += "#Susun angka dari bawah#";

    return NumberBaseArithmeticResultModel(
      base: base,
      operator: "-",
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseArithmeticResultModel multiplication(Binary other) {
    String binaryA = value;
    String binaryB = other.value;
    String step =
        "#Kalikan setiap digit dari Binary B ke Binary A satu per satu dengan aturan basis 2#";
    String result = "0";

    step += "#Tambahkan 0 dibelakang hasil sepanjang index#\n";

    String temp;
    for (int i = binaryA.length - 1; i >= 0; i--) {
      temp = "0" * (binaryA.length - (i + 1));
      for (int j = binaryB.length - 1; j >= 0; j--) {
        int digitA = int.parse(binaryA[i]);
        int digitB = int.parse(binaryB[j]);
        temp = "${digitA * digitB}$temp";
      }
      step += "Binary B * Binary A index-$i = $temp\n";
      result = Binary(result).addition(Binary(temp)).result;
    }

    step += "#Jumlahkan semua hasil#";

    return NumberBaseArithmeticResultModel(
      base: base,
      operator: "*",
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseArithmeticResultModel division(Binary other) {
    // TODO: implement /
    throw UnimplementedError();
  }
}
