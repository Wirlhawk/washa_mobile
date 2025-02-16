import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/helper/format_rupiah.dart';
import 'package:washa_mobile/helper/format_status.dart';
import 'package:washa_mobile/views/pages/order_detail_page.dart';

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