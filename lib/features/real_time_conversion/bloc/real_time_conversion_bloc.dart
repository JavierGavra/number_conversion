import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';

part 'real_time_conversion_event.dart';
part 'real_time_conversion_state.dart';

class RealTimeConversionBloc
    extends Bloc<RealTimeConversionEvent, RealTimeConversionState> {
  RealTimeConversionBloc() : super(RealTimeConversionState.initial()) {
    on<ClearEvent>(_clearEventHandler);
    on<BinaryEvent>(_binaryEventHandler);
    on<DecimalEvent>(_decimalEventHandler);
    on<OctalEvent>(_octalEventHandler);
    on<HexadecimalEvent>(_hexadecimalEventHandler);
  }

  Future<void> _clearEventHandler(
    ClearEvent event,
    Emitter<RealTimeConversionState> emit,
  ) async {
    emit(RealTimeConversionState(
      status: state.status,
      binary: "0",
      decimal: "0",
      octal: "0",
      hexadecimal: "0",
    ));
  }

  Future<void> _binaryEventHandler(
    BinaryEvent event,
    Emitter<RealTimeConversionState> emit,
  ) async {
    final Binary binary = Binary(event.binary);
    emit(RealTimeConversionState(
      status: RealTimeConversionStateStatus.binary,
      binary: binary.toBinary(),
      decimal: binary.toDecimal(),
      octal: binary.toOctal(),
      hexadecimal: binary.toHexadecimal(),
    ));
  }

  Future<void> _decimalEventHandler(
    DecimalEvent event,
    Emitter<RealTimeConversionState> emit,
  ) async {
    final Decimal decimal = Decimal(int.parse(event.decimal));
    emit(RealTimeConversionState(
      status: RealTimeConversionStateStatus.decimal,
      binary: decimal.toBinary(),
      decimal: decimal.toDecimal(),
      octal: decimal.toOctal(),
      hexadecimal: decimal.toHexadecimal(),
    ));
  }

  Future<void> _octalEventHandler(
    OctalEvent event,
    Emitter<RealTimeConversionState> emit,
  ) async {
    final Octal octal = Octal(int.parse(event.octal));
    emit(RealTimeConversionState(
      status: RealTimeConversionStateStatus.octal,
      binary: octal.toBinary(),
      decimal: octal.toDecimal(),
      octal: octal.toOctal(),
      hexadecimal: octal.toHexadecimal(),
    ));
  }

  Future<void> _hexadecimalEventHandler(
    HexadecimalEvent event,
    Emitter<RealTimeConversionState> emit,
  ) async {
    final Hexadecimal hexadecimal = Hexadecimal(event.hexadecimal);
    emit(RealTimeConversionState(
      status: RealTimeConversionStateStatus.hexadecimal,
      binary: hexadecimal.toBinary(),
      decimal: hexadecimal.toDecimal(),
      octal: hexadecimal.toOctal(),
      hexadecimal: hexadecimal.toHexadecimal(),
    ));
  }
}
