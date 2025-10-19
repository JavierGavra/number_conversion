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
    String result = "";
    int carry = 0;

    while (binaryA.length < binaryB.length) {
      binaryA = "0$binaryA";
    }
    while (binaryA.length > binaryB.length) {
      binaryB = "0$binaryB";
    }

    for (int i = binaryA.length - 1; i >= 0; i--) {
      int bitA = int.parse(binaryA[i]);
      int bitB = int.parse(binaryB[i]);

      int sum = bitA + bitB + carry;
      int newBit = sum % 2;

      carry = sum ~/ 2;

      result = newBit.toString() + result;
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
  NumberBaseArithmeticResultModel subtraction(Binary other) {
    String binaryA = value;
    String binaryB = other.value;
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    int padLeft = binaryA.length;
    if (padLeft < binaryB.length) padLeft = binaryB.length;

    while (binaryA.length < binaryB.length) {
      binaryA = "0$binaryA";
    }
    while (binaryA.length > binaryB.length) {
      binaryB = "0$binaryB";
    }

    if (binaryA.compareTo(binaryB) < 0) {
      isNegative = true;
      String temp = binaryA;
      binaryA = binaryB;
      binaryB = temp;
    }

    for (int i = binaryA.length - 1; i >= 0; i--) {
      int bitA = int.parse(binaryA[i]);
      int bitB = int.parse(binaryB[i]);
      int newDigit;

      if (bitA - borrow < bitB) {
        newDigit = (bitA - borrow + 2 - bitB);
        borrow = 1;
      } else {
        newDigit = (bitA - borrow - bitB);
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
  NumberBaseArithmeticResultModel multiplication(Binary other) {
    String binaryA = value;
    String binaryB = other.value;
    String result = "0";
    List<String> subResult = [];

    String temp;
    for (int i = binaryB.length - 1; i >= 0; i--) {
      temp = "";
      for (int j = binaryA.length - 1; j >= 0; j--) {
        int digitA = int.parse(binaryA[j]);
        int digitB = int.parse(binaryB[i]);
        temp = "${digitA * digitB}$temp";
      }

      subResult.add(temp);

      temp += "0" * (binaryB.length - (i + 1));
      result = Binary(result).addition(Binary(temp)).result;
    }

    int padLeft = binaryA.length;
    if (padLeft < binaryB.length) padLeft = binaryB.length;
    if (padLeft < result.length) padLeft = result.length;
    padLeft += 2;

    String step = "${binaryA.padLeft(padLeft)}\n";
    step += "${binaryB.padLeft(padLeft)}\n";
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
  NumberBaseDivisionResultModel division(Binary other) {
    String dividendStr = value.toString();
    String divisorStr = other.value.toString();
    String quotient = "";
    String remainder = "";

    List<String> subtractor = [];
    List<String> subResult = [];

    int divisorDec = int.parse(divisorStr, radix: 2);
    if (divisorDec == 0) {
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

      int currentDec = int.parse(current, radix: 2);
      int q = currentDec ~/ divisorDec;
      int mul = q * divisorDec;
      int rem = currentDec - mul;

      quotient += q.toString();
      remainder = rem.toRadixString(2);
      current = remainder;

      subtractor.add(mul.toRadixString(2));
      subResult.add(currentDec.toRadixString(2));
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
    step += remainder.padLeft(padLeft);

    quotient = quotient.replaceFirst(RegExp(r"^0+"), "");
    if (quotient.isEmpty) quotient = "0";

    return NumberBaseDivisionResultModel(
      base: base,
      operator: "/",
      result: quotient,
      remainder: remainder,
      step: step,
    );
  }
}
