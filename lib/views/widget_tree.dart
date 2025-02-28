import 'package:flutter/material.dart';
import 'package:washa_mobile/data/notifiers.dart';
import 'package:washa_mobile/views/pages/history_page.dart';
import 'package:washa_mobile/views/pages/home_page.dart';
import 'package:washa_mobile/views/pages/profile_page.dart';
import 'package:washa_mobile/views/pages/point_history_page.dart';

import 'package:washa_mobile/views/widgets/bottom_navbar.dart';

class WidgetTree extends StatelessWidget {
  WidgetTree({
    super.key,
  });

  final List<Widget> pages = [
    HomePage(),
    PointHistoryPage(),
    HistoryPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, index, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavbar(),
          body: pages.elementAt(index),
        );
      },
    );
  }
}
