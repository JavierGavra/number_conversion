import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/core/model/number_base/number_base.dart';
import 'package:number_conversion/features/conversion_with_step/views/pages/step_page.dart';
import 'package:number_conversion/features/custom_keyboard/views/widgets/custom_keyboard_widget.dart';
import 'package:number_conversion/features/custom_keyboard/bloc/custom_keyboard_bloc.dart';

class ConversionWithStepPage extends StatelessWidget {
  const ConversionWithStepPage({super.key});

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
                Spacer(),
                Container(
                  width: screenSize.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: FilledButton(
                    onPressed: () {
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
}
