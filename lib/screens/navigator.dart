import 'package:circle/screens/saved.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navi extends StatefulWidget {
  @override
  _NaviState createState() => _NaviState();
}

class _NaviState extends State<Navi> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Saved(),
    Text('Profile ',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                haptic: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    backgroundColor: Colors.black,
                    icon: Icons.home,
                    iconActiveColor: Colors.blue,
                    text: 'Home',
                    textColor: Colors.white,
                  ),
                  GButton(
                    backgroundColor: Colors.black,
                    iconActiveColor: Colors.blue,
                    icon: Icons.poll,
                    textColor: Colors.white,
                    text: 'Live Updates',
                  ),
                  GButton(
                    backgroundColor: Colors.black,
                    icon: Icons.info_sharp,
                    textColor: Colors.white,
                    iconActiveColor: Colors.blue,
                    text: 'College',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
