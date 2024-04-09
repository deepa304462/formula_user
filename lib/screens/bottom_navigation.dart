import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formula_user/screens/about_screen.dart';
import 'package:formula_user/screens/book_mark_scree.dart';
import 'package:formula_user/screens/subjects.dart';
import '../res/colours.dart';
import '../res/styles.dart';
import 'home_page.dart';

class MyBottomNavigation extends StatefulWidget {
  MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    Subjects(),
    const BookMarksScreen(),
    const AboutScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.buttonColor2,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colours.buttonColor2,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        selectedLabelStyle: Styles.textWith14(Colours.white),
        unselectedLabelStyle: Styles.textWith14(Colours.black),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/homepage.svg",
              color: Colours.gret500,
            ),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.subject,
              color: Colours.gret500,
              size: 20,
            ),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/bookmark.svg",
              color: Colours.gret500,
            ),
            label: 'Book Marks',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/about.svg",
              color: Colours.gret500,
              width: 20,
              height: 20,
            ),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colours.white,
        unselectedItemColor: Colours.gret500,
        onTap: _onItemTapped,
      ),
    );
  }
}
