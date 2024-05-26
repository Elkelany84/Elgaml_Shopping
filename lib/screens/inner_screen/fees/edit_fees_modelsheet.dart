import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:image_picker/image_picker.dart';

class EditFeesBottomSheet extends StatefulWidget {
  EditFeesBottomSheet({
    super.key,
    this.categoryModel,
    required this.placeName,
    required this.placeId,
  });
  static const routeName = '/edit_fees_bottomSheet';
  final CategoryModel? categoryModel;
  final String? placeId;
  final String? placeName;

  @override
  State<EditFeesBottomSheet> createState() => _EditCategoryBottomSheetState();
}

class _EditCategoryBottomSheetState extends State<EditFeesBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isLoading = false;
  bool isEditing = true;
  late TextEditingController _titleController;

  // String? productNetworkImage;
  // late String productImageUrl;

  @override
  void initState() {
    if (widget.categoryModel != null) {
      // isEditing = true;
      // widget.productNetworkImage = widget.categoryModel!.categoryImage;
    }
    isEditing = true;

    // _titleController = TextEditingController(
    //     text: widget.categoryModel == null
    //         ? ""
    //         : widget.categoryModel!.categoryName);
    _titleController = TextEditingController(text: widget.placeName);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
  }

  Future<void> _editCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        // final productId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection("orderFees")
            .doc(widget.placeId)
            .update({
          "placeId": widget.placeId,
          "placeName": _titleController.text.trim(),
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "تم التعديل بنجاح",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        Navigator.pop(context);
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
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: LoadingManager(
        isLoading: isLoading,
        child: Container(
          // height: 435.0,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                      ), //Image Picker
                      //Image Picker

                      // else if (_pickedImage == null) ...[
                      //   Center(
                      //     child: SizedBox(
                      //       width: size.width * 0.4 + 10,
                      //       height: size.width * 0.4,
                      //       child: DottedBorder(
                      //         child: Center(
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 Icons.image_outlined,
                      //                 size: 80,
                      //                 color: Colors.blue,
                      //               ),
                      //               TextButton(
                      //                 onPressed: () {
                      //                   localImagePicker();
                      //                 },
                      //                 child: Text("Pick Category Image"),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                      // ]

                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "إسم المحافظة : ",
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
                        child: TextFormField(
                          controller: _titleController,
                          key: ValueKey("Title"),
                          maxLength: 80,
                          maxLines: 1,
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(hintText: "إسم المحافظة"),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                                value: value,
                                toBeReturnedString: "ادخل اسم محافظة صحيحة");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
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
                                  _editCategory();
                                },
                                child: const Text(
                                  "تعديل المحافظة",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )),
                          ),
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
