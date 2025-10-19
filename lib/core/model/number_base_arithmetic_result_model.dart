class NumberBaseArithmeticResultModel {
  final int base;
  final String operator;
  final String result;
  final String step;

  const NumberBaseArithmeticResultModel({
    required this.base,
    required this.operator,
    required this.result,
    required this.step,
  });
}

class NumberBaseDivisionResultModel extends NumberBaseArithmeticResultModel {
  final String remainder;

  NumberBaseDivisionResultModel({
    required super.base,
    required super.operator,
    required super.result,
    required super.step,
    required this.remainder,
  });
}
