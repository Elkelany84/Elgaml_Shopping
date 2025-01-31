import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/models/wishlist_model.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/login_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class WishlistProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishlistItems = {};

  Map<String, WishListModel> get wishlistItems => _wishlistItems;

  final auth = FirebaseAuth.instance;
  final usersDb = FirebaseFirestore.instance.collection("users");

  //add products to wishlist firebase
  Future<void> addToWishListFirebase(
      {required String productId, required BuildContext context}) async {
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
      return;
      // Navigator.pushNamed(context, LoginScreen.routeName);
    }
    final uid = user.uid;
    final wishListId = uuid.v4();
    try {
      addOrRemoveFromWishlist(productId: productId);
      await usersDb.doc(uid).update({
        "userWish": FieldValue.arrayUnion([
          {
            "wishListId": wishListId,
            "productId": productId,
          }
        ]),
      });
      await Fluttertoast.showToast(msg: "تم الإضافة للمفضلة");
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  //delete product from wishlist in firebase
  Future<void> deleteProductFromWishListFirebase(
      {required String wishListId,
      required String productId,
      required BuildContext context}) async {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    try {
      await _wishlistItems.remove(productId);
      await usersDb.doc(uid).update({
        "userWish": FieldValue.arrayRemove([
          {
            "wishListId": wishListId,
            "productId": productId,
          }
        ]),
      });

      await Fluttertoast.showToast(msg: "تم المسح من المفضلة");
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  //Get WishList Items From Firebase
  Future<void> getWishListItemsFromFirebase() async {
    final User? user = auth.currentUser;
    if (user == null) {
      wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await usersDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final length = userDoc.get("userWish").length;
      for (int index = 0; index < length; index++) {
        await _wishlistItems.putIfAbsent(
            userDoc.get("userWish")[index]["productId"],
            () => WishListModel(
                  productId: userDoc.get("userWish")[index]["productId"],
                  wishListId: userDoc.get("userWish")[index]["wishListId"],
                ));
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  //clear the whole wishlist from firebase
  Future<void> clearCartFirebase() async {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    try {
      await usersDb.doc(uid).update({
        "userWish": [],
      });
      //get the cart items from firebase and show it in cart screen
      await getWishListItemsFromFirebase();
      clearWishlist();
      Fluttertoast.showToast(msg: "تم مسح المفضلة");
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

/////////LOCAL
  // Add the product to the cart
  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(
          productId,
          () => WishListModel(
                wishListId: uuid.v4(),
                productId: productId,
              ));
    }

    // Notify listeners that the cart has changed
    notifyListeners();
  }

  //Check if The Product is in the cart
  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
