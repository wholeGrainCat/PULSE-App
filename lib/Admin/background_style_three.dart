import 'package:flutter/material.dart';
import 'package:aura_box/aura_box.dart';
import 'app_colour.dart';
void main(){
  runApp(BackgroundStyleThree());
}
class BackgroundStyleThree extends StatelessWidget {
  const BackgroundStyleThree({super.key});

  @override
  Widget build(BuildContext context) {
    return AuraBox(
      spots: [
        AuraSpot(
          color: AppColors.pri_cyan,
          radius: 110,
          alignment: const Alignment(-0.7, -0.8),
          blurRadius: 90.0,
          stops: const [0.0, 0.8],
        ),
        AuraSpot(
          color: AppColors.sec_purple,
          radius: 150,
          alignment: const Alignment(0.3, 0.9),
          blurRadius: 80.0,
          stops: const [0.0, 0.7],
        ),
        AuraSpot(
          color: AppColors.pri_greenYellow,
          radius: 80,
          alignment: const Alignment(-0.1, -0.9),
          blurRadius: 50.0,
          stops: const [0.0, 0.7],
        ),
        AuraSpot(
          color: AppColors.sec_cyan,
          radius: 80,
          alignment: const Alignment(0.7, 0.8),
          blurRadius: 50.0,
          stops: const [0.0, 0.7],
        ),
      ],
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(),
    );
  }
}
