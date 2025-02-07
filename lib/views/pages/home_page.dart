import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/helper/format_rupiah.dart';
import 'package:washa_mobile/helper/format_status.dart';
import 'package:washa_mobile/service/order_service.dart';
import 'package:washa_mobile/views/pages/order_detail_page.dart';
import 'package:washa_mobile/views/pages/order_page.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/header.dart';
import 'package:washa_mobile/views/widgets/map_overlay.dart';
import 'package:washa_mobile/data/notifiers.dart';
import 'package:washa_mobile/data/style.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: AppbarTitle(
                            user.email,
                            fontSize: 16,
                          )),
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
                          initialServiceID: 0,
                        ),
                        ServiceItem(
                          imagePath: '2.png',
                          label: "Quick Wash",
                          initialServiceID: 1,
                        ),
                        ServiceItem(
                          imagePath: '1.png',
                          label: "Wash & Fold",
                          initialServiceID: 2,
                        ),
                        ServiceItem(
                          imagePath: '3.png',
                          label: "Wash & Iron",
                          initialServiceID: 3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildActiveOrder()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrder() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header("Active Order"),
        FutureBuilder(
          future: _orderService.getActiveOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Header("Loading"),
              );
            }

            final activeOrders = snapshot.data!;
            inspect(activeOrders);
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: activeOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                Map<String, dynamic> activeOrder = activeOrders[index];
                return OrderCard(
                  orderID: activeOrder['id'],
                  image: activeOrder['services']['image'],
                  serviceName: activeOrder['services']['name'],
                  status: activeOrder['status'],
                  price: activeOrder['total_price'],
                );
              },
            );
          },
        ),
      ],
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
  final String serviceName;
  final String orderID;
  final int status;
  final double price;
  final String image;
  const OrderCard({
    super.key,
    required this.serviceName,
    required this.status,
    required this.price,
    required this.image,
    required this.orderID,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(orderID: orderID),
          //   builder: (context) =>
          //       SuccessPage(nextPage: OrderDetailPage(orderID: orderID)),
        ),
      ),
      child: Column(spacing: 20, children: [
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
                    serviceName,
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
                    "${formatStatus(status)} | ${formatRupiah(price)}",
                    style: GoogleFonts.poppins(
                      color: Style.secondaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Image.asset(
                'assets/images/$image',
                height: 80,
                width: 80,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String label;
  final String imagePath;
  final int initialServiceID;

  const ServiceItem({
    super.key,
    required this.label,
    required this.imagePath,
    required this.initialServiceID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderPage(
                  initialServiceID: initialServiceID,
                ),
              ),
            );
          },
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
