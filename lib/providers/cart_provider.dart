import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/models/cart_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:uuid/uuid.dart';

import '../screens/auth/login_screen.dart';

var uuid = const Uuid();

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get cartItems => _cartItems;
  var fees = 0.0;

  final usersDb = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;

  //add products to firebase
  Future<void> addToCartFirebase({
    required String productId,
    required int quantity,
    required BuildContext context,
    required String color,
  }) async {
    User? user = auth.currentUser;
    if (user == null) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: "برجاء تسجيل الدخول أولا",
        fct: () async {
          await FirebaseAuth.instance.signOut();
          // if (!mounted) return;
          Navigator.pushNamed(context, LoginScreen.routeName);

          // auth.signOut().then((value) => Navigator.of(context)
          //     .pushNamed(RootScreen.routeName));
        },
        isError: false,
      );
      // MyAppFunctions.showErrorOrWarningDialog(
      //     isError: false,
      //     context: context,
      //     fct: () {
      //       // print("kkkk");
      //       Navigator.pop(context);
      //       Navigator.pushNamed(context, LoginScreen.routeName);
      //     },
      //     subTitle: "برجاء تسجيل الدخول أولا");
      return;
      // Navigator.pushNamed(context, LoginScreen.routeName);
    }
    final uid = user.uid;
    final cartId = uuid.v4();
    try {
      await usersDb.doc(uid).update({
        "userCart": FieldValue.arrayUnion([
          {
            "cartId": cartId,
            "productId": productId,
            "quantity": quantity,
            "color": color
          }
        ]),
      });
      //get the cart items from firebase and show it in cart screen
      await getCartItemsFromFirebase();
      Fluttertoast.showToast(msg: "تمت الإضافة للسلة");
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  //Get Cart Items From Firebase
  Future<void> getCartItemsFromFirebase() async {
    final User? user = auth.currentUser;
    if (user == null) {
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await usersDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final length = userDoc.get("userCart").length;
      for (int index = 0; index < length; index++) {
        _cartItems.putIfAbsent(
            userDoc.get("userCart")[index]["productId"],
            () => CartModel(
                  productId: userDoc.get("userCart")[index]["productId"],
                  cartId: userDoc.get("userCart")[index]["cartId"],
                  quantity: userDoc.get("userCart")[index]["quantity"],
                  color: userDoc.get("userCart")[index]["color"],
                ));
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  //delete product from cart in firebase
  Future<void> deleteProductFromCartFirebase(
      {required String cartId,
      required String productId,
      required int quantity,
      required String color}) async {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    try {
      await usersDb.doc(uid).update({
        "userCart": FieldValue.arrayRemove([
          {
            "cartId": cartId,
            "productId": productId,
            "quantity": quantity,
            'color': color
          }
        ]),
      });
      //get the cart items from firebase and show it in cart screen
      await getCartItemsFromFirebase();
      cartItems.remove(productId);
      Fluttertoast.showToast(msg: "تم الحذف من السلة");
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  //clear the whole cart from firebase
  Future<void> clearCartFirebase() async {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    try {
      await usersDb.doc(uid).update({
        "userCart": [],
      });
      //get the cart items from firebase and show it in cart screen
      await getCartItemsFromFirebase();
      cartItems.clear();
      Fluttertoast.showToast(msg: "Thank You For Shopping With Us");
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  // Add the product to the cart
  void addToCart({
    required String productId,
  }) {
    _cartItems.putIfAbsent(
        productId,
        () => CartModel(
            productId: productId,
            cartId: uuid.v4(),
            quantity: 1,
            color: 'Normal'));
    // Notify listeners that the cart has changed
    notifyListeners();
  }

  //Check if The Product is in the cart
  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  //Remove Item From Cart
  void removeFromCart({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  //Get Total Price for cart
  double getTotal({required ProductsProvider productsProvider}) {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      final getCurrentProduct = productsProvider.findByProdId(value.productId);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        // total += double.parse(getCurrentProduct.productPrice) * value.quantity;
        total += getCurrentProduct.productPrice * value.quantity;
      }
    });
    return total;
  }

  //Get Total Price for payment screen
  double getTotalForPayment({required ProductsProvider productsProvider}) {
    var total = 0.0;

    _cartItems.forEach((key, value) {
      final getCurrentProduct = productsProvider.findByProdId(value.productId);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        // total += double.parse(getCurrentProduct.productPrice) * value.quantity;
        total += getCurrentProduct.productPrice * value.quantity;

        // total = total + fees;

        // total += 10;
        // print(total);
      }
    });
    return total + fees;
  }

  //Get Whole Quantity
  int getQty() {
    var total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void updateQty({
    required String productId,
    required int qty,
  }) {
    _cartItems.update(
        productId,
        (cartItem) => CartModel(
            productId: productId,
            cartId: cartItem.cartId,
            quantity: qty,
            color: 'Normal'));
    // _cartItems[productId]!.quantity++;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
