import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/all_users_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/banners_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/edit_upload_product_form.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/categories/categories_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/fees/fees_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/orders_cancelled.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/orders_completed.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/orders_processing.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/search_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/assets_manager.dart';

class DashboardButtonsModel {
  final Function onPressed;
  final String imagePath;
  final String text;

  DashboardButtonsModel({
    required this.onPressed,
    required this.imagePath,
    required this.text,
  });

  //we add context so we can use navigator

  final CollectionReference<Map<String, dynamic>> productList =
      FirebaseFirestore.instance.collection('products');
  int? quer;
  // Future<int?> countProducts() async {
  //   AggregateQuerySnapshot query = await productList.count().get();
  //   debugPrint('The number of products: ${query.count}');
  //   quer = query.count;
  //   return query.count;
  // }

  static List<DashboardButtonsModel> dashboardBtnsList(context) => [
        DashboardButtonsModel(
            text: "أضف منتج جديد",
            imagePath: AssetsManager.cloud,
            onPressed: () {
              Navigator.pushNamed(context, EditOrUploadProductForm.routeName);
            }),
        DashboardButtonsModel(
            text: "عرض جميع المنتجات",
            imagePath: AssetsManager.shoppingCart,
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            }),
        DashboardButtonsModel(
            text: "عرض الإعلانات",
            imagePath: AssetsManager.addBanner,
            onPressed: () {
              Navigator.pushNamed(context, BannersScreen.routeName);
            }),
        DashboardButtonsModel(
            text: "عرض جميع التصنيفات",
            imagePath: AssetsManager.categories,
            onPressed: () {
              Navigator.pushNamed(context, CategoriesScreen.routeName);
            }),
        DashboardButtonsModel(
            text: "جميع العملاء",
            imagePath: AssetsManager.allUsers,
            onPressed: () {
              Navigator.pushNamed(context, AllUsersScreen.routeName);
            }),
        DashboardButtonsModel(
            text: "طلبيات واردة",
            imagePath: AssetsManager.order,
            onPressed: () {
              Navigator.pushNamed(context, OrdersScreenProcessing.routeName);
            }),
        DashboardButtonsModel(
            text: "طلبيات منتهية",
            imagePath: AssetsManager.orderCompleted,
            onPressed: () {
              Navigator.pushNamed(context, OrdersScreenCompleted.routeName);
            }),
        DashboardButtonsModel(
            text: "طلبيات مُلغاة",
            imagePath: AssetsManager.orderCanceled,
            onPressed: () {
              Navigator.pushNamed(context, OrdersScreenCancelled.routeName);
            }),
        DashboardButtonsModel(
            text: "مصاريف الشحن",
            imagePath: AssetsManager.deliveryFees,
            onPressed: () {
              Navigator.pushNamed(context, FeesScreen.routeName);
            }),
        // DashboardButtonsModel(
        //     text: "تعديل الأسعار",
        //     imagePath: AssetsManager.editPrice,
        //     onPressed: () {
        //       Navigator.pushNamed(context, EditPricesScreen.routeName);
        //     }),
      ];
}
