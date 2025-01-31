import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget(
      {super.key,
      required this.label,
      this.fontSize = 20,
      this.color,
      this.maxLines,
      this.overflow,
      this.textDirection});

  final String label;
  final double fontSize;

  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final textDirection;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      style: TextStyle(
          fontFamily: "Almarai",
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
          overflow: TextOverflow.ellipsis),
    );
  }
}
