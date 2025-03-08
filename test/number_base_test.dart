import 'package:flutter_test/flutter_test.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';

void main() {
  test("Binary", () {
    // Real case
    Binary binary = Binary("1011100100001111000110");
    expect("2E43C6", binary.toHexadecimal());
    expect("3032006", binary.toDecimal());
    expect("13441706", binary.toOctal());
    expect("1011100100001111000110", binary.toBinary());

    // 0 value case
    binary.value = "0";
    expect("0", binary.toHexadecimal());
    expect("0", binary.toDecimal());
    expect("0", binary.toOctal());
    expect("0", binary.toBinary());

    // 1 digit value case
    binary.value = "10";
    expect("2", binary.toHexadecimal());
    expect("2", binary.toDecimal());
    expect("2", binary.toOctal());
    expect("10", binary.toBinary());
  });

  test("Decimal", () {
    // Real case
    Decimal decimal = Decimal(3032006);
    expect("2E43C6", decimal.toHexadecimal());
    expect("3032006", decimal.toDecimal());
    expect("13441706", decimal.toOctal());
    expect("1011100100001111000110", decimal.toBinary());

    // 0 value case
    decimal.value = 0;
    expect("0", decimal.toHexadecimal());
    expect("0", decimal.toDecimal());
    expect("0", decimal.toOctal());
    expect("0", decimal.toBinary());

    // 1 digit value case
    decimal.value = 2;
    expect("2", decimal.toHexadecimal());
    expect("2", decimal.toDecimal());
    expect("2", decimal.toOctal());
    expect("10", decimal.toBinary());
  });

  test("Octal", () {
    // Real case
    Octal octal = Octal(13441706);
    expect("2E43C6", octal.toHexadecimal());
    expect("3032006", octal.toDecimal());
    expect("13441706", octal.toOctal());
    expect("1011100100001111000110", octal.toBinary());

    // 0 value case
    octal.value = 0;
    expect("0", octal.toHexadecimal());
    expect("0", octal.toDecimal());
    expect("0", octal.toOctal());
    expect("0", octal.toBinary());

    // 1 digit value case
    octal.value = 2;
    expect("2", octal.toHexadecimal());
    expect("2", octal.toDecimal());
    expect("2", octal.toOctal());
    expect("10", octal.toBinary());
  });

  test("Hexadecimal", () {
    // Real case
    Hexadecimal hexadecimal = Hexadecimal("2E43C6");
    expect("2E43C6", hexadecimal.toHexadecimal());
    expect("3032006", hexadecimal.toDecimal());
    expect("13441706", hexadecimal.toOctal());
    expect("1011100100001111000110", hexadecimal.toBinary());

    // 0 value case
    hexadecimal.value = '0';
    expect("0", hexadecimal.toHexadecimal());
    expect("0", hexadecimal.toDecimal());
    expect("0", hexadecimal.toOctal());
    expect("0", hexadecimal.toBinary());

    // 1 digit value case
    hexadecimal.value = "2";
    expect("2", hexadecimal.toHexadecimal());
    expect("2", hexadecimal.toDecimal());
    expect("2", hexadecimal.toOctal());
    expect("10", hexadecimal.toBinary());
  });
}
