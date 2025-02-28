import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/helper/format_date.dart';
import 'package:washa_mobile/service/order_service.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/custom_card.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class PointHistoryPage extends StatelessWidget {
  const PointHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();
    return Scaffold(
        appBar: AppBar(
          title: AppbarTitle("Points History"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: orderService.getPointHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(child: Text('No points history available.'));
              } else {
                return ListView.separated(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data[index];
                    inspect(snapshot.data!);
                    return CustomCard(
                      padding: 6,
                      child: ListTile(
                        title: Header("Transaction", color: Style.primary),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Header(
                                  "Earned",
                                  fontSize: 14,
                                ),
                                Header(
                                  "+${transaction['earned']}",
                                  fontSize: 14,
                                  color: Colors.green,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Header(
                                  "Redeemed",
                                  fontSize: 14,
                                ),
                                Header(
                                  "-${transaction['redeemed']}",
                                  fontSize: 14,
                                  color: Colors.red,
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Header(
                              formatDate(
                                DateTime.parse(transaction['created_at']),
                              ),
                              fontSize: 12,
                              color: Style.secondaryText,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
