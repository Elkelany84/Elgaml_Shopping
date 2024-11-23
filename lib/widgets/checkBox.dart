import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({super.key, this.fct, this.text, this.isChecked});
  final bool? isChecked;
  final Function? fct;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: isChecked,
            onChanged: (value) {
              fct;
            }),
        SizedBox(
          width: 3,
        ),
        SubtitleTextWidget(label: text!)
      ],
    );
  }
}
