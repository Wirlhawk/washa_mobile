import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double padding;
  const CustomCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 1,
          ),
        ],
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
