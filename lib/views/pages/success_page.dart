import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/widgets/header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SuccessPage extends StatelessWidget {
  final Widget nextPage;
  final String label;
  final String? lottie;
  const SuccessPage(
      {super.key,
      required this.nextPage,
      required this.label,
      this.lottie = 'laundry.json'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primary,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/lotties/$lottie',
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
              )).animate().scale(),
          Align(
            alignment: const Alignment(0, 0.3), // Pindahkan sedikit ke bawah
            child: Header(
              label,
              color: Colors.white,
              fontSize: 24,
            ).animate().scale(delay: 200.ms),
          ),
        ],
      ),
    );
  }
}
