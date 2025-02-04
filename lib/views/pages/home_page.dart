import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/views/widgets/map_overlay.dart';
import 'package:washa_mobile/data/notifiers.dart';
import 'package:washa_mobile/data/style.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            MapOverlay(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        "Washa",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Style.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 168),
                  LocationInput(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ServiceItem(
                        imagePath: '4.png',
                        label: "Regular Wash",
                      ),
                      ServiceItem(
                        imagePath: '2.png',
                        label: "Quick Wash",
                      ),
                      ServiceItem(
                        imagePath: '1.png',
                        label: "Wash & Fold",
                      ),
                      ServiceItem(
                        imagePath: '3.png',
                        label: "Wash & Iron",
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  OrderCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationInput extends StatelessWidget {
  const LocationInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(
                  Iconsax.location5,
                  color: Style.primary,
                ),
                ValueListenableBuilder(
                  valueListenable: addresNotifier,
                  builder:
                      (BuildContext context, dynamic address, Widget? child) {
                    return Text(
                      address,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
            Icon(
              Iconsax.arrow_down_1,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Active Order",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Column(
          spacing: 20,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1,
                  ),
                ],
                color: Colors.grey.shade100,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quick Wash",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Style.primary,
                        ),
                      ),
                      Text(
                        "Estimation Finish Today at 17.30",
                        style: TextStyle(
                          color: Style.secondaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "On Delivery | Rp.15,000.00",
                        style: GoogleFonts.poppins(
                          color: Style.secondaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/images/2.png',
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String label;
  final String imagePath;

  const ServiceItem({
    super.key,
    required this.label,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 80,
            width: 80,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              //   color: const Color.fromARGB(20, 8, 66, 226),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 1,
                ),
              ],
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/images/$imagePath',
              height: 80,
              width: 80,
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Style.secondaryText,
          ),
        )
      ],
    );
  }
}
