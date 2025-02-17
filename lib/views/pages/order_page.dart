import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/helper/format_rupiah.dart';
import 'package:washa_mobile/models/order_model.dart';
import 'package:washa_mobile/service/order_service.dart';
import 'package:washa_mobile/views/pages/order_detail_page.dart';
import 'package:washa_mobile/views/pages/success_page.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/clothes_form.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class OrderPage extends StatefulWidget {
  final int initialServiceID;

  const OrderPage({super.key, this.initialServiceID = 0});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late int selectedServiceIndex;
  int selectedClothesIndex = 0;
  double totalPrice = 0;
  late Map? address;

  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> clothes = [];
  List<OrderModel> orders = [];

  final OrderService orderService = OrderService();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    selectedServiceIndex = widget.initialServiceID;
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _fetchAddress(),
      _fetchClothes(),
      _fetchServices(),
    ]);
    if (services.isNotEmpty && clothes.isNotEmpty) {
      _calculateTotalPrice();
    }
  }

  Future<void> _fetchClothes() async {
    final data = await orderService.getAllClothes();
    setState(() {
      clothes = data;
    });
  }

  Future<void> _fetchServices() async {
    final data = await orderService.getAllService();
    setState(() {
      services = data;
    });
  }

  Future<void> _createOrder(BuildContext context) async {
    if (totalPrice > 0) {
      if (address == null || address!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please add your address first"),
          ),
        );
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => LocationPickerPage()),
        // );
        return;
      }

      try {
        final newOrder = await orderService.createOrder(
          serviceID: selectedServiceIndex + 1,
          orders: orders,
          price: totalPrice,
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SuccessPage(
              label: "Order Created",
              nextPage: OrderDetailPage(
                orderID: newOrder['id'],
              ),
            ),
          ),
        );
      } catch (e) {
        debugPrint('ERROR : $e');
      }
    }
  }

  Future<void> _fetchAddress() async {
    final data = await authService.getCurrentUserProfile();
    setState(() {
      address = data['address'] ?? {};
    });
  }

  void updateQuantity(int qty, int clothesID, clothesPrice) {
    final existingIndex =
        orders.indexWhere((item) => item.clothesID == clothesID);
    final subtotal = clothesPrice * qty;
    final newOrder = OrderModel(
      clothesID: clothesID,
      quantity: qty,
      subTotal: subtotal,
    );

    if (existingIndex != -1) {
      if (qty != 0) {
        setState(() {
          orders[existingIndex] = newOrder;
        });
      } else {
        setState(() {
          orders.removeWhere((item) => item.clothesID == clothesID);
        });
      }
    } else {
      setState(() {
        orders.add(newOrder);
      });
    }
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    final service = services[selectedServiceIndex];
    double price = 0;
    for (var order in orders) {
      price += order.subTotal;
    }
    price = price * service['price_multiplier'];
    setState(() {
      totalPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Style.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppbarTitle("Order"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: _buildBottomPriceBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // LocationInput(),
            SizedBox(
              height: 20,
            ),
            _buildClothesOption(),
            SizedBox(
              height: 20,
            ),
            _buildServiceOption(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),
            _buildPriceDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildClothesOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Header("Select Item"),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clothes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedClothesIndex = index;
                });
                _calculateTotalPrice();
              },
              child: ClothesForm(
                price: clothes[index]['price'],
                label: clothes[index]['name'],
                clothesID: clothes[index]['id'],
                updateQuantity: (qty, clothesID) {
                  updateQuantity(qty, clothesID, clothes[index]['price']);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Header("Service Options"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ServiceItem(
              imagePath: '4.png',
              label: "Regular Wash",
              isSelected: selectedServiceIndex == 0,
              onTap: () {
                setState(() => selectedServiceIndex = 0);
                _calculateTotalPrice();
              },
            ),
            ServiceItem(
              imagePath: '2.png',
              label: "Quick Wash",
              isSelected: selectedServiceIndex == 1,
              onTap: () {
                setState(() => selectedServiceIndex = 1);
                _calculateTotalPrice();
              },
            ),
            ServiceItem(
              imagePath: '1.png',
              label: "Wash & Fold",
              isSelected: selectedServiceIndex == 2,
              onTap: () {
                setState(() => selectedServiceIndex = 2);
                _calculateTotalPrice();
              },
            ),
            ServiceItem(
              imagePath: '3.png',
              label: "Wash & Iron",
              isSelected: selectedServiceIndex == 3,
              onTap: () {
                setState(() => selectedServiceIndex = 3);
                _calculateTotalPrice();
              },
            ),
          ],
        ),
      ],
    );
    //   return SingleChildScrollView(
    //     scrollDirection: Axis.horizontal,
    //     child: Row(
    //       mainAxisAlignment:
    //           MainAxisAlignment.spaceEvenly, // Adjusted to space the items evenly
    //       children: List.generate(
    //         services.length,
    //         (index) => ServiceItem(
    //           label: services[index]['name'],
    //           imagePath: '4.png',
    //           isSelected: selectedServiceIndex == index,
    //           onTap: () {
    //             setState(() => selectedServiceIndex = index);
    //             _calculateTotalPrice();
    //           },
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }

  Widget _buildPriceDetail() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header("Price"),
        ListView.builder(
          itemCount: orders.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final clothesID = orders[index].clothesID;
            final orderClothes = clothes.firstWhere(
              (item) => item['id'] == clothesID,
              orElse: () => {},
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderClothes['name'] ?? "Unknown",
                  style: TextStyle(
                      color: Style.secondaryText, fontWeight: FontWeight.w600),
                ),
                Text(
                  formatRupiah(orders[index].subTotal),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomPriceBar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _createOrder(context),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 18, right: 10, top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: totalPrice > 0 ? Style.primary : Style.secondaryText,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Header(
                "Order",
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Header(
                    formatRupiah(totalPrice),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Iconsax.arrow_right5,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final String imagePath;
  final Function()? onTap;

  const ServiceItem({
    super.key,
    required this.label,
    required this.imagePath,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 80,
            width: 80,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              //   color: const Color.fromARGB(20, 8, 66, 226),
              border: isSelected
                  ? Border.all(color: Style.primary, width: 2)
                  : null,
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
