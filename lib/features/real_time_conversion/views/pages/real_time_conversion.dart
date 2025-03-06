import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_conversion/features/real_time_conversion/bloc/real_time_conversion_bloc.dart';
import 'package:number_conversion/core/utils/format_text.dart';
import 'package:number_conversion/core/widgets/custom_keyboard_widget.dart';

class RealTimeConversionPage extends StatefulWidget {
  const RealTimeConversionPage({super.key});

  @override
  State<RealTimeConversionPage> createState() => _RealTimeConversionPageState();
}

class _RealTimeConversionPageState extends State<RealTimeConversionPage> {
  late RealTimeConversionState _state = RealTimeConversionState.initial();

  void _selectMode(RealTimeConversionStateStatus id) {
    if (id == RealTimeConversionStateStatus.binary) {
      context.read<RealTimeConversionBloc>().add(BinaryEvent(_state.binary));
    } else if (id == RealTimeConversionStateStatus.decimal) {
      context.read<RealTimeConversionBloc>().add(DecimalEvent(_state.decimal));
    } else if (id == RealTimeConversionStateStatus.octal) {
      context.read<RealTimeConversionBloc>().add(OctalEvent(_state.octal));
    } else if (id == RealTimeConversionStateStatus.hexadecimal) {
      context
          .read<RealTimeConversionBloc>()
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
                BlocConsumer<RealTimeConversionBloc, RealTimeConversionState>(
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
                              id: RealTimeConversionStateStatus.hexadecimal,
                            ),
                            _buildTextField(
                              context,
                              label: "DEC",
                              id: RealTimeConversionStateStatus.decimal,
                            ),
                            _buildTextField(
                              context,
                              label: "OCT",
                              id: RealTimeConversionStateStatus.octal,
                            ),
                            _buildTextField(
                              context,
                              label: "BIN",
                              id: RealTimeConversionStateStatus.binary,
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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: true,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: false,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: false,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required RealTimeConversionStateStatus id,
  }) {
    final ColorScheme color = Theme.of(context).colorScheme;
    String value = "0";

    if (id == RealTimeConversionStateStatus.binary) {
      value = formatBinary(_state.binary);
    } else if (id == RealTimeConversionStateStatus.decimal) {
      value = formatDecimal(_state.decimal);
    } else if (id == RealTimeConversionStateStatus.octal) {
      value = formatOctal(_state.octal);
    } else if (id == RealTimeConversionStateStatus.hexadecimal) {
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
