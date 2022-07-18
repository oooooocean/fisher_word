import 'package:flutter/material.dart';

enum Alg {
  good,
  normal,
  bad;

  int get score => [20, 10, 5][index];

  /// 表示多少次背诵能达标
  int get level => [2, 4, 8][index];

  IconData get iconData =>
      [Icons.sentiment_very_satisfied, Icons.sentiment_neutral, Icons.sentiment_very_dissatisfied][index];

  Color get iconColor => [Colors.green, Colors.orangeAccent, Colors.red][index];
}
