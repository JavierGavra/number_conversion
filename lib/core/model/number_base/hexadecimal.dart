part of 'number_base.dart';

final class Hexadecimal
    implements NumberBaseCovert, NumberBaseArithmetic<Hexadecimal> {
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

  String _decimalToHexChar(int decimal) {
    return (decimal > 9) ? String.fromCharCode(decimal + 55) : "$decimal";
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
  NumberBaseConvertResultModel toBinary() {
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

    return NumberBaseConvertResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.binary,
      result: result == "0000" ? "0" : result.replaceFirst(RegExp(r'^0+'), ''),
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toOctal() {
    NumberBaseConvertResultModel binary = toBinary();
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

    return NumberBaseConvertResultModel(
      initialValue: value,
      fromBase: base,
      toBase: NumberBaseType.octal,
      result: result,
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toDecimal() {
    String hexadecimal = value;
    int result = 0;
    String step = "#Konversi masing-masing hexadecimal menjadi decimal#\n";
    int i = 0;
    List<int> listOfDecimal = [];

    for (int j = 0; j < hexadecimal.length; j++) {
      listOfDecimal.add(_hexCharToDecimal(hexadecimal[j]));
      step += "${hexadecimal[j]} = ${listOfDecimal[j]}\n";
    }

    step += "\n$listOfDecimal\n";
    step += "#Lalu hitung dari kanan agar mudah#\n";

    for (int j = hexadecimal.length - 1; j >= 0; j--) {
      num resultPerDecimal = listOfDecimal[j] * pow(16, i);
      result += resultPerDecimal.toInt();

      step += "${listOfDecimal[j]} * (16^$i) = $resultPerDecimal\n";

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
  NumberBaseConvertResultModel toHexadecimal() =>
      NumberBaseConvertResultModel.noStep(
        initialValue: value,
        fromBase: base,
        toBase: NumberBaseType.hexadecimal,
        result: value,
      );

  @override
  NumberBaseArithmeticResultModel addition(Hexadecimal other) {
    String hexadecimalA = value.toString();
    String hexadecimalB = other.value.toString();
    String step =
        "#Pastikan panjang kedua hexadecimal sama. jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int carry = 0;

    while (hexadecimalA.length < hexadecimalB.length) {
      hexadecimalA = "0$hexadecimalA";
    }
    while (hexadecimalA.length > hexadecimalB.length) {
      hexadecimalB = "0$hexadecimalB";
    }

    step += "A: $hexadecimalA\nB: $hexadecimalB\n";
    step +=
        "#Lakukan penjumlahan dari kanan ke kiri dengan aturan basis angka 16#";
    step +=
        "#Jika hasil lebih dari 15 (F), simpan kelebihan (carry) untuk ditambahkan ke angka berikutnya#\n";

    for (int i = hexadecimalA.length - 1; i >= 0; i--) {
      int digitA = _hexCharToDecimal(hexadecimalA[i]);
      int digitB = _hexCharToDecimal(hexadecimalB[i]);

      int sum = digitA + digitB + carry;
      int newDigit = sum % 16;
      step +=
          "Digit ke-${hexadecimalA.length - i}: $digitA + $digitB + carry($carry) = $newDigit";

      carry = sum ~/ 16;
      if (carry > 0) step += " -> simpan $carry";

      result = _decimalToHexChar(newDigit) + result;
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
  NumberBaseArithmeticResultModel subtraction(Hexadecimal other) {
    String hexadecimalA = value.toString();
    String hexadecimalB = other.value.toString();
    String step =
        "#Pastikan panjang kedua hexadecimal sama. jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    while (hexadecimalA.length < hexadecimalB.length) {
      hexadecimalA = "0$hexadecimalA";
    }
    while (hexadecimalA.length > hexadecimalB.length) {
      hexadecimalB = "0$hexadecimalB";
    }

    step += "A: $hexadecimalA\nB: $hexadecimalB\n";

    if (hexadecimalA.compareTo(hexadecimalB) < 0) {
      step +=
          "#Karena A lebih kecil dari B, hasil akan negatif. Tukar A dan B lalu lanjutkan perhitungan#\n";
      isNegative = true;
      String temp = hexadecimalA;
      hexadecimalA = hexadecimalB;
      hexadecimalB = temp;
    }

    step +=
        "#Lakukan pengurangan dari kanan ke kiri dengan aturan basis angka 16#";
    step +=
        "#Jika pada digit ke-n nilai A kurang dari B, maka pinjam 1 dari kiri#\n";

    for (int i = hexadecimalA.length - 1; i >= 0; i--) {
      int digitA = _hexCharToDecimal(hexadecimalA[i]);
      int digitB = _hexCharToDecimal(hexadecimalB[i]);
      int newDigit;

      step +=
          "Digit ke-${hexadecimalA.length - i}: $digitA - borrow($borrow) - $digitB = ";

      if (digitA - borrow < digitB) {
        newDigit = (digitA - borrow + 16 - digitB);
        step += "(pinjam 1) → $newDigit\n";
        borrow = 1;
      } else {
        newDigit = (digitA - borrow - digitB);
        step += "$newDigit\n";
        borrow = 0;
      }
      result = _decimalToHexChar(newDigit) + result;
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
  NumberBaseArithmeticResultModel multiplication(Hexadecimal other) {
    String hexadecimalA = value;
    String hexadecimalB = other.value;
    String step =
        "#Kalikan setiap digit dari Hexadecimal B ke Hexadecimal A satu per satu dengan aturan basis 8#";
    String result = "0";

    step += "#Tambahkan 0 dibelakang hasil setiap hasil baru#\n";

    String temp;
    int carry = 0;
    for (int i = hexadecimalA.length - 1; i >= 0; i--) {
      temp = "0" * (hexadecimalA.length - (i + 1));
      for (int j = hexadecimalB.length - 1; j >= 0; j--) {
        int digitA = _hexCharToDecimal(hexadecimalA[i]);
        int digitB = _hexCharToDecimal(hexadecimalB[j]);
        int newDigit = digitA * digitB + carry;

        temp = "${_decimalToHexChar(newDigit % 16)}$temp";
        carry = newDigit ~/ 16;
      }

      if (carry > 0) temp = "$carry$temp";

      step += "Hexadecimal B * Hexadecimal A index-$i = $temp\n";
      result = Hexadecimal(result).addition(Hexadecimal(temp)).result;
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
  NumberBaseArithmeticResultModel division(Hexadecimal other) {
    String dividend = value.toUpperCase();
    String divisor = other.value.toUpperCase();
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
      current = current.replaceFirst(RegExp(r"^0+"), ""); // Hapus nol di depan

      if (current.isEmpty) {
        quotient += "0";
        index++;
        continue;
      }

      int currentVal = int.parse(current, radix: 16);
      int divisorVal = int.parse(divisor, radix: 16);

      if (currentVal < divisorVal) {
        quotient += "0";
        step +=
            "Ambil: ${dividend.substring(0, index + 1).padLeft(divisor.length)} "
            "→ $current < $divisor → Quotient: 0\n";
      } else {
        int q = currentVal ~/ divisorVal;
        int mul = q * divisorVal;
        int remainder = currentVal - mul;

        String subtracted = remainder.toRadixString(16).toUpperCase();
        quotient += q.toRadixString(16).toUpperCase();

        step +=
            "Ambil: ${dividend.substring(0, index + 1).padLeft(divisor.length)} "
            "→ $current ≥ $divisor → Kurangkan: $current - $divisor = $subtracted "
            "→ Quotient: ${q.toRadixString(16).toUpperCase()}\n";

        current = subtracted;
      }

      index++;
    }

    // Hapus leading zero dari hasil
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
