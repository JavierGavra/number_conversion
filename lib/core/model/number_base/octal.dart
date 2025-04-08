part of 'number_base.dart';

final class Octal implements NumberBaseCovert, NumberBaseArithmetic<Octal> {
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
  NumberBaseConvertResultModel toBinary() {
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

    return NumberBaseConvertResultModel(
      initialValue: value.toString(),
      fromBase: base,
      toBase: NumberBaseType.binary,
      result: result == "000" ? "0" : result.replaceFirst(RegExp(r'^0+'), ''),
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toOctal() => NumberBaseConvertResultModel.noStep(
        initialValue: value.toString(),
        fromBase: base,
        toBase: NumberBaseType.octal,
        result: value.toString(),
      );

  @override
  NumberBaseConvertResultModel toDecimal() {
    String octal = value.toString();
    int result = 0;
    String step = "#Hitung dari kanan agar mudah#\n";
    int i = 0;

    for (int j = octal.length - 1; j >= 0; j--) {
      num resultPerDecimal = int.parse(octal[j]) * pow(8, i);
      result += resultPerDecimal.toInt();

      step += "${octal[j]} * (8^$i) = $resultPerDecimal\n";

      i++;
    }

    step += "#Jumlahkan semua hasil#";

    return NumberBaseConvertResultModel(
      initialValue: value.toString(),
      fromBase: base,
      toBase: NumberBaseType.decimal,
      result: result.toString(),
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toHexadecimal() {
    NumberBaseConvertResultModel binary = toBinary();
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

    return NumberBaseConvertResultModel(
      initialValue: value.toString(),
      fromBase: base,
      toBase: NumberBaseType.hexadecimal,
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseArithmeticResultModel addition(Octal other) {
    String octalA = value.toString();
    String octalB = other.value.toString();
    String step =
        "#Pastikan panjang kedua octal sama. jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int carry = 0;

    while (octalA.length < octalB.length) {
      octalA = "0$octalA";
    }
    while (octalA.length > octalB.length) {
      octalB = "0$octalB";
    }

    step += "A: $octalA\nB: $octalB\n";
    step +=
        "#Lakukan penjumlahan dari kanan ke kiri dengan aturan basis angka 8#";
    step +=
        "#Jika hasil lebih dari 7, simpan kelebihan (carry) untuk ditambahkan ke angka berikutnya#\n";

    for (int i = octalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(octalA[i]);
      int digitB = int.parse(octalB[i]);

      int sum = digitA + digitB + carry;
      int newDigit = sum % 8;
      step +=
          "Digit ke-${octalA.length - i}: $digitA + $digitB + carry($carry) = $newDigit";

      carry = sum ~/ 8;
      if (carry > 0) step += " -> simpan $carry";

      result = newDigit.toString() + result;
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
  NumberBaseArithmeticResultModel subtraction(Octal other) {
    String octalA = value.toString();
    String octalB = other.value.toString();
    String step =
        "#Pastikan panjang kedua octal sama. jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    while (octalA.length < octalB.length) {
      octalA = "0$octalA";
    }
    while (octalA.length > octalB.length) {
      octalB = "0$octalB";
    }

    step += "A: $octalA\nB: $octalB\n";

    if (octalA.compareTo(octalB) < 0) {
      step +=
          "#Karena A lebih kecil dari B, hasil akan negatif. Tukar A dan B lalu lanjutkan perhitungan#\n";
      isNegative = true;
      String temp = octalA;
      octalA = octalB;
      octalB = temp;
    }

    step +=
        "#Lakukan pengurangan dari kanan ke kiri dengan aturan basis angka 8#";
    step +=
        "#Jika pada digit ke-n nilai A kurang dari B, maka pinjam 1 dari kiri#\n";

    for (int i = octalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(octalA[i]);
      int digitB = int.parse(octalB[i]);
      int newDigit;

      step +=
          "Digit ke-${octalA.length - i}: $digitA - borrow($borrow) - $digitB = ";

      if (digitA - borrow < digitB) {
        newDigit = (digitA - borrow + 8 - digitB);
        step += "(pinjam 1) → $newDigit\n";
        borrow = 1;
      } else {
        newDigit = (digitA - borrow - digitB);
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
  NumberBaseArithmeticResultModel multiplication(Octal other) {
    String octalA = value.toString();
    String octalB = other.value.toString();
    String step =
        "#Kalikan setiap digit dari Octal B ke Octal A satu per satu dengan aturan basis 8#";
    String result = "0";

    step += "#Tambahkan 0 dibelakang hasil setiap hasil baru#\n";

    String temp;
    int carry = 0;
    for (int i = octalA.length - 1; i >= 0; i--) {
      temp = "0" * (octalA.length - (i + 1));
      for (int j = octalB.length - 1; j >= 0; j--) {
        int digitA = int.parse(octalA[i]);
        int digitB = int.parse(octalB[j]);
        int newDigit = digitA * digitB + carry;

        temp = "${newDigit % 8}$temp";
        carry = newDigit ~/ 8;
      }

      if (carry > 0) temp = "$carry$temp";

      step += "Octal B * Octal A index-$i = $temp\n";
      result = Octal(int.parse(result)).addition(Octal(int.parse(temp))).result;
      carry = 0;
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
  NumberBaseArithmeticResultModel division(Octal other) {
    String dividend = value.toString();
    String divisor = other.value.toString();
    String quotient = "";
    String step = "\n";

    if (divisor.replaceAll("0", "") == "") {
      return NumberBaseDivisionResultModel(
        base: base,
        operator: "/",
        result: "Tidak bisa membagi dengan 0",
        remainder: "0",
        step: "#Tidak bisa membagi dengan 0#",
      );
    }

    step += "Dividend: $dividend\n";
    step += "Divisor : $divisor\n";
    step += "#Menggunakan metode porogapit (Long Division)#\n";

    String current = "";
    int index = 0;

    while (index < dividend.length) {
      current += dividend[index];
      current = current.replaceFirst(RegExp(r"^0+"), "");

      int currentVal = int.parse(current, radix: 8);
      int divisorVal = int.parse(divisor, radix: 8);

      if (currentVal < divisorVal) {
        quotient += "0";
        step +=
            "Ambil: ${dividend.substring(0, index + 1).padLeft(divisor.length)} "
            "→ $current < $divisor → Quotient: 0\n";
      } else {
        int q = currentVal ~/ divisorVal;
        int mul = q * divisorVal;
        int remainder = currentVal - mul;

        String subtracted = remainder.toRadixString(8);
        quotient += q.toRadixString(8);
        step +=
            "Ambil: ${dividend.substring(0, index + 1).padLeft(divisor.length)} "
            "→ $current ≥ $divisor → Kurangkan: $current - $divisor = $subtracted "
            "→ Quotient: ${q.toRadixString(8)}\n";

        current = subtracted;
      }

      index++;
    }

    quotient = quotient.replaceFirst(RegExp(r"^0+"), "");
    if (quotient.isEmpty) quotient = "0";

    step += "\nQuotient: $quotient";
    if (current.isNotEmpty && current != "0") {
      step += "\nSisa: $current";
    }

    step += "\n#Hasil Akhir#";

    return NumberBaseDivisionResultModel(
      base: base,
      operator: "/",
      result: quotient,
      remainder: current,
      step: step,
    );
  }
}
