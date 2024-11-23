import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderStreamScreen extends StatelessWidget {
  OrderStreamScreen({
    super.key,
    this.docName,
    this.userId,
  });
  // final String arrayField1Name; // The name of the first array field
  // final String arrayField2Name; // The name of the second array field
  // final dynamic matchingValue;
  static const routeName = "/orderStreamScreen";
  final String? docName;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    void sendWhatsapp(String phoneNumber, String orderId) {
      // "+20$"; // Replace with the desired phone number
      String message =
          "ElgamlStore يرحب بكم \n رقم $orderIdبخصوص طلبيتكم "; // Replace with the desired message

      String url =
          "https://wa.me/+2$phoneNumber?text=${Uri.encodeFull(message)}";
      launchUrl(Uri.parse(url));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: AppNameTextWidget(label: "تفاصيل الطلبية"),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (!snapshot.hasData) {
                        return Text('No data found');
                      }
                      var document = snapshot.data!;
                      // var arrayData =
                      //     document['userOrder'] as List<dynamic>? ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8, left: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, right: 8, left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TitlesTextWidget(label: "اسم المستخدم: "),
                                    Expanded(
                                      child: SubtitleTextWidget(
                                          label: "${document['userName']}"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitlesTextWidget(label: "العنوان: "),
                                    SubtitleTextWidget(
                                      label: "${document['userAddress']}",
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    TitlesTextWidget(label: "التليفون: "),
                                    SubtitleTextWidget(
                                        label: "${document['userPhone']}"),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () async {
                                          final Uri url = Uri(
                                              scheme: "tel",
                                              path: document['userPhone']);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            print("can not launch");
                                          }
                                        },
                                        icon: Icon(
                                          Icons.call,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          sendWhatsapp(
                                              document['userPhone'], docName!);
                                        },
                                        icon: Icon(
                                          Icons.message_outlined,
                                          color: Colors.green,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
            Expanded(
              flex: 8,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ordersAdvanced')
                    .doc(docName)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (!snapshot.hasData) {
                        return Text('No data found');
                      }
                      var document = snapshot.data!;
                      var arrayData =
                          document['userOrder'] as List<dynamic>? ?? [];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TitlesTextWidget(label: "رقم الطلبية: "),
                                    Expanded(
                                      child: SubtitleTextWidget(
                                          label: "${document['sessionId']}"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    TitlesTextWidget(label: "حالة الطلبية: "),
                                    SubtitleTextWidget(
                                        label: "${document['orderStatus']}"),
                                    Spacer(),
                                    // SizedBox(
                                    //   height: kBottomNavigationBarHeight - 10,
                                    //   width: kBottomNavigationBarHeight + 60,
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //       padding: const EdgeInsets.all(12),
                                    //       backgroundColor: Colors.purpleAccent,
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //       ),
                                    //     ),
                                    //     onPressed: () {
                                    //       FirebaseFirestore.instance
                                    //           .collection('ordersAdvanced')
                                    //           .doc(docName)
                                    //           .update({
                                    //         'orderStatus': 'Completed',
                                    //       });
                                    //       Navigator.pop(context);
                                    //     },
                                    //     child: const Text(
                                    //       "Completed",
                                    //       style: TextStyle(fontSize: 18),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: arrayData.length,
                                    itemBuilder: (context, index) {
                                      var item = arrayData[index];
                                      // Assuming each item in the array is a Map
                                      var itemName = item['productTitle'];
                                      var itemPrice = item['price'].toString();
                                      var itemImage = item['imageUrl'];
                                      var itemQty = item['quantity'];
                                      return Container(
                                        padding: EdgeInsets.only(top: 7),
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child:
                                            // Image.network(itemImage),
                                            ListTile(
                                          leading: SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: ClipRRect(
                                              child: FancyShimmerImage(
                                                imageUrl: itemImage,
                                                height: 80,
                                                width: 60,
                                              ),
                                            ),
                                          ),
                                          title: Row(
                                            children: [
                                              TitlesTextWidget(
                                                label: itemName,
                                                fontSize: 16,
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TitlesTextWidget(
                                                label: "$itemPrice جنيه ",
                                                color: Colors.blue,
                                              ),
                                              SubtitleTextWidget(
                                                label: "الكمية: $itemQty",
                                                color: Colors.blue,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// // StreamBuilder(
// //   stream:
// //       FirebaseFirestore.instance.collection("ordersAdvanced").snapshots(),
// //   builder: (context, snapshot) {
// //     if (snapshot.hasData) {
// //       return ListView.builder(
// //         itemCount: snapshot.data!.docs.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(snapshot.data!.docs[index]["sessionId"]),
// //             subtitle: Text(snapshot.data!.docs[index]["userId"]),
// //           );
// //         },
// //       );
// //     } else {
// //       return Center(
// //         child: CircularProgressIndicator(),
// //       );
// //     }
// //   },
// // ),
//
// //     //streambuilder to show subfields in array in firebase
// //     StreamBuilder(
// //   stream:
// //       FirebaseFirestore.instance.collection('ordersAdvanced').snapshots(),
// //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //     if (snapshot.hasError) {
// //       return Text('Error: ${snapshot.error}');
// //     }
// //     switch (snapshot.connectionState) {
// //       case ConnectionState.waiting:
// //         return Text('Loading...');
// //       default:
// //         return ListView(
// //             children:
// //                 snapshot.data!.docs.map((DocumentSnapshot document) {
// //           Map<String, dynamic> data =
// //               document.data() as Map<String, dynamic>;
// //           // Accessing the array field 'items'
// //           List<dynamic> items = data['orderSummary'] as List<dynamic>;
// //           return ExpansionTile(
// //             title: Text('Order ID: ${document.id}'),
// //             // title: Text(snapshot.data.docs),
// //             children: items.map((item) {
// //               // Assuming each item in the array is a map with 'name' and 'quantity'
// //               return ListTile(
// //                 title: Text(item['orderStatus']),
// //                 subtitle: Text('Status: ${item['orderStatus']}'),
// //               );
// //             }).toList(),
// //           );
// //         }).toList());
// //     }
// //   },
// // ),
