import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/banner_model.dart';

class BannersProvider extends ChangeNotifier {
  List<BannerModel> banners = [];
  List<BannerModel> get getBanners {
    return banners;
  }

  //Show Product and Product Details
  BannerModel? findByBannerId(String bannerId) {
    if (banners.where((element) => element.bannerId == bannerId).isEmpty) {
      return null;
    }
    return banners.firstWhere((element) => element.bannerId == bannerId);
  }

  // Fetch categories from firebase
  final bannerDb = FirebaseFirestore.instance.collection("banners");
  Future<List<BannerModel>> fetchBanners() async {
    try {
      await bannerDb.get().then((bannerSnapshot) {
        banners.clear();
        for (var element in bannerSnapshot.docs) {
          banners.insert(0, BannerModel.fromFirestore(element)
              // ProductModel(
              //     productId: element.get("productId"),
              //     productTitle: element.get("productTitle"),
              //     productPrice: element.get("productPrice"),
              //     productCategory: element.get("productCategory"),
              //     productDescription: element.get("productDescription"),
              //     productImage: element.get("productImage"),
              //     productQuantity: "productQuantity")
              );
        }
      });
      notifyListeners();
      // print(products);
      return banners;
    } catch (e) {
      rethrow;
    }
  }

  final bannersDb = FirebaseFirestore.instance.collection("banners");
  Stream<List<BannerModel>> fetchBannerStream() {
    try {
      return bannersDb.snapshots().map((snapshot) {
        banners.clear();
        for (var element in snapshot.docs) {
          banners.insert(0, BannerModel.fromFirestore(element)
              // ProductModel(
              //     productId: element.get("productId"),
              //     productTitle: element.get("productTitle"),
              //     productPrice: element.get("productPrice"),
              //     productCategory: element.get("productCategory"),
              //     productDescription: element.get("productDescription"),
              //     productImage: element.get("productImage"),
              //     productQuantity: "productQuantity")
              );
        }
        return banners;
      });
    } catch (e) {
      rethrow;
    }
  }

  //count categories in firebase
  final CollectionReference<Map<String, dynamic>> bannerList =
      FirebaseFirestore.instance.collection('banners');

  //Fees Collection
  final CollectionReference<Map<String, dynamic>> feesList =
      FirebaseFirestore.instance.collection('orderFees');
  int? bannersCount;
  Future<int?> countBanners() async {
    AggregateQuerySnapshot query = await bannerList.count().get();
    // debugPrint('The number of categories: ${query.count}');
    bannersCount = query.count;
    notifyListeners();
    return query.count;
  }

//create function to delete category from firebase
  Future<void> deleteBanner(String bannerId) {
    return bannerList.doc(bannerId).delete();
  }

//create function to delete Place from firebase
  Future<void> deletePlace(String categoryId) {
    return feesList.doc(categoryId).delete();
  }

//create function to add category to firebase
  Future<void> addBanner(
      String bannerId, String bannerName, String bannerImage) {
    return bannerList.doc(bannerId).set({
      'bannerId': bannerId,
      'bannerName': bannerName,
      "bannerImage": bannerImage
    });
  }

  //create function to edit category in firebase
  // Future<void> editCategory(
  //     {categoryId, String categoryName, String categoryImage}) {
  //   return categoryList.doc(categoryId).update({
  //     'categoryId': categoryId,
  //     'categoryName': categoryName,
  //     "categoryImage": categoryImage
  //   });
  // }
}
