import 'package:flutter/material.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/helper/format_rupiah.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class ClothesForm extends StatefulWidget {
  final String label;
  final int clothesID;
  final double price;
  final Function(int, int)? updateQuantity;

  const ClothesForm({
    super.key,
    required this.label,
    this.updateQuantity,
    required this.clothesID,
    required this.price,
  });

  @override
  State<ClothesForm> createState() => _ClothesFormState();
}

class _ClothesFormState extends State<ClothesForm> {
  int quantity = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
    widget.updateQuantity?.call(quantity, widget.clothesID);
  }

  void decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      widget.updateQuantity?.call(quantity, widget.clothesID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: quantity > 0 ? Style.primary : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                widget.label,
                color: quantity > 0 ? Colors.white : Style.primary,
              ),
              Text(
                formatRupiah(widget.price),
                style: TextStyle(
                  color: quantity > 0 ? Colors.white : Style.secondaryText,
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: decrementQuantity,
                icon: Icon(Icons.remove,
                    color: quantity > 0 ? Colors.white : Style.primary),
              ),
              Text("$quantity",
                  style: TextStyle(
                      fontSize: 16,
                      color: quantity > 0 ? Colors.white : Style.primary)),
              IconButton(
                onPressed: incrementQuantity,
                icon: Icon(
                  Icons.add,
                  color: quantity > 0 ? Colors.white : Style.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
