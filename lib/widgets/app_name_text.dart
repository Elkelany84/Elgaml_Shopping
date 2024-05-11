import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'title_text.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({
    super.key,
    this.fontSize = 30,
    required this.label,
    this.fontFamily = "",
  });
  final String label;
  final double fontSize;
  final String? fontFamily;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 22),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: TitlesTextWidget(
        label: label,
        fontSize: fontSize,
        fontFamily: fontFamily,
      ),
    );
  }
}
