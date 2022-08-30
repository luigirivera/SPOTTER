import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
      BottomNavigationBarItem(
          icon: Icon(Icons.edit_calendar), label: 'Calendar'),
      BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Study Session'),
    ]);
  }
}
