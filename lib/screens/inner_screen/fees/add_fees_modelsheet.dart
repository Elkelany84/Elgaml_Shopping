import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/fees/fees_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddFeesBottomSheet extends StatefulWidget {
  const AddFeesBottomSheet({super.key});
  static const routeName = '/add_category_bottomSheet';

  @override
  State<AddFeesBottomSheet> createState() => _AddFeesBottomSheetState();
}

class _AddFeesBottomSheetState extends State<AddFeesBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _feesController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
  }

  Future<void> _uploadCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        //store picked image to firebase storage
        final categoryId = Uuid().v4();

        await FirebaseFirestore.instance
            .collection("orderFees")
            .doc(categoryId)
            .set({
          "placeId": categoryId,
          "placeName": _titleController.text.trim(),
          "fees": _feesController.text.trim(),
        });
        Navigator.pushReplacementNamed(
            context,
            FeesScreen
                .routeName); // await categoriesProvider.countCategories();
        //SToast Message
        Fluttertoast.showToast(
            msg: "تم إضافة المحافظة بنجاح !",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;

        // MyAppFunctions.showErrorOrWarningDialog(
        //     isError: false,
        //     context: context,
        //     subtitle: "Clear Form",
        //     fct: () {
        //       _clearForm();
        //     });
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subtitle: error.message.toString());
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subtitle: error.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(
      context,
    );
    Size size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: isLoading,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 300.0,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ), //Image Picker

                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "اسم المحافظة : ",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              key: ValueKey("Title"),
                              maxLength: 80,
                              maxLines: 1,
                              minLines: 1,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.newline,
                              decoration:
                                  InputDecoration(hintText: "اسم المحافظة"),
                              validator: (value) {
                                return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString:
                                        "اختر اسم صحيح للتصنيف");
                              },
                            ),
                            TextFormField(
                              controller: _feesController,
                              // key: ValueKey("Title"),
                              maxLength: 80,
                              maxLines: 1,
                              minLines: 1,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.newline,
                              decoration:
                                  InputDecoration(hintText: "سعر الشحن"),
                              validator: (value) {
                                return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString:
                                        "اختر اسم صحيح للتصنيف");
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  // textStyle: TextStyle(color: Colors.white),
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: () {
                                _uploadCategory();
                                // await categoriesProvider.countCategories();
                              },
                              child: const Text(
                                "اضف المحافظة",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
