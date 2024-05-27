import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/fees/edit_fees_modelsheet.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';

class Fees_widget extends StatelessWidget {
  const Fees_widget({
    super.key,
    required this.categoriesProvider,
    // required this.categoryId,
  });

  final CategoriesProvider categoriesProvider;
  // final String categoryId;

  @override
  Widget build(BuildContext context) {
    // final getCurrCategory = categoriesProvider.findByCategoryId(categoryId);

    return StreamBuilder<QuerySnapshot>(
      // Step 2: Create a Stream
      stream: FirebaseFirestore.instance.collection('orderFees').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            // Step 3: Build UI based on the stream
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all()),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              document['fees'].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(" ــــ "),
                            Text(
                              document['placeName'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),

                            Spacer(),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (builder) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: EditFeesBottomSheet(
                                          placeId: document['placeId'],
                                          placeName: document['placeName'],
                                          fees: document["fees"].toString(),

                                          // categoryModel: getCurrCategory,
                                        ),
                                      );
                                    });
                                // categoriesProvider
                                //     .deleteCategory(document.id);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.purpleAccent,
                                size: 30,
                              ),
                            ),
                            //create icon to delete category from firebase
                            IconButton(
                              onPressed: () {
                                MyAppFunctions.showErrorOrWarningDialog(
                                    isError: false,
                                    context: context,
                                    subtitle: "مسح المحافظة",
                                    fct: () async {
                                      await categoriesProvider
                                          .deletePlace(document.id);
                                    });
                                // categoriesProvider
                                //     .deleteCategory(document.id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
