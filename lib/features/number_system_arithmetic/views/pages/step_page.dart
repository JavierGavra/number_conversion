import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/core/model/number_base_arithmetic_result_model.dart';
import 'package:number_conversion/core/utils/format_text.dart';

class StepPage extends StatelessWidget {
  final String numberBase1;
  final String numberBase2;
  final NumberBaseArithmeticResultModel model;

  const StepPage({
    super.key,
    required this.numberBase1,
    required this.numberBase2,
    required this.model,
  });

  String _formatNumberBase(int numberBase) {
    switch (numberBase) {
      case NumberBaseType.binary:
        return "Binary";
      case NumberBaseType.octal:
        return "Octal";
      case NumberBaseType.decimal:
        return "Decimal";
      case NumberBaseType.hexadecimal:
        return "Hexadecimal";
      default:
        return "_";
    }
  }

  String _formatOperator(String operator) {
    switch (operator) {
      case "+":
        return "Penjumlahan";
      case "-":
        return "Penguranga";
      case "*":
        return "Perkalian";
      case "/":
        return "Pembagian";
      default:
        return "_";
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Visualisasi Penyelesaian"),
        foregroundColor: color.onPrimary,
        backgroundColor: color.primary,
      ),
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Image.asset(
              "assets/desert_night.jpg",
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(color),
                  _buildStepContent(
                    color,
                    "$numberBase1 ${model.operator} $numberBase2",
                    false,
                  ),
                  _buildStepContent(color, model.step, true),
                  _buildResult(color),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme color) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 40, bottom: 32),
      alignment: Alignment.center,
      child: Text(
        "${_formatOperator(model.operator)} ${_formatNumberBase(model.base)}",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: color.onPrimary,
        ),
      ),
    );
  }

  Widget _buildResult(ColorScheme color) {
    String text = model.result;
    String formatResult = "";

    if (model.base == NumberBaseType.binary) {
      formatResult = formatBinary(model.result);
    } else if (model.base == NumberBaseType.decimal) {
      formatResult = formatDecimal(model.result);
    } else if (model.base == NumberBaseType.octal) {
      formatResult = formatOctal(model.result);
    } else if (model.base == NumberBaseType.hexadecimal) {
      formatResult = formatHexadecimal(model.result);
    }

    NumberBaseArithmeticResultModel temp = model;
    if (temp is NumberBaseDivisionResultModel && temp.remainder != "0") {
      text += " sisa ${temp.remainder}";
      formatResult += " sisa ${temp.remainder}";
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hasil",
            style: TextStyle(color: color.onPrimary, fontSize: 13),
          ),
          SizedBox(height: 2),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color.onPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Versi Format",
            style: TextStyle(color: color.onPrimary, fontSize: 13),
          ),
          SizedBox(height: 2),
          Text(
            formatResult,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(ColorScheme color, String text, bool isVisual) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        isVisual ? "\n$text\n" : "\n$text\n",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontFamily: isVisual ? "RobotoMono" : null,
          fontWeight: isVisual ? FontWeight.w500 : null,
          fontSize: isVisual ? 16 : 14,
          color: color.onSurface,
        ),
      ),
    );
  }
}
