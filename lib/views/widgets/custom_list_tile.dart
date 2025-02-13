import 'package:flutter/material.dart';
import 'package:washa_mobile/data/style.dart';

class CustomListTile extends StatelessWidget {
  final String label;
  final IconData labelIcon;
  final Function()? onTap;
  final IconData buttonIcon;

  const CustomListTile({
    super.key,
    required this.label,
    required this.labelIcon,
    this.onTap,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  labelIcon,
                  color: Style.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            IconButton(
              padding: EdgeInsets.zero,
              color: Style.primary,
              onPressed: onTap,
              icon: Icon(
                buttonIcon,
                size: 18,
                color: Style.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
