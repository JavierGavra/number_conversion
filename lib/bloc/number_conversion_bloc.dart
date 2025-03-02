import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_conversion/number_base/number_base.dart';

part 'number_conversion_event.dart';
part 'number_conversion_state.dart';

class NumberConversionBloc
    extends Bloc<NumberConversionEvent, NumberConversionState> {
  NumberConversionBloc() : super(NumberConversionState.initial()) {
    on<ClearEvent>(_clearEventHandler);
    on<BinaryEvent>(_binaryEventHandler);
    on<DecimalEvent>(_decimalEventHandler);
    on<OctalEvent>(_octalEventHandler);
    on<HexadecimalEvent>(_hexadecimalEventHandler);
  }

  Future<void> _clearEventHandler(
    ClearEvent event,
    Emitter<NumberConversionState> emit,
  ) async {
    emit(NumberConversionState(
      status: state.status,
      binary: "0",
      decimal: "0",
      octal: "0",
      hexadecimal: "0",
    ));
  }

  Future<void> _binaryEventHandler(
    BinaryEvent event,
    Emitter<NumberConversionState> emit,
  ) async {
    final Binary binary = Binary(event.binary);
    emit(NumberConversionState(
      status: NumberConversionStateStatus.binary,
      binary: binary.toBinary(),
      decimal: binary.toDecimal(),
      octal: binary.toOctal(),
      hexadecimal: binary.toHexadecimal(),
    ));
  }

  Future<void> _decimalEventHandler(
    DecimalEvent event,
    Emitter<NumberConversionState> emit,
  ) async {
    final Decimal decimal = Decimal(int.parse(event.decimal));
    emit(NumberConversionState(
      status: NumberConversionStateStatus.decimal,
      binary: decimal.toBinary(),
      decimal: decimal.toDecimal(),
      octal: decimal.toOctal(),
      hexadecimal: decimal.toHexadecimal(),
    ));
  }

  Future<void> _octalEventHandler(
    OctalEvent event,
    Emitter<NumberConversionState> emit,
  ) async {
    try {
      final Octal octal = Octal(int.parse(event.octal));
      emit(NumberConversionState(
        status: NumberConversionStateStatus.octal,
        binary: octal.toBinary(),
        decimal: octal.toDecimal(),
        octal: octal.toOctal(),
        hexadecimal: octal.toHexadecimal(),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _hexadecimalEventHandler(
    HexadecimalEvent event,
    Emitter<NumberConversionState> emit,
  ) async {
    final Hexadecimal hexadecimal = Hexadecimal(event.hexadecimal);
    emit(NumberConversionState(
      status: NumberConversionStateStatus.hexadecimal,
      binary: hexadecimal.toBinary(),
      decimal: hexadecimal.toDecimal(),
      octal: hexadecimal.toOctal(),
      hexadecimal: hexadecimal.toHexadecimal(),
    ));
  }
}
