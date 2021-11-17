import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_emt/domain/cubit/theme_cubit/theme_cubit.dart';

import 'package:open_emt/views/screens/home_screen/tabs/home_tab.dart';
import 'package:open_emt/views/screens/home_screen/tabs/map_tab.dart';
import 'package:open_emt/views/theme/theme.dart';

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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'OpenEMT',
              style: AppTheme.appBarTitle,
            ),
            flexibleSpace: (state is ThemeDark)
                ? AppTheme.appBarDarkFlexibleSpace
                : AppTheme.appBarLightFlexibleSpace,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('OpenEMT', style: AppTheme.title),
                      FaIcon(FontAwesomeIcons.bus),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Apariencia',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                SwitchListTile(
                  value: (state is ThemeDark),
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  title: const Text('Modo oscuro'),
                )
              ],
            ),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
          bottomNavigationBar: Container(
            decoration: (state is ThemeDark)
                ? AppTheme.bottomBarDecorationDark
                : AppTheme.bottomBarDecorationLight,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                    label: 'Inicio', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Mapa', icon: Icon(Icons.map)),
              ],
              onTap: (index) => setState(() {
                _currentIndex = index;
              }),
            ),
          ),
        );
      },
    );
  }
}
