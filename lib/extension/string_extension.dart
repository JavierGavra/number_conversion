extension StringExtension on String {
  String reverse() {
    String current = this;
    String result = "";

    for (int i = current.length - 1; i >= 0; i--) {
      result += current[i];
    }

    return result;
  }
}