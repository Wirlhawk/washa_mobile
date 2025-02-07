import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:washa_mobile/models/order_model.dart';

class OrderService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllService() async {
    return await _supabase
        .from('services')
        .select()
        .order('created_at', ascending: true);
  }

  Future<List<Map<String, dynamic>>> getAllClothes() async {
    return await _supabase.from('clothes').select();
  }

  Future getOrderById(
    String orderID,
  ) async {
    final order = await _supabase
        .from('orders')
        .select('*,services(*), order_items(*, clothes(name, price))')
        .eq('id', orderID)
        .single();

    return order;
  }

  Future<PostgrestMap> createOrder({
    required List<OrderModel> orders,
    required String address,
    required int serviceID,
    required double price,
  }) async {
    final userID = _supabase.auth.currentUser!.id;

    var newOrder = await _supabase
        .from('orders')
        .insert([
          {
            'user_id': userID,
            'address': address,
            'total_price': price,
            'service_id': serviceID,
            'status': 1,
          }
        ])
        .select()
        .single();

    List<Map<String, dynamic>> ordersMap = orders
        .map(
          (order) => {
            "clothes_id": order.clothesID,
            "subtotal": order.subTotal,
            "quantity": order.quantity,
            "order_id": newOrder['id']
          },
        )
        .toList();

    await _supabase.from('order_items').insert(ordersMap);

    return newOrder;
  }

  Future<List<Map<String, dynamic>>> getActiveOrder() async {
    final userID = _supabase.auth.currentUser!.id;

    return await _supabase
        .from('orders')
        .select('*,services(*), order_items(*, clothes(name, price))')
        .eq('user_id', userID)
        .order('created_at', ascending: false);
  }

  Future<void> cancelOrder(String orderID) async {
    return await _supabase
        .from('orders')
        .update({'status': 0}).eq('id', orderID);
  }

  Future<void> deleteOrder(String orderID) async {
    return await _supabase.from('orders').delete().eq('id', orderID);
  }
}
