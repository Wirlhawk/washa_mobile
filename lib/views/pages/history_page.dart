import 'package:flutter/material.dart';
import 'package:washa_mobile/service/order_service.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/order_card.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppbarTitle("Order History"),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            dividerHeight: 0,
            tabs: <Widget>[
              Tab(
                child: Text("All Order"),
              ),
              Tab(
                child: Text("Pending"),
              ),
              Tab(
                child: Text("Washing"),
              ),
              Tab(
                child: Text("Drying"),
              ),
              Tab(
                child: Text("On Delivery"),
              ),
              Tab(
                child: Text("Sucess"),
              ),
              Tab(
                child: Text("Cancelled"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildOrderHistory(null), // All Orders
            _buildOrderHistory(1), // Pending
            _buildOrderHistory(2), // Washing
            _buildOrderHistory(3), // Drying
            _buildOrderHistory(4), // On Delivery
            _buildOrderHistory(5), // Success
            _buildOrderHistory(0), // Cancelled
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistory(int? status) {
    return FutureBuilder(
      future: _orderService.getAllOrder(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text("No orders found"));
        } else {
          List orders = snapshot.data as List;

          return SingleChildScrollView(
            child: ListView.separated(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                Map<String, dynamic> order = orders[index];
                return OrderCard(
                  orderID: order['id'],
                  image: order['services']['image'],
                  serviceName: order['services']['name'],
                  status: order['status'],
                  price: order['total_price'],
                );
              },
            ),
          );
        }
      },
    );
  }
}
