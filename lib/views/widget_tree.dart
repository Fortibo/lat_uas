import 'package:flutter/material.dart';
import 'package:lat_uas/data/notifiers.dart';
import 'package:lat_uas/views/pages/home_page.dart';
import 'package:lat_uas/views/pages/post_page.dart';
import 'package:lat_uas/views/widgets/navbar.dart';
// import 'package:lat_uas/views/pages/landing_page.dart';
// import 'package:lat_uas/views/pages/login_page.dart';
// import 'package:lat_uas/views/pages/register_page.dart';

List<Widget> pages = [
  HomePage(),
  PostPage(),

  // const ProfilePage(),
  // const SettingsPage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: selectedPage,
          builder: (context, value, child) {
            return pages.elementAt(value);
          },
        ),
        bottomNavigationBar: Navbar(),
      ),
    );
  }
}
