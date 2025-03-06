import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/features/real_time_conversion/bloc/real_time_conversion_bloc.dart';

class Provider {
  static get providers {
    return [
      BlocProvider(create: (context) => RealTimeConversionBloc()),
    ];
  }
}
