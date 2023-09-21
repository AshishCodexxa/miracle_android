import 'package:flutter/material.dart';
import 'package:miracle/src/features/edit_theme/themes.dart';
import 'package:miracle/src/features/home/home.dart';
import 'package:miracle/src/features/learn/learn.dart';
import 'package:miracle/src/features/mine/mine.dart';
import 'package:miracle/src/features/settings/settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final designations = <Widget>[
    const Home(),
    const Mine(),
    const Themes(),
    const Learn(),
    const Settings()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  switchOutCurve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 300),
                  child: designations[_selectedIndex],
                ),
              ),
              BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'Mine',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.imagesearch_roller_outlined),
                    label: 'Theme',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book_outlined),
                    label: 'Learn',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    label: 'Setting',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
