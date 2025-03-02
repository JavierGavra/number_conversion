import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/bloc/number_conversion_bloc.dart';
import 'package:number_conversion/utils/format_text.dart';
import 'package:number_conversion/views/widgets/custom_keyboard_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NumberConversionState _state = NumberConversionState.initial();

  void _selectMode(NumberConversionStateStatus id) {
    if (id == NumberConversionStateStatus.binary) {
      context.read<NumberConversionBloc>().add(BinaryEvent(_state.binary));
    } else if (id == NumberConversionStateStatus.decimal) {
      context.read<NumberConversionBloc>().add(DecimalEvent(_state.decimal));
    } else if (id == NumberConversionStateStatus.octal) {
      context.read<NumberConversionBloc>().add(OctalEvent(_state.octal));
    } else if (id == NumberConversionStateStatus.hexadecimal) {
      context
          .read<NumberConversionBloc>()
          .add(HexadecimalEvent(_state.hexadecimal));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Konversi Sistem Bilangan"),
        backgroundColor: Colors.transparent,
        foregroundColor: color.primaryContainer,
      ),
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Image.asset(
              "assets/desert.png",
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
                BlocConsumer<NumberConversionBloc, NumberConversionState>(
                  listener: (context, state) => _state = state,
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
                              id: NumberConversionStateStatus.hexadecimal,
                            ),
                            _buildTextField(
                              context,
                              label: "DEC",
                              id: NumberConversionStateStatus.decimal,
                            ),
                            _buildTextField(
                              context,
                              label: "OCT",
                              id: NumberConversionStateStatus.octal,
                            ),
                            _buildTextField(
                              context,
                              label: "BIN",
                              id: NumberConversionStateStatus.binary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Spacer(),
                Container(
                  height: 10,
                  color: color.primary.withValues(alpha: 0.8),
                ),
                ColoredBox(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.4),
                  child: CustomKeyboardWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required NumberConversionStateStatus id,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    String value = "0";

    if (id == NumberConversionStateStatus.binary) {
      value = formatBinary(_state.binary);
      print(value.length);
    } else if (id == NumberConversionStateStatus.decimal) {
      value = formatDecimal(_state.decimal);
    } else if (id == NumberConversionStateStatus.octal) {
      value = formatOctal(_state.octal);
    } else if (id == NumberConversionStateStatus.hexadecimal) {
      value = formatHexadecimal(_state.hexadecimal);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectMode(id),
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
                  color: _state.status == id ? color.onSurface : null,
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
                    color: color.surface,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(minHeight: 40),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: _state.status == id ? color.primaryContainer : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _state.status == id ? null : color.surface,
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
