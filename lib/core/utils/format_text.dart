String formatBinary(String binary) {
  String paddedBinary = binary.padLeft(((binary.length + 3) ~/ 4) * 4, '0');

  return paddedBinary
      .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ')
      .trim();
}

String formatDecimal(String decimal) {
  final regex = RegExp(r'(\d)(?=(\d{3})+$)');
  return decimal.replaceAllMapped(regex, (match) => '${match[1]}.');
}

String formatOctal(String octal) {
  final regex = RegExp(r'(\d)(?=(\d{3})+$)');
  return octal.replaceAllMapped(regex, (match) => '${match[1]} ');
}

String formatHexadecimal(String hexadecimal) {
  final regex = RegExp(r'(\d)(?=(\d{4})+$)');
  return hexadecimal.replaceAllMapped(regex, (match) => '${match[1]} ');
}
