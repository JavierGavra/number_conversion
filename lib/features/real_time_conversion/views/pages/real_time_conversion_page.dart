import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/features/real_time_conversion/bloc/real_time_conversion_bloc.dart';
import 'package:number_conversion/core/utils/format_text.dart';
import 'package:number_conversion/features/custom_keyboard/views/widgets/custom_keyboard_widget.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';

class RealTimeConversionPage extends StatefulWidget {
  const RealTimeConversionPage({super.key});

  @override
  State<RealTimeConversionPage> createState() => _RealTimeConversionPageState();
}

class _RealTimeConversionPageState extends State<RealTimeConversionPage> {
  final ValueNotifier<int> _selectedNumberBase =
      ValueNotifier(NumberBaseType.decimal);

  void _customKeyboardListener(
    BuildContext context,
    CustomKeyboardState state,
  ) {
    context.read<RealTimeConversionBloc>().add(
        ConversionEvent(from: _selectedNumberBase.value, value: state.text));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Konversi Real Time"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("Comming soon..."),
                  ),
                );
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Image.asset(
              "assets/lighthouse.jpg",
              height: screenSize.height,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Colors.black.withValues(alpha: 0.15),
          ),
          ValueListenableBuilder(
            valueListenable: _selectedNumberBase,
            builder: (context, selectedNumberBase, child) {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocListener<CustomKeyboardBloc, CustomKeyboardState>(
                      listener: _customKeyboardListener,
                      child: BlocBuilder<RealTimeConversionBloc,
                          RealTimeConversionState>(
                        builder: (context, state) {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30),
                                  _buildTextField(
                                    context,
                                    label: "HEX",
                                    value: state.hexadecimal,
                                    numberBaseType: NumberBaseType.hexadecimal,
                                  ),
                                  _buildTextField(
                                    context,
                                    label: "DEC",
                                    value: state.decimal,
                                    numberBaseType: NumberBaseType.decimal,
                                  ),
                                  _buildTextField(
                                    context,
                                    label: "OCT",
                                    value: state.octal,
                                    numberBaseType: NumberBaseType.octal,
                                  ),
                                  _buildTextField(
                                    context,
                                    label: "BIN",
                                    value: state.binary,
                                    numberBaseType: NumberBaseType.binary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Spacer(),
                    Container(
                      height: 10,
                      color: color.primary.withValues(alpha: 0.3),
                    ),
                    ColoredBox(
                      color: color.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
                      child: CustomKeyboardWidget(
                        numberBaseType: selectedNumberBase,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String value,
    required int numberBaseType,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    String formatValue = "0";

    if (numberBaseType == NumberBaseType.binary) {
      formatValue = formatBinary(value);
    } else if (numberBaseType == NumberBaseType.decimal) {
      formatValue = formatDecimal(value);
    } else if (numberBaseType == NumberBaseType.octal) {
      formatValue = formatOctal(value);
    } else if (numberBaseType == NumberBaseType.hexadecimal) {
      formatValue = formatHexadecimal(value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_selectedNumberBase.value != numberBaseType) {
              _selectedNumberBase.value = numberBaseType;
            }
            context
                .read<CustomKeyboardBloc>()
                .add(InitialEvent(initialText: value));
          },
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 5,
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _selectedNumberBase.value == numberBaseType
                      ? color.primary
                      : null,
                ),
              ),
              SizedBox(width: 5),
              Container(
                width: 40,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(minHeight: 40),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedNumberBase.value == numberBaseType
                        ? color.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    formatValue,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _selectedNumberBase.value == numberBaseType
                          ? color.onPrimaryContainer
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
