import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/root_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class EmptyBag extends StatelessWidget {
  const EmptyBag(
      {super.key,
      required this.imagePath,
      this.title = "",
      this.subtitle = "",
      this.details = "",
      this.buttonFont = 14,
      this.titleFont = 20,
      this.buttonWidth = 150,
      required this.buttonText});
  final String title, subtitle, details, buttonText, imagePath;
  final double buttonFont, titleFont, buttonWidth;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
          ),
          const SizedBox(
            height: 40,
          ),
          TitleTextWidget(
            label: title,
            fontSize: titleFont,
            color: Colors.red,
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          Center(
            child: SubtitleTextWidget(
              label: subtitle,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubtitleTextWidget(
              label: details,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 60,
            width: buttonWidth,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RootScreen.routeName);
                },
                child: TitleTextWidget(
                  label: buttonText,
                  fontSize: buttonFont,
                )),
          )
        ],
      ),
    );
  }
}
