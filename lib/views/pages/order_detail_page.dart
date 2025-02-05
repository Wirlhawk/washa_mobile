import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/helper/format_date.dart';
import 'package:washa_mobile/helper/format_rupiah.dart';
import 'package:washa_mobile/helper/format_status.dart';
import 'package:washa_mobile/service/order_service.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/custom_card.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderID;
  OrderDetailPage({super.key, required this.orderID});

  final orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Style.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: AppbarTitle("Order Detail"),
        ),
        body: _buildOrderDetail());
  }

  Widget _buildOrderDetail() {
    return FutureBuilder(
      future: orderService.getOrderById(orderID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Header("Loading"),
          );
        }

        inspect(snapshot.data);
        final order = snapshot.data!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: QrImageView(
                  data: '1234567890',
                  version: QrVersions.auto,
                  size: 100,
                ),
              ),

              Center(
                child: Text("ID10381515"),
              ),
              SizedBox(
                height: 10,
              ),
              CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/${order['services']['image']}',
                          height: 80,
                          width: 80,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Header(
                              order['services']['name'],
                              color: Style.primary,
                            ),
                            Text(
                              "Ordered Today at 17:30",
                              style: TextStyle(
                                  color: Style.secondaryText,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Style.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(10)),
                      child: Header(
                        formatStatus(order['status']),
                        color: Style.primary,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header("Overview"),
                  SizedBox(height: 10),
                  Column(
                    spacing: 10,
                    children: [
                      _buildDetail("Order ID", order['id']),
                      _buildDetail("Time",
                          formatDate(DateTime.parse(order['created_at']))),
                      _buildDetail("Service", order['services']['name'])
                    ],
                  )
                ],
              ),

              SizedBox(height: 10),
              //   items
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header("Items"),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order['order_items'].length,
                    itemBuilder: (conte2xt, index) {
                      List orderItems = order['order_items'];

                      return _buildItemPrice(
                        orderItems[index]['clothes']['name'],
                        orderItems[index]['clothes']['price'],
                        orderItems[index]['subtotal'],
                        orderItems[index]['quantity'],
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    "Total",
                    color: Style.primary,
                    fontSize: 24,
                  ),
                  Header(
                    formatRupiah(order['total_price']),
                    fontSize: 20,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetail(left, right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Style.secondaryText,
          ),
        ),
        Text(right),
      ],
    );
  }

  Widget _buildItemPrice(
      String itemName, double itemPrice, double subTotal, int qty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          itemName,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Style.secondaryText),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${qty}x ${formatRupiah(itemPrice)}"),
            Text(
              formatRupiah(subTotal),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
