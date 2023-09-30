import 'package:blogapp/main.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlogListScreen(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Favorite',
            ),
          ],

            currentIndex: 0,


        ),
    );
  }
}