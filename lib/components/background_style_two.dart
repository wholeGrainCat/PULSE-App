import 'package:flutter/material.dart';
import 'package:aura_box/aura_box.dart';
import 'package:student/components/app_colour.dart';

class BackgroundStyleTwo extends StatelessWidget {
  const BackgroundStyleTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return AuraBox(
      spots: [
        AuraSpot(
          color: AppColors.sec_purple,
          radius: 100,
          alignment: const Alignment(-0.7, -0.7),
          blurRadius: 50.0,
          stops: const [0.0, 0.7],
        ),
        AuraSpot(
          color: AppColors.pri_greenYellow,
          radius: 100,
          alignment: const Alignment(0.9, -0.3),
          blurRadius: 40.0,
          stops: const [0.0, 0.8],
        ),
      ],
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(),
    );
  }
}
