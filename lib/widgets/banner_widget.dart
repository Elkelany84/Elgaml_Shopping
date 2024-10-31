import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/banners_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';

class banner_widget extends StatelessWidget {
  const banner_widget({
    super.key,
    required this.bannersProvider,
    // required this.categoryId,
  });

  final BannersProvider bannersProvider;
  // final String categoryId;

  @override
  Widget build(BuildContext context) {
    // final getCurrCategory = categoriesProvider.findByCategoryId(categoryId);
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      // Step 2: Create a Stream
      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
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
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, SearchScreen.routeName,
                      //     arguments: document['bannerName']);
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all()),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FancyShimmerImage(
                                  imageUrl: document['bannerImage'],
                                  height: 300,
                                  width: screenWidth / 2,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // Text(
                              //   document['bannerName'],
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              Spacer(),
                              // IconButton(
                              //   onPressed: () {
                              //     showModalBottomSheet(
                              //         isScrollControlled: true,
                              //         context: context,
                              //         builder: (builder) {
                              //           return Padding(
                              //             padding: EdgeInsets.only(
                              //                 bottom: MediaQuery.of(context)
                              //                     .viewInsets
                              //                     .bottom),
                              //             child: EditCategoryBottomSheet(
                              //               categoryId: document['categoryId'],
                              //               categoryName:
                              //                   document['categoryName'],
                              //               categoryImage:
                              //                   document['categoryImage'],
                              //               createdAt: document['createdAt'],
                              //               // categoryModel: getCurrCategory,
                              //             ),
                              //           );
                              //         });
                              //     // categoriesProvider
                              //     //     .deleteCategory(document.id);
                              //   },
                              //   icon: Icon(
                              //     Icons.edit,
                              //     color: Colors.purpleAccent,
                              //     size: 30,
                              //   ),
                              // ),
                              //create icon to delete category from firebase
                              IconButton(
                                onPressed: () {
                                  MyAppFunctions.showErrorOrWarningDialog(
                                      isError: false,
                                      context: context,
                                      subtitle: "مسح الإعلان",
                                      fct: () async {
                                        await bannersProvider
                                            .deleteBanner(document.id);
                                        await bannersProvider.countBanners();
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
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
