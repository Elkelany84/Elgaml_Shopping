import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:provider/provider.dart';

class EditPricesScreen extends StatefulWidget {
  static const routeName = '/EditPriceScreen';

  const EditPricesScreen({
    super.key,
    // required this.categoryId,
  });

  // final String categoryId;

  @override
  State<EditPricesScreen> createState() => _EditPricesScreenState();
}

class _EditPricesScreenState extends State<EditPricesScreen> {
  TextEditingController incrementPriceController = TextEditingController();
  TextEditingController decrementPriceController = TextEditingController();
  bool _inIsLoading = true;
  bool _deIsLoading = true;
  @override
  void initState() {
    super.initState();
    // countCategories();
    // fetchFct();
  }

  @override
  void dispose() {
    incrementPriceController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<ProductModel> productList =
    //      categoriesProvider.categories
    //     : categoriesProvider.findByCategory(categoryName: passedCategory);
    final String categoryId;
    // final getCurrCategory =
    //     categoriesProvider.findByCategoryId(widget.categoryId);
    final productProvider = Provider.of<ProductsProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppNameTextWidget(label: "تعديــــل الأسعــــار"),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TitlesTextWidget(
                              label: ": زيادة جميع أسعار المنتجات بمقدار "),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: incrementPriceController,
                            key: ValueKey("Price \$"),
                            // maxLength: 5,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: " مقدار الزيادة بالجنيه ",
                              prefix: SubtitleTextWidget(
                                label: "\$",
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: _inIsLoading
                                ? ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        // textStyle: TextStyle(color: Colors.white),
                                        padding: const EdgeInsets.all(12),
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    onPressed: () async {
                                      setState(() {
                                        _inIsLoading = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                      await productProvider
                                          .incrementProductPrices(int.parse(
                                              incrementPriceController.text));

                                      Fluttertoast.showToast(
                                          backgroundColor: Colors.purple,
                                          msg:
                                              "تم زيادة جميع الأسعار بقيمة ${incrementPriceController.text} جنيه");
                                      setState(() {
                                        _inIsLoading = true;
                                      });
                                    },
                                    icon: const Icon(Icons.upload),
                                    label: const Text(
                                      "اضغط لإضافة المبلغ",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ))
                                : Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TitlesTextWidget(
                                        label: "انتظر من فضلك حتى يتم التحديث",
                                        color: Colors.purple,
                                      )
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Container(
                width: double.infinity,
                height: 200,
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TitlesTextWidget(
                              label: ": خفض جميع أسعار المنتجات بمقدار "),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: decrementPriceController,
                            key: ValueKey("Price \$"),
                            // maxLength: 5,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: " مقدار التخفيض بالجنيه ",
                              prefix: SubtitleTextWidget(
                                label: "\$",
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: _deIsLoading
                                ? ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        // textStyle: TextStyle(color: Colors.white),
                                        padding: const EdgeInsets.all(12),
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    onPressed: () async {
                                      setState(() {
                                        _deIsLoading = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                      await productProvider
                                          .decrementProductPrices(int.parse(
                                              decrementPriceController.text));

                                      Fluttertoast.showToast(
                                          backgroundColor: Colors.purple,
                                          msg:
                                              "تم تخفيض جميع الأسعار بقيمة ${decrementPriceController.text} جنيه");
                                      setState(() {
                                        _deIsLoading = true;
                                      });
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text(
                                      "اضغط لخفض المبلغ",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ))
                                : Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TitlesTextWidget(
                                        label: "انتظر من فضلك حتى يتم التحديث",
                                        color: Colors.purple,
                                      )
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // label: "All Categories ( $quer )"),
      ),
    );
  }
}
