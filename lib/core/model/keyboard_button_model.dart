class KeyboardButtonModel {
  final String label;
  bool status;

  KeyboardButtonModel(this.label, this.status);
}

abstract class KeyboardLayoutMatrixModel {
  static final List<List<KeyboardButtonModel>> _keyboardLayoutMatrix = [
    [
      KeyboardButtonModel("7", true),
      KeyboardButtonModel("8", true),
      KeyboardButtonModel("9", true),
    ],
    [
      KeyboardButtonModel("4", true),
      KeyboardButtonModel("5", true),
      KeyboardButtonModel("6", true),
    ],
    [
      KeyboardButtonModel("1", true),
      KeyboardButtonModel("2", true),
      KeyboardButtonModel("3", true),
    ],
    [
      KeyboardButtonModel("A", true),
      KeyboardButtonModel("B", true),
      KeyboardButtonModel("C", true),
    ],
    [
      KeyboardButtonModel("D", true),
      KeyboardButtonModel("E", true),
      KeyboardButtonModel("F", true),
    ],
  ];

  static List<List<KeyboardButtonModel>> get binary {
    _keyboardLayoutMatrix[0][0].status = false; // 7
    _keyboardLayoutMatrix[0][1].status = false; // 8
    _keyboardLayoutMatrix[0][2].status = false; // 9
    _keyboardLayoutMatrix[1][0].status = false; // 4
    _keyboardLayoutMatrix[1][1].status = false; // 5
    _keyboardLayoutMatrix[1][2].status = false; // 6
    _keyboardLayoutMatrix[2][0].status = true; // 1
    _keyboardLayoutMatrix[2][1].status = false; // 2
    _keyboardLayoutMatrix[2][2].status = false; // 3
    _keyboardLayoutMatrix[3][0].status = false; // A
    _keyboardLayoutMatrix[3][1].status = false; // B
    _keyboardLayoutMatrix[3][2].status = false; // C
    _keyboardLayoutMatrix[4][0].status = false; // D
    _keyboardLayoutMatrix[4][1].status = false; // E
    _keyboardLayoutMatrix[4][2].status = false; // F
    return _keyboardLayoutMatrix;
  }

  static List<List<KeyboardButtonModel>> get octal {
    _keyboardLayoutMatrix[0][0].status = true; // 7
    _keyboardLayoutMatrix[0][1].status = false; // 8
    _keyboardLayoutMatrix[0][2].status = false; // 9
    _keyboardLayoutMatrix[1][0].status = true; // 4
    _keyboardLayoutMatrix[1][1].status = true; // 5
    _keyboardLayoutMatrix[1][2].status = true; // 6
    _keyboardLayoutMatrix[2][0].status = true; // 1
    _keyboardLayoutMatrix[2][1].status = true; // 2
    _keyboardLayoutMatrix[2][2].status = true; // 3
    _keyboardLayoutMatrix[3][0].status = false; // A
    _keyboardLayoutMatrix[3][1].status = false; // B
    _keyboardLayoutMatrix[3][2].status = false; // C
    _keyboardLayoutMatrix[4][0].status = false; // D
    _keyboardLayoutMatrix[4][1].status = false; // E
    _keyboardLayoutMatrix[4][2].status = false; // F
    return _keyboardLayoutMatrix;
  }

  static List<List<KeyboardButtonModel>> get decimal {
    _keyboardLayoutMatrix[0][0].status = true; // 7
    _keyboardLayoutMatrix[0][1].status = true; // 8
    _keyboardLayoutMatrix[0][2].status = true; // 9
    _keyboardLayoutMatrix[1][0].status = true; // 4
    _keyboardLayoutMatrix[1][1].status = true; // 5
    _keyboardLayoutMatrix[1][2].status = true; // 6
    _keyboardLayoutMatrix[2][0].status = true; // 1
    _keyboardLayoutMatrix[2][1].status = true; // 2
    _keyboardLayoutMatrix[2][2].status = true; // 3
    _keyboardLayoutMatrix[3][0].status = false; // A
    _keyboardLayoutMatrix[3][1].status = false; // B
    _keyboardLayoutMatrix[3][2].status = false; // C
    _keyboardLayoutMatrix[4][0].status = false; // D
    _keyboardLayoutMatrix[4][1].status = false; // E
    _keyboardLayoutMatrix[4][2].status = false; // F
    return _keyboardLayoutMatrix;
  }

  static List<List<KeyboardButtonModel>> get hexadecimal {
    _keyboardLayoutMatrix[0][0].status = true; // 7
    _keyboardLayoutMatrix[0][1].status = true; // 8
    _keyboardLayoutMatrix[0][2].status = true; // 9
    _keyboardLayoutMatrix[1][0].status = true; // 4
    _keyboardLayoutMatrix[1][1].status = true; // 5
    _keyboardLayoutMatrix[1][2].status = true; // 6
    _keyboardLayoutMatrix[2][0].status = true; // 1
    _keyboardLayoutMatrix[2][1].status = true; // 2
    _keyboardLayoutMatrix[2][2].status = true; // 3
    _keyboardLayoutMatrix[3][0].status = true; // A
    _keyboardLayoutMatrix[3][1].status = true; // B
    _keyboardLayoutMatrix[3][2].status = true; // C
    _keyboardLayoutMatrix[4][0].status = true; // D
    _keyboardLayoutMatrix[4][1].status = true; // E
    _keyboardLayoutMatrix[4][2].status = true; // F
    return _keyboardLayoutMatrix;
  }
}
