import 'package:flutter/material.dart';

import '../sabitler/renkler.dart';

import 'package:flutter/material.dart';

class MyCircularProgressContainer extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const MyCircularProgressContainer({
    Key? key,
    required this.size,
    required this.color,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
