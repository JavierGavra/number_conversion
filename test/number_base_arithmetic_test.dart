import 'package:flutter_test/flutter_test.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';

void main() {
  test("Binary", () {
    // Real case
    Binary binary1 = Binary("1110");
    Binary binary2 = Binary("111");
    expect("10101", binary1.addition(binary2).result);
    expect("111", binary1.subtraction(binary2).result);
    expect("1100010", binary1.multiplication(binary2).result);
    expect("10", binary1.division(binary2).result);

    // 0 value case
    binary1.value = "0";
    binary2.value = "0";
    expect("0", binary1.addition(binary2).result);
    expect("0", binary1.subtraction(binary2).result);
    expect("0", binary1.multiplication(binary2).result);
    expect("Tidak bisa membagi dengan 0", binary1.division(binary2).result);

    // reverse value value case
    binary1.value = "111";
    binary2.value = "1110";
    expect("10101", binary1.addition(binary2).result);
    expect("- 111", binary1.subtraction(binary2).result);
    expect("1100010", binary1.multiplication(binary2).result);
    expect("0", binary1.division(binary2).result);
  });

  test("Decimal", () {
    // Real case
    Decimal decimal1 = Decimal(120);
    Decimal decimal2 = Decimal(25);
    expect("145", decimal1.addition(decimal2).result);
    expect("95", decimal1.subtraction(decimal2).result);
    expect("3000", decimal1.multiplication(decimal2).result);
    expect("4", decimal1.division(decimal2).result);

    // 0 value case
    decimal1.value = 0;
    decimal2.value = 0;
    expect("0", decimal1.addition(decimal2).result);
    expect("0", decimal1.subtraction(decimal2).result);
    expect("0", decimal1.multiplication(decimal2).result);
    expect("Tidak bisa membagi dengan 0", decimal1.division(decimal2).result);

    // reverse value value case
    decimal1.value = 25;
    decimal2.value = 120;
    expect("145", decimal1.addition(decimal2).result);
    expect("- 95", decimal1.subtraction(decimal2).result);
    expect("3000", decimal1.multiplication(decimal2).result);
    expect("0", decimal1.division(decimal2).result);
  });

  test("Octal", () {
    // Real case
    Octal octal1 = Octal(742);
    Octal octal2 = Octal(563);
    expect("1525", octal1.addition(octal2).result);
    expect("157", octal1.subtraction(octal2).result);
    expect("535206", octal1.multiplication(octal2).result);
    expect("1", octal1.division(octal2).result);

    // 0 value case
    octal1.value = 0;
    octal2.value = 0;
    expect("0", octal1.addition(octal2).result);
    expect("0", octal1.subtraction(octal2).result);
    expect("0", octal1.subtraction(octal2).result);
    expect("Tidak bisa membagi dengan 0", octal1.division(octal2).result);

    // reverse value value case
    octal1.value = 563;
    octal2.value = 742;
    expect("1525", octal1.addition(octal2).result);
    expect("- 157", octal1.subtraction(octal2).result);
    expect("535206", octal1.multiplication(octal2).result);
    expect("0", octal1.division(octal2).result);
  });

  test("Hexadecimal", () {
    // Real case
    Hexadecimal hexadecimal1 = Hexadecimal("B78");
    Hexadecimal hexadecimal2 = Hexadecimal("8AB");
    expect("1423", hexadecimal1.addition(hexadecimal2).result);
    expect("2CD", hexadecimal1.subtraction(hexadecimal2).result);
    expect("636928", hexadecimal1.multiplication(hexadecimal2).result);
    expect("1", hexadecimal1.division(hexadecimal2).result);

    // 0 value case
    hexadecimal1.value = "0";
    hexadecimal2.value = "0";
    expect("0", hexadecimal1.addition(hexadecimal2).result);
    expect("0", hexadecimal1.subtraction(hexadecimal2).result);
    expect("0", hexadecimal1.multiplication(hexadecimal2).result);
    expect("Tidak bisa membagi dengan 0",
        hexadecimal1.division(hexadecimal2).result);

    // reverse value value case
    hexadecimal1.value = "8AB";
    hexadecimal2.value = "B78";
    expect("1423", hexadecimal1.addition(hexadecimal2).result);
    expect("- 2CD", hexadecimal1.subtraction(hexadecimal2).result);
    expect("636928", hexadecimal1.multiplication(hexadecimal2).result);
    expect("0", hexadecimal1.division(hexadecimal2).result);
  });
}
