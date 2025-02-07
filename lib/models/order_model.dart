class OrderModel {
  final int clothesID;
  final double subTotal;
  int quantity;

  OrderModel({
    required this.clothesID,
    required this.subTotal,
    this.quantity = 1,
  });
}
