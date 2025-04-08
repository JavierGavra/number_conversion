class NumberBaseConvertResultModel {
  final String initialValue;
  final int fromBase;
  final int toBase;
  final String result;
  final String step;

  const NumberBaseConvertResultModel({
    required this.initialValue,
    required this.fromBase,
    required this.toBase,
    required this.result,
    required this.step,
  });

  const NumberBaseConvertResultModel.noStep({
    required String initialValue,
    required int fromBase,
    required int toBase,
    required String result,
  }) : this(
          initialValue: initialValue,
          fromBase: fromBase,
          toBase: toBase,
          result: result,
          step: "#Tidak ada proses konversi#",
        );
}
