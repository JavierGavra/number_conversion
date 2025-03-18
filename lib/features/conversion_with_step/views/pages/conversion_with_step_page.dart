import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/features/conversion_with_step/bloc/conversion_with_step_bloc.dart';
import 'package:number_conversion/features/conversion_with_step/views/pages/step_page.dart';
import 'package:number_conversion/features/custom_keyboard/views/widgets/custom_keyboard_widget.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';
import 'package:page_transition/page_transition.dart';

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

  void _customKeyboardListener(
    BuildContext context,
    CustomKeyboardState state,
  ) {
    context.read<ConversionWithStepBloc>().add(ConversionEvent(
          fromBase: _fromBase.value,
          toBase: _toBase.value,
          value: state.text,
        ));
  }

  void _fromBaseOnChanged(int? value) {
    if (value == _fromBase.value) return;

    context.read<CustomKeyboardBloc>().add(ClearEvent(relpaceWith: "0"));
    _fromBase.value = value!;
  }

  void _toBaseOnChanged({String? text, int? value}) {
    _toBase.value = value!;
    context.read<ConversionWithStepBloc>().add(ConversionEvent(
          fromBase: _fromBase.value,
          toBase: _toBase.value,
          value: text!,
        ));
  }

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
                SizedBox(height: 20),
                Expanded(
                  child: BlocListener<CustomKeyboardBloc, CustomKeyboardState>(
                    listener: _customKeyboardListener,
                    child: BlocBuilder<ConversionWithStepBloc,
                        ConversionWithStepState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            _buildInputSegmen(context, state.from),
                            SizedBox(height: 15),
                            _buildConvertOptionSegmen(context, state.from),
                            SizedBox(height: 5),
                            Divider(indent: 10, endIndent: 10),
                            SizedBox(height: 5),
                            _buildResultSegmen(context, state.resultFormatted),
                            SizedBox(height: 50),
                            Spacer(),
                            _buildSeeStepButton(state.model),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 10,
                  color: color.primary.withValues(alpha: 0.3),
                ),
                ColoredBox(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.4),
                  child: ValueListenableBuilder(
                    valueListenable: _fromBase,
                    builder: (context, value, child) {
                      return CustomKeyboardWidget(numberBaseType: value);
                    },
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
    required ValueNotifier valueNotifier,
    required Function(int?)? onChanged,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
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
            onChanged: onChanged,
            items: _numberBaseMenus,
          ),
        );
      },
    );
  }

  Widget _buildInputSegmen(BuildContext context, String text) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      height: 60,
      width: screenSize.width,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color.secondary.withValues(alpha: 0.2),
        border: Border.all(color: color.surface),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: TextStyle(color: color.onPrimary)),
    );
  }

  Widget _buildConvertOptionSegmen(BuildContext context, String text) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropdownButton(
            context: context,
            label: "Dari :",
            valueNotifier: _fromBase,
            onChanged: _fromBaseOnChanged,
          ),
          Icon(Icons.arrow_right_alt_rounded, color: color.primaryContainer),
          _buildDropdownButton(
            context: context,
            label: "Ke :",
            valueNotifier: _toBase,
            onChanged: (value) => _toBaseOnChanged(text: text, value: value),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSegmen(BuildContext context, String text) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      height: 60,
      width: screenSize.width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSeeStepButton(NumberBaseResultModel model) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      width: screenSize.width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: FilledButton(
        onPressed: () {
          print("${_fromBase.value} -> ${_toBase.value}");
          context.pushTransition(
            type: PageTransitionType.bottomToTop,
            curve: Curves.easeInOutCirc,
            duration: const Duration(milliseconds: 300),
            child: StepPage(model),
          );
        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text("Lihat Langkah Penyelesaian"),
      ),
    );
  }
}
