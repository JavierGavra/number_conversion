import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';

part 'real_time_conversion_event.dart';
part 'real_time_conversion_state.dart';

class RealTimeConversionBloc
    extends Bloc<RealTimeConversionEvent, RealTimeConversionState> {
  RealTimeConversionBloc() : super(RealTimeConversionState.initial()) {
    on<ConversionEvent>(_conversionHandler);
  }

  Future<void> _conversionHandler(
    ConversionEvent event,
    Emitter<RealTimeConversionState> emit,
  ) async {
    NumberBaseCovert numberBase;

    switch (event.from) {
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

    emit(RealTimeConversionState(
      from: event.from,
      binary: numberBase.toBinary(),
      decimal: numberBase.toDecimal(),
      octal: numberBase.toOctal(),
      hexadecimal: numberBase.toHexadecimal(),
    ));
  }
}
