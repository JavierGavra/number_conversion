import 'package:flutter_test/flutter_test.dart';
import 'package:number_conversion/number_base/number_base.dart';

void main() {
  test("Decimal Test", () {
    Decimal decimal = Decimal(30);
    expect("11110", decimal.toBinary());
    expect("36", decimal.toOctal());
    expect("30", decimal.toDecimal());
    expect("1E", decimal.toHexadecimal());
  });

  test("Binary Test", () {
    Binary binary = Binary("11110");
    expect("11110", binary.toBinary());
    expect("36", binary.toOctal());
    expect("30", binary.toDecimal());
    expect("1E", binary.toHexadecimal());
  });

  test("Octal Test", () {
    Octal octal = Octal(36);
    expect("11110", octal.toBinary());
    expect("36", octal.toOctal());
    expect("30", octal.toDecimal());
    expect("1E", octal.toHexadecimal());
  });

  test("Hexadecimal Test", () {
    Hexadecimal hexadecimal = Hexadecimal("1E");
    expect("11110", hexadecimal.toBinary());
    expect("36", hexadecimal.toOctal());
    expect("30", hexadecimal.toDecimal());
    expect("1E", hexadecimal.toHexadecimal());
  });
}
