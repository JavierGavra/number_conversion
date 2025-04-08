import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/features/conversion_with_step/bloc/conversion_with_step_bloc.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';
import 'package:number_conversion/features/number_system_arithmetic/bloc/number_system_arithmetic_bloc.dart';
import 'package:number_conversion/features/real_time_conversion/bloc/real_time_conversion_bloc.dart';

class Provider {
  static get providers {
    return [
      BlocProvider<RealTimeConversionBloc>(
        create: (context) => RealTimeConversionBloc(),
      ),
      BlocProvider<ConversionWithStepBloc>(
        create: (context) => ConversionWithStepBloc(),
      ),
      BlocProvider<NumberSystemArithmeticBloc>(
        create: (context) => NumberSystemArithmeticBloc(),
      ),
      BlocProvider<CustomKeyboardBloc>(
        create: (context) => CustomKeyboardBloc(),
      ),
    ];
  }
}
