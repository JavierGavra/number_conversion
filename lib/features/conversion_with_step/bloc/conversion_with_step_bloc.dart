import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/core/utils/format_text.dart';

part 'conversion_with_step_event.dart';
part 'conversion_with_step_state.dart';

class ConversionWithStepBloc
    extends Bloc<ConversionWithStepEvent, ConversionWithStepState> {
  ConversionWithStepBloc() : super(ConversionWithStepState.initial()) {
    on<ConversionEvent>(_conversionHandler);
  }

  Future<void> _conversionHandler(
    ConversionEvent event,
    Emitter<ConversionWithStepState> emit,
  ) async {
    NumberBaseCovert numberBase;
    NumberBaseResultModel resultModel;
    String resultFormatted;

    switch (event.fromBase) {
      case NumberBaseType.binary:
        numberBase = Binary(event.value);
        break;
      case NumberBaseType.octal:
        numberBase = Octal(int.parse(event.value));
        break;
      case NumberBaseType.hexadecimal:
        numberBase = Hexadecimal(event.value);
        break;
      default:
        numberBase = Decimal(int.parse(event.value));
        break;
    }

    switch (event.toBase) {
      case NumberBaseType.binary:
        resultModel = numberBase.toBinary();
        resultFormatted = formatBinary(resultModel.result);
        break;
      case NumberBaseType.octal:
        resultModel = numberBase.toOctal();
        resultFormatted = formatOctal(resultModel.result);
        break;
      case NumberBaseType.hexadecimal:
        resultModel = numberBase.toHexadecimal();
        resultFormatted = formatHexadecimal(resultModel.result);
        break;
      default:
        resultModel = numberBase.toDecimal();
        resultFormatted = formatDecimal(resultModel.result);
        break;
    }

    emit(ConversionWithStepState(
      from: event.value,
      resultFormatted: resultFormatted,
      model: resultModel,
    ));
  }
}
