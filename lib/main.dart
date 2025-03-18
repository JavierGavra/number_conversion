import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/bloc/provider.dart';
import 'package:number_conversion/features/conversion_with_step/views/pages/conversion_with_step_page.dart';
// import 'package:number_conversion/features/real_time_conversion/views/pages/real_time_conversion_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: Provider.providers,
      child: MaterialApp(
        title: 'Konversi Sistem Bilangan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const ConversionWithStepPage(),
        // home: const RealTimeConversionPage(),
      ),
    );
  }
}
