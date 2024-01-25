
import 'package:flutter/material.dart';
import 'package:formula_user/screens/about_screen.dart';
import 'package:formula_user/screens/book_mark_scree.dart';
import 'package:formula_user/screens/subjects.dart';

import '../res/colours.dart';
import '../res/styles.dart';
import 'home_page.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Subjects(),
    BookMarksScreen(),
    AboutScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colours.buttonColor2,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        selectedLabelStyle: Styles.textWith14withBold(Colours.black),
        unselectedLabelStyle: Styles.textWith14(Colours.black),
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colours.greyLight700,),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subject,color: Colours.greyLight700,),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.favorite,color: Colours.greyLight700,),
            label: 'Book Marks',
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.info,color: Colours.greyLight700,),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colours.black,
        unselectedItemColor:Colours.black,
        onTap: _onItemTapped,
      ),
    );
  }

}
