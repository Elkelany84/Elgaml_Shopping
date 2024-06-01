import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  const SubtitleTextWidget(
      {super.key,
      required this.label,
      this.fontSize = 18,
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.normal,
      this.color,
      this.textDecoration = TextDecoration.none,
      this.textOverflow,
      this.maxLines,
      this.textDirection});

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  final String? textOverflow;
  final int? maxLines;
  final textDirection;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textDirection: textDirection,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: color,
        fontStyle: fontStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
