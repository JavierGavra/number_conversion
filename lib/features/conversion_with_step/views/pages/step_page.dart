import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/core/utils/format_text.dart';

class StepPage extends StatelessWidget {
  final NumberBaseResultModel model;

  const StepPage(this.model, {super.key});

  List<Widget> _formatStep(ColorScheme color, String text) {
    List<Widget> widgets = [];
    RegExp regex = RegExp(r'#(.*?)#');
    Iterable<RegExpMatch> matches = regex.allMatches(text);

    int lastIndex = 0;
    for (var match in matches) {
      // Ambil teks biasa
      if (match.start > lastIndex) {
        widgets.add(_buildStepContent(
          color,
          text.substring(lastIndex, match.start),
          true,
        ));
      }
      // Ambil teks di dalam #
      widgets.add(_buildStepContent(color, match.group(1)!, false));
      lastIndex = match.end;
    }

    // Tambahkan sisa teks
    if (lastIndex < text.length) {
      widgets.add(Text(text.substring(lastIndex)));
    }

    return widgets;
  }

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

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Langkah Penyelesaian"),
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
                  _buildStepContent(color, "\n${model.initialValue}\n", true),
                  ..._formatStep(color, model.step),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatNumberBase(model.fromBase),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: color.onPrimary,
            ),
          ),
          SizedBox(width: 5),
          Icon(Icons.arrow_right_alt_rounded, color: color.primaryContainer),
          SizedBox(width: 5),
          Text(
            _formatNumberBase(model.toBase),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(ColorScheme color) {
    String formatResult = "";

    if (model.toBase == NumberBaseType.binary) {
      formatResult = formatBinary(model.result);
    } else if (model.toBase == NumberBaseType.decimal) {
      formatResult = formatDecimal(model.result);
    } else if (model.toBase == NumberBaseType.octal) {
      formatResult = formatOctal(model.result);
    } else if (model.toBase == NumberBaseType.hexadecimal) {
      formatResult = formatHexadecimal(model.result);
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
            model.result,
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

  Widget _buildStepContent(ColorScheme color, String text, bool isCalculate) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: isCalculate ? 0 : 7,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCalculate ? color.surfaceContainerHighest : color.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isCalculate ? null : FontWeight.w500,
          color: isCalculate ? color.onSurface : color.onSecondary,
        ),
      ),
    );
  }
}
