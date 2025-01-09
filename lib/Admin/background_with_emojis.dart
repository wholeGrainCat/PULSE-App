import 'package:flutter/material.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:aura_box/aura_box.dart';

class BackgroundWithEmojis extends StatelessWidget {
  const BackgroundWithEmojis({super.key});

  @override
  Widget build(BuildContext context) {
    return AuraBox(
      spots: [
        AuraSpot(
          color: const Color(0xFFAF96F5),
          radius: 150.0,
          alignment: const Alignment(0.9, -0.8),
          blurRadius: 10.0,
          stops: const [0.0, 0.7],
        ),
        AuraSpot(
          color: const Color(0xFFA4E3E8),
          radius: 250.0,
          alignment: const Alignment(0.1, -0.9),
          blurRadius: 6.0,
          stops: const [0.0, 0.5],
        ),
        AuraSpot(
          color: const Color(0xFFD9F65C),
          radius: 80.0,
          alignment: const Alignment(0.5, -0.6),
          blurRadius: 6.0,
          stops: const [0.0, 0.9],
        ),
      ],
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Stack(
        children: [
          Positioned(
            right: -15,
            top: 30,
            child: FluentUiEmojiIcon(
              w: 75,
              h: 75,
              fl: Fluents.flSmilingFace,
            ),
          ),
          Positioned(
            right: 65,
            top: 110,
            child: FluentUiEmojiIcon(
              w: 64,
              h: 64,
              fl: Fluents.flWorriedFace,
            ),
          ),
          Positioned(
            left: 150,
            top: 5,
            child: FluentUiEmojiIcon(
              w: 105,
              h: 105,
              fl: Fluents.flNeutralFace,
            ),
          ),
        ],
      ),
    );
  }
}
