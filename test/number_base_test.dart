import 'package:flutter_test/flutter_test.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';

void main() {
  test("Binary", () {
    // Real case
    Binary binary = Binary("1011100100001111000110");
    expect("2E43C6", binary.toHexadecimal().result);
    expect("3032006", binary.toDecimal().result);
    expect("13441706", binary.toOctal().result);
    expect("1011100100001111000110", binary.toBinary().result);

    // 0 value case
    binary.value = "0";
    expect("0", binary.toHexadecimal().result);
    expect("0", binary.toDecimal().result);
    expect("0", binary.toOctal().result);
    expect("0", binary.toBinary().result);

    // 1 digit value case
    binary.value = "10";
    expect("2", binary.toHexadecimal().result);
    expect("2", binary.toDecimal().result);
    expect("2", binary.toOctal().result);
    expect("10", binary.toBinary().result);
  });

  test("Decimal", () {
    // Real case
    Decimal decimal = Decimal(3032006);
    expect("2E43C6", decimal.toHexadecimal().result);
    expect("3032006", decimal.toDecimal().result);
    expect("13441706", decimal.toOctal().result);
    expect("1011100100001111000110", decimal.toBinary().result);

    // 0 value case
    decimal.value = 0;
    expect("0", decimal.toHexadecimal().result);
    expect("0", decimal.toDecimal().result);
    expect("0", decimal.toOctal().result);
    expect("0", decimal.toBinary().result);

    // 1 digit value case
    decimal.value = 2;
    expect("2", decimal.toHexadecimal().result);
    expect("2", decimal.toDecimal().result);
    expect("2", decimal.toOctal().result);
    expect("10", decimal.toBinary().result);
  });

  test("Octal", () {
    // Real case
    Octal octal = Octal(13441706);
    expect("2E43C6", octal.toHexadecimal().result);
    expect("3032006", octal.toDecimal().result);
    expect("13441706", octal.toOctal().result);
    expect("1011100100001111000110", octal.toBinary().result);

    // 0 value case
    octal.value = 0;
    expect("0", octal.toHexadecimal().result);
    expect("0", octal.toDecimal().result);
    expect("0", octal.toOctal().result);
    expect("0", octal.toBinary().result);

    // 1 digit value case
    octal.value = 2;
    expect("2", octal.toHexadecimal().result);
    expect("2", octal.toDecimal().result);
    expect("2", octal.toOctal().result);
    expect("10", octal.toBinary().result);
  });

  test("Hexadecimal", () {
    // Real case
    Hexadecimal hexadecimal = Hexadecimal("2E43C6");
    expect("2E43C6", hexadecimal.toHexadecimal().result);
    expect("3032006", hexadecimal.toDecimal().result);
    expect("13441706", hexadecimal.toOctal().result);
    expect("1011100100001111000110", hexadecimal.toBinary().result);

    // 0 value case
    hexadecimal.value = '0';
    expect("0", hexadecimal.toHexadecimal().result);
    expect("0", hexadecimal.toDecimal().result);
    expect("0", hexadecimal.toOctal().result);
    expect("0", hexadecimal.toBinary().result);

    // 1 digit value case
    hexadecimal.value = "2";
    expect("2", hexadecimal.toHexadecimal().result);
    expect("2", hexadecimal.toDecimal().result);
    expect("2", hexadecimal.toOctal().result);
    expect("10", hexadecimal.toBinary().result);
  });
}
