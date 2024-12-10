import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoryModel> categories = [];
  List<CategoryModel> get getCategories {
    return categories;
  }

  //Show Product and Product Details
  CategoryModel? findByCategoryId(String categoryId) {
    if (categories
        .where((element) => element.categoryId == categoryId)
        .isEmpty) {
      return null;
    }
    return categories.firstWhere((element) => element.categoryId == categoryId);
  }

  // Fetch categories from firebase
  final productDb = FirebaseFirestore.instance.collection("categories");
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      await productDb.get().then((productSnapshot) {
        categories.clear();
        for (var element in productSnapshot.docs) {
          categories.insert(0, CategoryModel.fromFirestore(element)
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
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  final categoriesDb = FirebaseFirestore.instance.collection("categories");
  Stream<List<CategoryModel>> fetchCategoryStream() {
    try {
      return categoriesDb.snapshots().map((snapshot) {
        categories.clear();
        for (var element in snapshot.docs) {
          categories.insert(0, CategoryModel.fromFirestore(element)
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
        return categories;
      });
    } catch (e) {
      rethrow;
    }
  }

  //count categories in firebase
  final CollectionReference<Map<String, dynamic>> categoryList =
      FirebaseFirestore.instance.collection('categories');

  //Fees Collection
  final CollectionReference<Map<String, dynamic>> feesList =
      FirebaseFirestore.instance.collection('orderFees');
  int? categoriesCount;
  Future<int?> countCategories() async {
    AggregateQuerySnapshot query = await categoryList.count().get();
    // debugPrint('The number of categories: ${query.count}');
    categoriesCount = query.count;
    notifyListeners();
    return query.count;
  }

//create function to delete category from firebase
  Future<void> deleteCategory(String categoryId) {
    return categoryList.doc(categoryId).delete();
  }

//create function to delete Place from firebase
  Future<void> deletePlace(String categoryId) {
    return feesList.doc(categoryId).delete();
  }

//create function to add category to firebase
  Future<void> addCategory(
      String categoryId, String categoryName, String categoryImage) {
    return categoryList.doc(categoryId).set({
      'categoryId': categoryId,
      'categoryName': categoryName,
      "categoryImage": categoryImage
    });
  }

  //convert field productQuantity from string to int
  Future<void> convertProductQuantities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch all documents from the 'products' collection
    QuerySnapshot querySnapshot = await firestore.collection('products').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Get the current productQuantity field as a string
      String quantityString = doc.get('productBeforeDiscount');

      // Convert the quantity string to an integer
      int quantityInt = int.parse(quantityString);

      // Update the document with the new productQuantity field as an integer
      await firestore.collection('products').doc(doc.id).update({
        'productBeforeDiscount': quantityInt,
      });

      print(
          'Updated document ID: ${doc.id} with new productBeforeDiscount: $quantityInt');
    }
  }

  //create function to add colors array field to products
  Future<void> addColorsFieldToProducts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch all documents from the 'products' collection
    QuerySnapshot querySnapshot =
        await firestore.collection('newProducts').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Add an empty 'colors' array field to each document
      await firestore.collection('newProducts').doc(doc.id).update({
        'colors': [],
      });

      print('Updated document ID: ${doc.id} with an empty colors array');
    }
  }

  //create function to add colors map field to products

  Future<void> addColorsMapToProducts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection('products');
    QuerySnapshot querySnapshot = await products.get();

    Map<String, bool> colorsMap = {
      '4279437290': false,
      '0xFF0A0707': false,
      '0xFFC3EA07': false,
      '0xFFEA1C07': false,
      '0xffad9c00': false,
      '0xFF0ED422': false,
      '0xFFC0C0C0': false
    };

    // Update each document in the collection
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({'colorsMap': colorsMap});
      print('Updated document ID: ${doc.id}');
    }
  }

//add colors map field to products if it does not exist

  Future<void> addColorsMapIfNotExists() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection('products');
    QuerySnapshot querySnapshot = await products.get();

    // Update each document in the collection
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (!data.containsKey('colorsMap')) {
        await doc.reference.update({
          'colorsMap': {},
        });
        print('Added colors map to document ID: ${doc.id}');
      } else {
        print('Document ID: ${doc.id} already has colors map.');
      }
    }

    print('Checked and updated colors map for all documents.');
  }

//add fields to colorsMap
  Future<void> updateColorsMapForAllDocuments() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection('products');
    QuerySnapshot querySnapshot = await products.get();

    // Update each document in the collection
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> colorsMap = doc['colorsMap'];
      // Print existing keys and values
      colorsMap.forEach((key, value) {
        print('Document ID: ${doc.id} - Key: $key, Value: $value');
      });

      // Add new key-value pair
      await doc.reference.update({
        'colorsMap.0xFF0EE53C': false,
        'colorsMap.0xFFC0C0C0': false,
      });
      print(
          'Updated colors map for document ID: ${doc.id} with new key-value pair.');
    }

    print('Retrieved and updated colors map for all documents.');
  }

//get list value from firebase
  Future<List<dynamic>> getProductList() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firestore
        .collection('newProducts')
        .doc('CKle6aKVL73Xm3qtB814')
        .get();
    List<dynamic> productList = documentSnapshot['colors'];
    print(productList);
    List<dynamic> unique = productList.toSet().toList();
    print(unique);
    return productList;
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
