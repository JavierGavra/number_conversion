import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/features/conversion_with_step/views/pages/step_page.dart';
import 'package:number_conversion/features/custom_keyboard/views/widgets/custom_keyboard_widget.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';

class ConversionWithStepPage extends StatefulWidget {
  const ConversionWithStepPage({super.key});

  @override
  State<ConversionWithStepPage> createState() => _ConversionWithStepPageState();
}

class _ConversionWithStepPageState extends State<ConversionWithStepPage> {
  final ValueNotifier<int> _fromBase = ValueNotifier(NumberBaseType.decimal);
  final ValueNotifier<int> _toBase = ValueNotifier(NumberBaseType.binary);

  final List<DropdownMenuItem<int>> _numberBaseMenus = [
    DropdownMenuItem(value: NumberBaseType.binary, child: Text("Binary")),
    DropdownMenuItem(value: NumberBaseType.decimal, child: Text("Decimal")),
    DropdownMenuItem(value: NumberBaseType.octal, child: Text("Octal")),
    DropdownMenuItem(
      value: NumberBaseType.hexadecimal,
      child: Text("Hexadecimal"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Konversi Dengan Langkah"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
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
              "assets/tv_tower.jpg",
              height: screenSize.height,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Colors.black.withValues(alpha: 0.15),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<CustomKeyboardBloc, CustomKeyboardState>(
                  builder: (context, state) {
                    return Text(
                      state.text,
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                Container(
                  height: 60,
                  width: screenSize.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: color.secondary.withValues(alpha: 0.2),
                    border: Border.all(color: color.surface),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDropdownButton(
                        context: context,
                        label: "Dari :",
                        valueNotfier: _fromBase,
                      ),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        color: color.primaryContainer,
                      ),
                      _buildDropdownButton(
                        context: context,
                        label: "Ke :",
                        valueNotfier: _toBase,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 60,
                  width: screenSize.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(height: 50),
                Spacer(),
                Container(
                  width: screenSize.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: FilledButton(
                    onPressed: () {
                      print("${_fromBase.value} -> ${_toBase.value}");
                      Hexadecimal hexadecimal = Hexadecimal("2E43C6");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StepPage(
                            hexadecimal.toHexadecimal(),
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Lihat Langkah Penyelesaian"),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 10,
                  color: color.primary.withValues(alpha: 0.3),
                ),
                ColoredBox(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.4),
                  child: CustomKeyboardWidget(
                    numberBaseType: NumberBaseType.decimal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required BuildContext context,
    required String label,
    required ValueNotifier valueNotfier,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: valueNotfier,
      builder: (context, value, child) {
        return Expanded(
          child: DropdownButtonFormField<int>(
            value: value,
            iconEnabledColor: color.surfaceContainerHighest,
            style: TextStyle(color: color.surface),
            dropdownColor: color.secondary,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: color.surface),
              filled: true,
              fillColor: color.surfaceContainerHighest.withValues(alpha: 0.1),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color.surface),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color.surface),
              ),
            ),
            onChanged: (value) => valueNotfier.value = value,
            items: _numberBaseMenus,
          ),
        );
      },
    );
  }
}
