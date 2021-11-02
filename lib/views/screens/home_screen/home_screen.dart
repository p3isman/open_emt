import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:open_emt/views/screens/home_screen/tabs/home_tab.dart';
import 'package:open_emt/views/screens/home_screen/tabs/map_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  /// Static named route for page
  static const String route = '/home';

  /// Static method to return the widget as a PageRoute
  static Route go() =>
      MaterialPageRoute<void>(builder: (_) => const HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _tabs = [
    HomeTab(), // see the HomeTab class below
    const MapTab() //, see the SettingsTab class below
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OpenEMT')),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Mapa', icon: Icon(Icons.map)),
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }
}
