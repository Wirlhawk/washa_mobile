import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/helper/format_date.dart';
import 'package:washa_mobile/helper/format_rupiah.dart';
import 'package:washa_mobile/helper/format_status.dart';
import 'package:washa_mobile/service/order_service.dart';
import 'package:washa_mobile/views/pages/home_page.dart';
import 'package:washa_mobile/views/pages/success_page.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/custom_card.dart';
import 'package:washa_mobile/views/widgets/header.dart';
import 'package:washa_mobile/views/widgets/map_overlay.dart';

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
      body: _buildOrderDetail(),
    );
  }

  Widget _buildOrderDetail() {
    return FutureBuilder(
      future: orderService.getOrderById(orderID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        inspect(snapshot.data!);
        final order = snapshot.data!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: QrImageView(
                  data: order['id'],
                  version: QrVersions.auto,
                  size: 100,
                ),
              ),
              Center(
                child: Text(order['id']),
              ),
              SizedBox(
                height: 10,
              ),
              CustomCard(
                child: Column(
                  spacing: 10,
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Style.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(10)),
                      child: Header(
                        textAlign: TextAlign.center,
                        formatStatus(order['status']),
                        color: Style.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 200,
                child: CustomCard(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: MapOverlay(
                      lat: order['address']['lat'],
                      long: order['address']['long'],
                      label: "Order Location",
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header("Address"),
                  Text(
                    order['address']['address'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Style.secondaryText,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header("Overview"),
                  SizedBox(height: 10),
                  Column(
                    spacing: 10,
                    children: [
                      // _buildDetail("Order ID", order['id']),
                      _buildDetail("Time",
                          formatDate(DateTime.parse(order['created_at']))),
                      _buildDetail("Service", order['services']['name']),
                    ],
                  )
                ],
              ),

              SizedBox(height: 10),
              
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

              if (order['status'] == 1 || order['status'] == 0)
                const SizedBox(height: 20),
              if (order['status'] == 1)
                _buildBottomAction(
                  context,
                  label: "Cancel Order",
                  orderID: order['id'],
                  onTap: () {
                    orderService.cancelOrder(orderID);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SuccessPage(
                          label: "Order Cancelled",
                          nextPage: OrderDetailPage(orderID: orderID),
                        ),
                      ),
                    );
                  },
                ),

              if (order['status'] == 0)
                _buildBottomAction(context,
                    label: "Delete Order", orderID: order['id'], onTap: () {
                  orderService.deleteOrder(orderID);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SuccessPage(
                        label: "Order Deleted",
                        nextPage: HomePage(),
                      ),
                    ),
                  );
                })
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
      String itemName, num itemPrice, num subTotal, num qty) {
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

  Widget _buildBottomAction(BuildContext context,
      {required String orderID,
      required Function() onTap,
      required String label}) {
    return InkWell(
      splashColor: Colors.red.withAlpha(50),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Header(
          label,
          textAlign: TextAlign.center,
          color: Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }
}
