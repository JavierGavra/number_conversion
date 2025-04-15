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
    String result = "";
    int carry = 0;

    while (hexadecimalA.length < hexadecimalB.length) {
      hexadecimalA = "0$hexadecimalA";
    }
    while (hexadecimalA.length > hexadecimalB.length) {
      hexadecimalB = "0$hexadecimalB";
    }

    for (int i = hexadecimalA.length - 1; i >= 0; i--) {
      int digitA = _hexCharToDecimal(hexadecimalA[i]);
      int digitB = _hexCharToDecimal(hexadecimalB[i]);

      int sum = digitA + digitB + carry;
      int newDigit = sum % 16;

      carry = sum ~/ 16;

      result = _decimalToHexChar(newDigit) + result;
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
  NumberBaseArithmeticResultModel subtraction(Hexadecimal other) {
    String hexadecimalA = value.toString();
    String hexadecimalB = other.value.toString();
    String result = "";
    int borrow = 0;
    bool isNegative = false;

    int padLeft = hexadecimalA.length;
    if (padLeft < hexadecimalB.length) padLeft = hexadecimalB.length;

    while (hexadecimalA.length < hexadecimalB.length) {
      hexadecimalA = "0$hexadecimalA";
    }
    while (hexadecimalA.length > hexadecimalB.length) {
      hexadecimalB = "0$hexadecimalB";
    }

    if (hexadecimalA.compareTo(hexadecimalB) < 0) {
      isNegative = true;
      String temp = hexadecimalA;
      hexadecimalA = hexadecimalB;
      hexadecimalB = temp;
    }

    for (int i = hexadecimalA.length - 1; i >= 0; i--) {
      int digitA = _hexCharToDecimal(hexadecimalA[i]);
      int digitB = _hexCharToDecimal(hexadecimalB[i]);
      int newDigit;

      if (digitA - borrow < digitB) {
        newDigit = (digitA - borrow + 16 - digitB);
        borrow = 1;
      } else {
        newDigit = (digitA - borrow - digitB);
        borrow = 0;
      }
      result = _decimalToHexChar(newDigit) + result;
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
  NumberBaseArithmeticResultModel multiplication(Hexadecimal other) {
    String hexadecimalA = value;
    String hexadecimalB = other.value;
    String result = "0";
    List<String> subResult = [];

    String temp;
    int carry = 0;
    for (int i = hexadecimalB.length - 1; i >= 0; i--) {
      temp = "";
      for (int j = hexadecimalA.length - 1; j >= 0; j--) {
        int digitA = _hexCharToDecimal(hexadecimalA[j]);
        int digitB = _hexCharToDecimal(hexadecimalB[i]);
        int newDigit = digitA * digitB + carry;

        temp = "${_decimalToHexChar(newDigit % 16)}$temp";
        carry = newDigit ~/ 16;
      }

      if (carry > 0) temp = "$carry$temp";

      subResult.add(temp);

      temp += "0" * (hexadecimalB.length - (i + 1));
      result = Hexadecimal(result).addition(Hexadecimal(temp)).result;
      carry = 0;
    }

    int padLeft = hexadecimalA.length;
    if (padLeft < hexadecimalB.length) padLeft = hexadecimalB.length;
    if (padLeft < result.length) padLeft = result.length;
    padLeft += 2;

    String step = "${hexadecimalA.padLeft(padLeft)}\n";
    step += "${hexadecimalB.padLeft(padLeft)}\n";
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
  NumberBaseDivisionResultModel division(Hexadecimal other) {
    String dividendStr = value.toUpperCase();
    String divisorStr = other.value.toUpperCase();
    String quotient = "";
    String remainder = "";

    List<String> subtractor = [];
    List<String> subResult = [];

    int divisorDec = int.parse(divisorStr, radix: 16);
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

      int currentDec = int.parse(current, radix: 16);
      int q = currentDec ~/ divisorDec;
      int mul = q * divisorDec;
      int rem = currentDec - mul;

      quotient += q.toRadixString(16).toUpperCase();
      remainder = rem.toRadixString(16).toUpperCase();
      current = remainder;

      subtractor.add(mul.toRadixString(16).toUpperCase());
      subResult.add(currentDec.toRadixString(16).toUpperCase());
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
