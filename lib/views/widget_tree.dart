import 'package:flutter/material.dart';
import 'package:washa_mobile/data/notifiers.dart';
import 'package:washa_mobile/views/pages/home_page.dart';
import 'package:washa_mobile/views/widgets/bottom_navbar.dart';
import 'package:washa_mobile/views/widgets/map_overlay.dart';

class WidgetTree extends StatelessWidget {
  WidgetTree({
    super.key,
  });

  final List<Widget> pages = [
    HomePage(),
    OrderCard(),
    MapOverlay(),
    HomePage()
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
