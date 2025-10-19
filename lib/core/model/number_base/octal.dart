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
    String result = "";
    int carry = 0;

    while (octalA.length < octalB.length) {
      octalA = "0$octalA";
    }
    while (octalA.length > octalB.length) {
      octalB = "0$octalB";
    }

    for (int i = octalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(octalA[i]);
      int digitB = int.parse(octalB[i]);

      int sum = digitA + digitB + carry;
      int newDigit = sum % 8;

      carry = sum ~/ 8;

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
  NumberBaseArithmeticResultModel subtraction(Octal other) {
    String octalA = value.toString();
    String octalB = other.value.toString();
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    int padLeft = octalA.length;
    if (padLeft < octalB.length) padLeft = octalB.length;

    while (octalA.length < octalB.length) {
      octalA = "0$octalA";
    }
    while (octalA.length > octalB.length) {
      octalB = "0$octalB";
    }

    if (octalA.compareTo(octalB) < 0) {
      isNegative = true;
      String temp = octalA;
      octalA = octalB;
      octalB = temp;
    }

    for (int i = octalA.length - 1; i >= 0; i--) {
      int digitA = int.parse(octalA[i]);
      int digitB = int.parse(octalB[i]);
      int newDigit;

      if (digitA - borrow < digitB) {
        newDigit = (digitA - borrow + 8 - digitB);
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
  NumberBaseArithmeticResultModel multiplication(Octal other) {
    String octalA = value.toString();
    String octalB = other.value.toString();
    String result = "0";
    List<String> subResult = [];

    String temp;
    int carry = 0;
    for (int i = octalB.length - 1; i >= 0; i--) {
      temp = "";
      for (int j = octalA.length - 1; j >= 0; j--) {
        int digitA = int.parse(octalA[j]);
        int digitB = int.parse(octalB[i]);
        int newDigit = digitA * digitB + carry;

        temp = "${newDigit % 8}$temp";
        carry = newDigit ~/ 8;
      }

      if (carry > 0) temp = "$carry$temp";

      subResult.add(temp);

      temp += "0" * (octalB.length - (i + 1));
      result = Octal(int.parse(result)).addition(Octal(int.parse(temp))).result;
      carry = 0;
    }

    int padLeft = octalA.length;
    if (padLeft < octalB.length) padLeft = octalB.length;
    if (padLeft < result.length) padLeft = result.length;
    padLeft += 2;

    String step = "${octalA.padLeft(padLeft)}\n";
    step += "${octalB.padLeft(padLeft)}\n";
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
  NumberBaseDivisionResultModel division(Octal other) {
    String dividendStr = value.toString();
    String divisorStr = other.value.toString();
    String quotient = "";
    String remainder = "";

    List<String> subtractor = [];
    List<String> subResult = [];

    int divisorDec = int.parse(divisorStr, radix: 8);
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

      int currentDec = int.parse(current, radix: 8);
      int q = currentDec ~/ divisorDec;
      int mul = q * divisorDec;
      int rem = currentDec - mul;

      quotient += q.toRadixString(8);
      remainder = rem.toRadixString(8);
      current = remainder;

      subtractor.add(mul.toRadixString(8));
      subResult.add(currentDec.toRadixString(8));
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
