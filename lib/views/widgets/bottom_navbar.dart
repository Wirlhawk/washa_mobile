import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/data/notifiers.dart';
import 'package:washa_mobile/data/style.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, index, child) {
        return NavigationBar(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          shadowColor: Colors.black,
          elevation: 0,
          height: 80,
          onDestinationSelected: (value) => selectedIndex.value = value,
          indicatorColor: Colors.transparent,
          destinations: [
            NavigationDestination(
              icon: index == 0
                  ? Icon(Iconsax.home5, color: Style.primary)
                  : Icon(Iconsax.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: index == 1
                  ? Icon(Iconsax.setting1, color: Style.primary)
                  : Icon(Iconsax.setting),
              label: "Search",
            ),
            NavigationDestination(
              icon: index == 2
                  ? Icon(Iconsax.receipt_2_15, color: Style.primary)
                  : Icon(Iconsax.receipt),
              label: "Order",
            ),
            NavigationDestination(
              icon: index == 3
                  ? Icon(Iconsax.user, color: Style.primary)
                  : Icon(Iconsax.user4),
              label: "Profile",
            ),
          ],
        );
      },
    );
  }
}
