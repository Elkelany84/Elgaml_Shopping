import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class ProductModel extends ChangeNotifier {
  final String productId,
      productTitle,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  final num productPrice;
  final num? productBeforeDiscount;
  Timestamp? createdAt;
  List<String>? imageFileList;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
    this.productBeforeDiscount,
    this.imageFileList,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return ProductModel(
      //doc.get(field),
      productId: data['productId'],
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productBeforeDiscount: data['productBeforeDiscount'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productImage: data['productImage'],
      productQuantity: data['productQuantity'], createdAt: data['createdAt'],
      // imageFileList: data['imageFileList'],
    );
  }
}
