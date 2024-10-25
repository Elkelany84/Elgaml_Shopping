import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/search_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget(
      {super.key, required this.image, required this.name});
  final String image, name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SearchScreen.routeName, arguments: name);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FancyShimmerImage(
              boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              imageUrl: image,
              height: 60,
              width: 60,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: SubtitleTextWidget(
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              // softWrap: true,
              maxLines: 1,
              label: name,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
