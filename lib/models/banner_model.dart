import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BannerModel extends ChangeNotifier {
  final String bannerId, bannerName, bannerImage;
  final Timestamp createdAt;

  BannerModel({
    required this.bannerId,
    required this.bannerName,
    required this.bannerImage,
    required this.createdAt,
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return BannerModel(
      bannerId: data['bannerId'],
      bannerName: data['bannerName'],
      bannerImage: data['bannerImage'],
      createdAt: data['createdAt'],
    );
  }
}
