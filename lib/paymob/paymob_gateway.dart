import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadi_ecommerce_firebase_admin/paymob/constants.dart';

class PaymobManager {
  Dio dio = Dio();

  Future<String> payWithPayMob(int amount) async {
    try {
      //get token
      String token = await getToken();
      //get order id
      int orderId =
          await getOrderId(token: token, amount: (100 * amount).toString());
      //get payment key
      String paymentKey = await getPaymentKey(
          token: token, orderId: orderId.toString(), amount: amount.toString());
      //return payment key
      return paymentKey;
    } catch (e) {
      rethrow;
    }
  }

  //............First Function(Get Token)............
  Future<String> getToken() async {
    try {
      final response = await dio.post('$baseUrl/auth/tokens',
          data: ({"api_key": Constants.apiKey}));
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  //............Second Function(Get Order Id)............
  Future<int> getOrderId(
      {required String token, required String amount}) async {
    try {
      final response = await dio.post('$baseUrl/ecommerce/orders',
          data: ({
            "auth_token": token,
            "amount_cents": amount,
            "currency": "EGP",
            "delivery_needed": "true",
            "items": []
          }));
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  //............Third Function(Get Payment Key)............
  Future<String> getPaymentKey(
      {required String token,
      required String orderId,
      required String amount}) async {
    try {
      //get current logged user
      final auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      Response response = await dio.post('$baseUrl/acceptance/payment_keys',
          data: ({
            "auth_token": token, //1
            "amount_cents": amount, //2
            "currency": "EGP", //3
            "integration_id": 4594354, //4
            "expiration": 3600, //5
            "lock_order_when_paid": false, //6
            "order_id": orderId, //7
            "billing_data": {
              "apartment": "NA",
              "email": user!.email,
              "floor": "NA",
              "first_name": user.displayName,
              "street": "NA",
              "building": "NA",
              "phone_number": user.phoneNumber,
              "shipping_method": "NA",
            }
          }));
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  static const String baseUrl = 'https://accept.paymob.com/api';
  // static const String paymentKey = 'YOUR_PAYMENT_KEY';
  // static const String iframeId = 'YOUR_IFRAME_ID';
}
