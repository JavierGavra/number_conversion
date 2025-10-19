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
    String result = "";
    int carry = 0;

    while (decimalA.length < decimalB.length) {
      decimalA = "0$decimalA";
    }
    while (decimalA.length > decimalB.length) {
      decimalB = "0$decimalB";
    }

    for (int i = decimalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(decimalA[i]);
      int digitB = int.parse(decimalB[i]);

      int sum = digitA + digitB + carry;
      int newDigit = sum % 10;

      carry = sum ~/ 10;

      result = newDigit.toString() + result;
    }

    if (carry > 0) result = "$carry$result";

    int padLeft = result.length + 2;
    String step = "${value.toString().padLeft(padLeft)}\n";
    step += "${other.value.toString().padLeft(padLeft)}\n";
    step += "  ${"-" * (padLeft - 2)} +\n";
    step += result.padLeft(padLeft);

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
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    int padLeft = decimalA.length;
    if (padLeft < decimalB.length) padLeft = decimalB.length;

    while (decimalA.length < decimalB.length) {
      decimalA = "0$decimalA";
    }
    while (decimalA.length > decimalB.length) {
      decimalB = "0$decimalB";
    }

    if (decimalA.compareTo(decimalB) < 0) {
      isNegative = true;
      String temp = decimalA;
      decimalA = decimalB;
      decimalB = temp;
    }

    for (int i = decimalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(decimalA[i]);
      int digitB = int.parse(decimalB[i]);
      int newDigit;

      if (digitA - borrow < digitB) {
        newDigit = (digitA - borrow + 10 - digitB);
        borrow = 1;
      } else {
        newDigit = (digitA - borrow - digitB);
        borrow = 0;
      }
      result = "$newDigit$result";
    }

    result = result.replaceFirst(RegExp(r'^0+'), '');
    if (result.isEmpty) result = "0";

    if (isNegative) result = "-$result";

    if (padLeft < result.length) padLeft = result.length;
    padLeft += 2;
    String step = "${value.toString().padLeft(padLeft)}\n";
    step += "${other.value.toString().padLeft(padLeft)}\n";
    step += "  ${"-" * (padLeft - 2)} -\n";
    step += result.padLeft(padLeft);

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
    String result = "0";
    List<String> subResult = [];

    String temp;
    int carry = 0;
    for (int i = decimalB.length - 1; i >= 0; i--) {
      temp = "";
      for (int j = decimalA.length - 1; j >= 0; j--) {
        int digitA = int.parse(decimalA[j]);
        int digitB = int.parse(decimalB[i]);
        int newDigit = digitA * digitB + carry;

        temp = "${newDigit % 10}$temp";
        carry = newDigit ~/ 10;
      }

      if (carry > 0) temp = "$carry$temp";

      subResult.add(temp);

      temp += "0" * (decimalB.length - (i + 1));
      result =
          Decimal(int.parse(result)).addition(Decimal(int.parse(temp))).result;
      carry = 0;
    }

    int padLeft = decimalA.length;
    if (padLeft < decimalB.length) padLeft = decimalB.length;
    if (padLeft < result.length) padLeft = result.length;
    padLeft += 2;

    String step = "${decimalA.padLeft(padLeft)}\n";
    step += "${decimalB.padLeft(padLeft)}\n";
    step += "  ${"-" * (padLeft - 2)} x\n";
    for (int i = 0; i < subResult.length; i++) {
      step += "${subResult[i].padLeft(padLeft - i)}\n";
    }
    step += "  ${"-" * (padLeft - 2)} +\n";
    step += result.padLeft(padLeft);

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
    String quotient = "";
    int remainder = 0;

    List<String> subtractor = [];
    List<String> subResult = [];

    int divisor = int.parse(divisorStr);
    if (divisor == 0) {
      return NumberBaseDivisionResultModel(
        base: base,
        operator: "/",
        result: "Tidak bisa membagi dengan 0",
        remainder: "0",
        step: "Tidak bisa membagi dengan 0",
      );
    }

    String current = "";
    for (int i = 0; i < dividendStr.length; i++) {
      current += dividendStr[i];

      current = current.replaceFirst(RegExp(r"^0+"), "");
      if (current.isEmpty) current = "0";

      int currentNum = int.parse(current);
      int q = currentNum ~/ divisor;
      int mul = q * divisor;
      remainder = currentNum - mul;
      quotient += q.toString();
      current = remainder.toString();

      subtractor.add(mul.toString());
      subResult.add(currentNum.toString());
    }

    String headStep = "$divisorStr/$dividendStr";
    int padLeft = headStep.length;

    String step = "${quotient.padLeft(padLeft)}\n";
    step += "${("-" * dividendStr.length).padLeft(padLeft)}\n";
    step += "${headStep.padLeft(padLeft)}${" " * (divisorStr.length + 1)}\n";
    for (int i = 0; i < subtractor.length; i++) {
      int padLeftLimit = (subtractor.length - i - 1);
      step += "${subtractor[i].padLeft(padLeft - padLeftLimit)}\n";
      step += "${("-" * dividendStr.length).padLeft(padLeft)} -\n";

      if (i < subResult.length - 1) {
        step += "${subResult[i + 1].padLeft(padLeft - (padLeftLimit - 1))}\n";
      }
    }
    step += remainder.toString().padLeft(padLeft);

    quotient = quotient.replaceFirst(RegExp(r"^0+"), "");
    if (quotient.isEmpty) quotient = "0";

    return NumberBaseDivisionResultModel(
      base: base,
      operator: "/",
      result: quotient,
      remainder: current,
      step: step,
    );
  }
}
