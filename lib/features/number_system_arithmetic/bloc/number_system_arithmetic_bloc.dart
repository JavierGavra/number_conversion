import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/core/model/number_base_arithmetic_result_model.dart';
import 'package:number_conversion/core/utils/format_text.dart';

part 'number_system_arithmetic_event.dart';
part 'number_system_arithmetic_state.dart';

class NumberSystemArithmeticBloc
    extends Bloc<NumberSystemArithmeticEvent, NumberSystemArithmeticState> {
  NumberSystemArithmeticBloc() : super(NumberSystemArithmeticState.initial()) {
    on<CalculateEvent>(_calculateHandler);
  }

  Future<void> _calculateHandler(
    CalculateEvent event,
    Emitter<NumberSystemArithmeticState> emit,
  ) async {
    NumberBaseArithmetic numberBase1;
    NumberBaseArithmetic numberBase2;
    NumberBaseArithmeticResultModel resultModel;
    String resultFormatted;

    switch (event.numberBase) {
      case NumberBaseType.binary:
        numberBase1 = Binary(event.field1);
        numberBase2 = Binary(event.field2);
        break;
      case NumberBaseType.octal:
        numberBase1 = Octal(int.parse(event.field1));
        numberBase2 = Octal(int.parse(event.field2));
        break;
      case NumberBaseType.hexadecimal:
        numberBase1 = Hexadecimal(event.field1);
        numberBase2 = Hexadecimal(event.field2);
        break;
      default:
        numberBase1 = Decimal(int.parse(event.field1));
        numberBase2 = Decimal(int.parse(event.field2));
        break;
    }

    switch (event.operator) {
      case "+":
        resultModel = numberBase1.addition(numberBase2);
        break;
      case "-":
        resultModel = numberBase1.subtraction(numberBase2);
        break;
      case "*":
        resultModel = numberBase1.multiplication(numberBase2);
        break;
      default:
        resultModel = numberBase1.division(numberBase2);
        break;
    }

    switch (event.numberBase) {
      case NumberBaseType.binary:
        resultFormatted = formatBinary(resultModel.result);
        break;
      case NumberBaseType.octal:
        resultFormatted = formatOctal(resultModel.result);
        break;
      case NumberBaseType.hexadecimal:
        resultFormatted = formatHexadecimal(resultModel.result);
        break;
      default:
        resultFormatted = formatDecimal(resultModel.result);
        break;
    }

    print("Calculate Success...");
    emit(NumberSystemArithmeticState(
      resultFormatted: resultFormatted,
      model: resultModel,
    ));
  }
}
