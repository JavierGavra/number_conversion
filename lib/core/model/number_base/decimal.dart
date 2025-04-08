part of 'number_base.dart';

final class Decimal implements NumberBaseCovert, NumberBaseArithmetic<Decimal> {
  final base = NumberBaseType.decimal;
  int value;

  Decimal(this.value);

  NumberBaseConvertResultModel _convertByBase(int base) {
    int value = this.value;
    String result = "";
    String step =
        "#Lakukan pembagian dengan basis angka yang dituju lalu ambil sisa pembagian#\n";
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

    return NumberBaseConvertResultModel(
      initialValue: this.value.toString(),
      fromBase: this.base,
      toBase: base,
      result: result.reverse(),
      step: step,
    );
  }

  @override
  NumberBaseConvertResultModel toBinary() =>
      _convertByBase(NumberBaseType.binary);

  @override
  NumberBaseConvertResultModel toOctal() =>
      _convertByBase(NumberBaseType.octal);

  @override
  NumberBaseConvertResultModel toDecimal() =>
      NumberBaseConvertResultModel.noStep(
        initialValue: value.toString(),
        fromBase: base,
        toBase: NumberBaseType.decimal,
        result: value.toString(),
      );

  @override
  NumberBaseConvertResultModel toHexadecimal() =>
      _convertByBase(NumberBaseType.hexadecimal);

  @override
  NumberBaseArithmeticResultModel addition(Decimal other) {
    String decimalA = value.toString();
    String decimalB = other.value.toString();
    String step =
        "#Pastikan panjang kedua decimal sama. jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int carry = 0;

    while (decimalA.length < decimalB.length) {
      decimalA = "0$decimalA";
    }
    while (decimalA.length > decimalB.length) {
      decimalB = "0$decimalB";
    }

    step += "A: $decimalA\nB: $decimalB\n";
    step +=
        "#Lakukan penjumlahan dari kanan ke kiri dengan aturan basis angka 10#";
    step +=
        "#Jika hasil lebih dari 9, simpan kelebihan (carry) untuk ditambahkan ke angka berikutnya#\n";

    for (int i = decimalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(decimalA[i]);
      int digitB = int.parse(decimalB[i]);

      int sum = digitA + digitB + carry;
      int newDigit = sum % 10;
      step +=
          "Digit ke-${decimalA.length - i}: $digitA + $digitB + carry($carry) = $newDigit";

      carry = sum ~/ 10;
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
  NumberBaseArithmeticResultModel subtraction(Decimal other) {
    String decimalA = value.toString();
    String decimalB = other.value.toString();
    String step =
        "#Pastikan panjang kedua decimal sama. Jika tidak, tambahkan 0 di depan#\n";
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    while (decimalA.length < decimalB.length) {
      decimalA = "0$decimalA";
    }
    while (decimalA.length > decimalB.length) {
      decimalB = "0$decimalB";
    }

    step += "A: $decimalA\nB: $decimalB\n";

    if (decimalA.compareTo(decimalB) < 0) {
      step +=
          "#Karena A lebih kecil dari B, hasil akan negatif. Tukar A dan B lalu lanjutkan perhitungan#\n";
      isNegative = true;
      String temp = decimalA;
      decimalA = decimalB;
      decimalB = temp;
    }

    step +=
        "#Lakukan pengurangan dari kanan ke kiri dengan aturan basis angka 10#";
    step +=
        "#Jika pada digit ke-n nilai A kurang dari B, maka pinjam 1 dari kiri#\n";

    for (int i = decimalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(decimalA[i]);
      int digitB = int.parse(decimalB[i]);
      int newDigit;

      step +=
          "Digit ke-${decimalA.length - i}: $digitA - borrow($borrow) - $digitB = ";

      if (digitA - borrow < digitB) {
        newDigit = (digitA - borrow + 10 - digitB);
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
  NumberBaseArithmeticResultModel multiplication(Decimal other) {
    String decimalA = value.toString();
    String decimalB = other.value.toString();
    String step =
        "#Kalikan setiap digit dari Decimal B ke Decimal A satu per satu dengan aturan basis 10#";
    String result = "0";

    step += "#Tambahkan 0 dibelakang hasil setiap hasil baru#\n";

    String temp;
    int carry = 0;
    for (int i = decimalA.length - 1; i >= 0; i--) {
      temp = "0" * (decimalA.length - (i + 1));
      for (int j = decimalB.length - 1; j >= 0; j--) {
        int digitA = int.parse(decimalA[i]);
        int digitB = int.parse(decimalB[j]);
        int newDigit = digitA * digitB + carry;

        temp = "${newDigit % 10}$temp";
        carry = newDigit ~/ 10;
      }

      if (carry > 0) temp = "$carry$temp";

      step += "Decimal B * Decimal A index-$i = $temp\n";
      result =
          Decimal(int.parse(result)).addition(Decimal(int.parse(temp))).result;
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
  NumberBaseDivisionResultModel division(Decimal other) {
    String dividendStr = value.toString();
    String divisorStr = other.value.toString();
    String step = "\n";
    String quotient = "";

    int divisor = int.parse(divisorStr);
    if (divisor == 0) {
      return NumberBaseDivisionResultModel(
        base: base,
        operator: "/",
        result: "Tidak bisa membagi dengan 0",
        remainder: "0",
        step: "#Tidak bisa membagi dengan 0#",
      );
    }

    step += "Dividend: $dividendStr\n";
    step += "Divisor : $divisorStr\n";
    step += "#Menggunakan metode porogapit#\n";

    String current = "";
    for (int i = 0; i < dividendStr.length; i++) {
      current += dividendStr[i];

      current = current.replaceFirst(RegExp(r"^0+"), "");
      if (current.isEmpty) current = "0";

      int currentNum = int.parse(current);
      if (currentNum < divisor) {
        quotient += "0";
        step +=
            "Ambil: ${dividendStr.substring(0, i + 1).padLeft(divisorStr.length)} "
            "→ $currentNum < $divisor → Quotient: 0\n";
      } else {
        int q = currentNum ~/ divisor;
        int mul = q * divisor;
        int remainder = currentNum - mul;
        quotient += q.toString();
        step +=
            "Ambil: ${dividendStr.substring(0, i + 1).padLeft(divisorStr.length)} "
            "→ $currentNum ≥ $divisor → $currentNum ÷ $divisor = $q sisa $remainder\n";
        current = remainder.toString();
      }
    }

    quotient = quotient.replaceFirst(RegExp(r"^0+"), "");
    if (quotient.isEmpty) quotient = "0";

    step += "\nQuotient: $quotient";
    if (int.parse(current) != 0) {
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
