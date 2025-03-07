part of 'real_time_conversion_bloc.dart';

sealed class RealTimeConversionEvent extends Equatable {
  const RealTimeConversionEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ConversionEvent extends RealTimeConversionEvent {
  final int from;
  final String value;

  const ConversionEvent({required this.from, required this.value});

  @override
  List<Object?> get props => [from, value];
}
