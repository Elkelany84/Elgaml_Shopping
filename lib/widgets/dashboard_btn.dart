import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';

class DashboardButtonsWidget extends StatelessWidget {
  const DashboardButtonsWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });
  final text, imagePath;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          height: 120,
          child: Card(
            semanticContainer: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(height: 10),
                SubtitleTextWidget(label: text),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
