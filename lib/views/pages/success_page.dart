import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class SuccessPage extends StatelessWidget {
  final Widget nextPage;
  const SuccessPage({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primary,
      body: Stack(
        children: [
          // Lottie animation in center
          Align(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/lotties/laundry.json',
              onLoaded: (composition) {
                Future.delayed(
                  composition.duration,
                  () {
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => nextPage,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.3), // Pindahkan sedikit ke bawah
            child: Header(
              "Order Created",
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
