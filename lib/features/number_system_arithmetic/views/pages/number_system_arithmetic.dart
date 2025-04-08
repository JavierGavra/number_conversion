import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/core/model/number_base_arithmetic_result_model.dart';
import 'package:number_conversion/features/custom_keyboard/views/widgets/custom_keyboard_widget.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';
import 'package:number_conversion/features/number_system_arithmetic/bloc/number_system_arithmetic_bloc.dart';
import 'package:number_conversion/features/number_system_arithmetic/views/pages/step_page.dart';
import 'package:number_conversion/features/number_system_arithmetic/views/widgets/custom_dropdown_button.dart';
import 'package:number_conversion/features/number_system_arithmetic/views/widgets/custom_field.dart';
import 'package:page_transition/page_transition.dart';

class NumberSystemArithmetic extends StatefulWidget {
  const NumberSystemArithmetic({super.key});

  @override
  State<NumberSystemArithmetic> createState() => _NumberSystemArithmeticState();
}

class _NumberSystemArithmeticState extends State<NumberSystemArithmetic> {
  final _selectedBase = ValueNotifier<int>(NumberBaseType.decimal);
  final _selectedOperator = ValueNotifier<String>("+");
  final _selectedField = ValueNotifier<int>(0);

  String field1 = "0";
  String field2 = "0";

  final List<DropdownMenuItem<int>> _numberBaseMenus = [
    DropdownMenuItem(value: NumberBaseType.binary, child: Text("Binary")),
    DropdownMenuItem(value: NumberBaseType.decimal, child: Text("Decimal")),
    DropdownMenuItem(value: NumberBaseType.octal, child: Text("Octal")),
    DropdownMenuItem(
      value: NumberBaseType.hexadecimal,
      child: Text("Hexadecimal"),
    ),
  ];

  final List<DropdownMenuItem<String>> _arithmeticMenus = [
    DropdownMenuItem(value: "+", child: Text("+")),
    DropdownMenuItem(value: "-", child: Text("-")),
    DropdownMenuItem(value: "*", child: Text("*")),
    DropdownMenuItem(value: "/", child: Text("/")),
  ];

  void _customKeyboardListener(
    BuildContext context,
    CustomKeyboardState state,
  ) {
    if (_selectedField.value == 0) {
      field1 = state.text;
    } else {
      field2 = state.text;
    }

    context.read<NumberSystemArithmeticBloc>().add(CalculateEvent(
          numberBase: _selectedBase.value,
          operator: _selectedOperator.value,
          field1: field1,
          field2: field2,
        ));
  }

  void _onNumberBaseChanged(int? value) {
    _selectedBase.value = value!;
    field1 = "0";
    field2 = "0";
    context.read<CustomKeyboardBloc>().add(InitialEvent(initialText: "0"));
    context.read<NumberSystemArithmeticBloc>().add(CalculateEvent(
          numberBase: _selectedBase.value,
          operator: _selectedOperator.value,
          field1: field1,
          field2: field2,
        ));
  }

  void _onOperatorChanged(String? value) {
    _selectedOperator.value = value!;
    context.read<NumberSystemArithmeticBloc>().add(CalculateEvent(
          numberBase: _selectedBase.value,
          operator: _selectedOperator.value,
          field1: field1,
          field2: field2,
        ));
  }

  void _onFieldTap({required int id}) {
    _selectedField.value = id;
    context
        .read<CustomKeyboardBloc>()
        .add(InitialEvent(initialText: (id == 0) ? field1 : field2));
  }

  @override
  void initState() {
    super.initState();
    context.read<CustomKeyboardBloc>().add(InitialEvent(initialText: "0"));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Image.asset(
            "assets/fern.jpg",
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
                  child: BlocBuilder<NumberSystemArithmeticBloc,
                      NumberSystemArithmeticState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildOptionSegmen(),
                          SizedBox(height: 5),
                          Divider(indent: 10, endIndent: 10),
                          SizedBox(height: 5),
                          _buildInputSegmen(color),
                          SizedBox(height: 15),
                          _buildResultSegmen(context, state),
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
                  valueListenable: _selectedBase,
                  builder: (context, value, child) {
                    return CustomKeyboardWidget(numberBaseType: value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionSegmen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 2,
            child: CustomDropdownButton<int>(
              label: "Sistem Bilangan",
              menus: _numberBaseMenus,
              valueNotifier: _selectedBase,
              onChanged: _onNumberBaseChanged,
            ),
          ),
          Flexible(
            flex: 1,
            child: CustomDropdownButton<String>(
              label: "Operasi",
              menus: _arithmeticMenus,
              valueNotifier: _selectedOperator,
              onChanged: _onOperatorChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSegmen(ColorScheme color) {
    return ValueListenableBuilder(
      valueListenable: _selectedField,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomField(
                  text: field1,
                  isSelected: (value == 0),
                  onTap: () => _onFieldTap(id: 0),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _selectedOperator,
                builder: (context, value, child) {
                  return Text(
                    value,
                    style: TextStyle(color: color.surface, fontSize: 15),
                  );
                },
              ),
              Expanded(
                child: CustomField(
                  text: field2,
                  isSelected: (value == 1),
                  onTap: () => _onFieldTap(id: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultSegmen(
    BuildContext context,
    NumberSystemArithmeticState state,
  ) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);
    NumberBaseArithmeticResultModel model = state.model;
    String text = "";

    if (model is NumberBaseDivisionResultModel) {
      text = (model.remainder == "0")
          ? model.result
          : "${model.result} Sisa ${model.remainder}";
    } else {
      text = state.resultFormatted;
    }

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

  Widget _buildSeeStepButton(NumberBaseArithmeticResultModel model) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      width: screenSize.width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: FilledButton(
        onPressed: () {
          context.pushTransition(
            type: PageTransitionType.bottomToTop,
            curve: Curves.easeInOutCirc,
            duration: const Duration(milliseconds: 300),
            child: StepPage(
              numberBase1: field1,
              numberBase2: field2,
              model: model,
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
    );
  }
}
