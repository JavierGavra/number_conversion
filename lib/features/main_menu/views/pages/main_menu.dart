import 'package:flutter/material.dart';
import 'package:number_conversion/features/number_system_arithmetic/views/pages/number_system_arithmetic.dart';
import 'package:number_conversion/features/conversion_with_step/views/pages/conversion_with_step_page.dart';
import 'package:number_conversion/features/real_time_conversion/views/pages/real_time_conversion_page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  final List<String> _widgetOptionsLabel = <String>[
    "Konversi Real Time",
    "Konversi Dengan Langkah",
    "Aritmatika Sistem Bilangan"
  ];

  final List<Widget> _widgetOptions = <Widget>[
    RealTimeConversionPage(),
    ConversionWithStepPage(),
    NumberSystemArithmetic(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_widgetOptionsLabel[_selectedIndex]),
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
      body: Center(child: _widgetOptions[_selectedIndex]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15, 54, 15, 26),
              margin: EdgeInsets.only(bottom: 6),
              color: color.primary,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/desert.png"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Text(
                "Konversi Sistem Bilangan",
                style: TextStyle(
                  fontSize: 18,
                  color: color.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              title: Text(
                _widgetOptionsLabel[0],
                style: TextStyle(fontSize: 15),
              ),
              selected: _selectedIndex == 0,
              leading: Icon(Icons.access_time, color: Colors.orange),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                _widgetOptionsLabel[1],
                style: TextStyle(fontSize: 15),
              ),
              leading: Icon(Icons.account_tree_outlined, color: Colors.blue),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                _widgetOptionsLabel[2],
                style: TextStyle(fontSize: 15),
              ),
              selected: _selectedIndex == 2,
              leading: Icon(Icons.calculate_outlined, color: Colors.green),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
