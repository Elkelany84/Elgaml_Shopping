import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/banner_model.dart';
import 'package:hadi_ecommerce_firebase_admin/models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoriesModel> categories = [];
  List<CategoriesModel> get getCategories => categories;
  List<CategoriesModel> categoriesList = [];

  //banner list
  List<BannerModel> banners = [];
  List<BannerModel> get getBanners {
    return banners;
  }

  // Fetch banners from firebase
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

  // Fetch categories from firebase
  final categoriesDb = FirebaseFirestore.instance.collection("categories");
  Future<List<CategoriesModel>> fetchCategories() async {
    try {
      await categoriesDb
          .orderBy("createdAt", descending: true)
          .get()
          .then((productSnapshot) {
        categories.clear();
        for (var element in productSnapshot.docs) {
          categories.insert(0, CategoriesModel.fromFirestore(element)
              // ProductModel(
              //     productId: element.get("productId"),
              //     productTitle: element.get("productTitle"),
              //     productPrice: element.get("productPrice"),
              //     productCategory: element.get("productCategory"),
              //     productDescription: element.get("productDescription"),
              //     productImage: element.get("productImage"),
              //     productQuantity: "productQuantity")
              );
          categoriesList.insert(0, CategoriesModel.fromFirestore(element));
        }
      });
      notifyListeners();

      return categories;
    } catch (e) {
      rethrow;
    }
  }
}
