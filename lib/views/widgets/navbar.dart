import 'package:flutter/material.dart';
import 'package:lat_uas/data/notifiers.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, value, child) {
          return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.black,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: 'Post',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.exit_to_app),
              //   label: 'Logout',
              // ),
            ],
            currentIndex: value,
            onTap: (index) {
              selectedPage.value = index;
            },
          );
        },
      ),
    );
  }
}
