import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/product_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class EditOrUploadProductForm extends StatefulWidget {
  const EditOrUploadProductForm({super.key, this.productModel});
  static const routeName = '/edit-or-upload-product-form';
  final ProductModel? productModel;
  @override
  State<EditOrUploadProductForm> createState() =>
      _EditOrUploadProductFormState();
}

class _EditOrUploadProductFormState extends State<EditOrUploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  bool isLoading = false;
  String? productImageUrl;

  //get product images from firebase
  List<String> productImages = [];
  Future<List<String>> getProductImages(String productId) async {
    final productDb =
        FirebaseFirestore.instance.collection("products").doc(productId);
    await productDb.get().then((productSnapshot) {
      for (var element in productSnapshot.get("imageFileList")) {
        productImages.add(element);
      }
    });
    print("productImages: ${productImages.length}");
    setState(() {});
    return productImages;
  }

  //create function to delete images list from firebase
  Future<void> deleteProductImages(String productId) async {
    final productDb =
        FirebaseFirestore.instance.collection("products").doc(productId);
    await productDb.update({
      "imageFileList": [],
    });
  }

  @override
  void initState() {
    if (widget.productModel != null) {
      _categoryValue = widget.productModel!.productCategory;
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      getProductImages(widget.productModel!.productId);
      // imageFileListString = widget.productModel!.imageFileListString;
    }
    _titleController = TextEditingController(
        text: widget.productModel == null
            ? ""
            : widget.productModel!.productTitle);
    _priceController = TextEditingController(
        text: widget.productModel == null
            ? ""
            : widget.productModel!.productPrice.toString());
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController = TextEditingController(
        text: widget.productModel == null
            ? ""
            : widget.productModel!.productQuantity);
    // getColorValue('CKle6aKVL73Xm3qtB814', 4279437290);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    // removePickedImage();
    _clearPickedImage();
  }

  void _clearPickedImage() {
    _pickedImage = null;
    productNetworkImage = null;
    imageFileList.clear();
    setState(() {});
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
      imageFileList.clear();
      imageFileListString!.clear();
      try {
        deleteProductImages(widget.productModel!.productId);
      } catch (e) {}
    });
  }

  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
//check if he choose image or not
    if (_pickedImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, fct: () {}, subtitle: "اختر صورة للمنتج");
      return;
    }
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        //store picked image to firebase storage
        final productId = Uuid().v4();
        final ref = FirebaseStorage.instance.ref();
        final imageRef = ref.child("productsImages").child('$productId.png');
        await imageRef.putFile(File(_pickedImage!.path));
        final imageUrl = await imageRef.getDownloadURL();

        //store every image in imageFileList in firestore storage
        // String imageUrlFinal = "";
        // final productId = Uuid().v4();   //remove comments if you comment the same variables above138
        for (var image in imageFileList) {
          final ref = FirebaseStorage.instance.ref();
          final imageRef =
              ref.child("productsImages").child('${Uuid().v4()}.png');
          await imageRef.putFile(File(image.path));
          final imageUrl = await imageRef.getDownloadURL();
          // imageFileList.add(imageUrl);
          imageFileListString!.add(imageUrl);
          // imageUrlFinal = imageUrl;
        }

        //store product in firestore

        await FirebaseFirestore.instance
            .collection("products")
            .doc(productId)
            .set({
          "productId": productId,
          "productTitle": _titleController.text.trim(),
          "productCategory": _categoryValue,
          "productPrice": int.parse(_priceController.text),
          "productDescription": _descriptionController.text,
          // "productImage": imageUrl,
          "productImage": imageUrl ?? imageFileListString![0],
          "imageFileList": imageFileListString,
          "createdAt": Timestamp.now(),
          "productQuantity": _quantityController.text,
          // "colorsMap": {},
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "تمت إضافة المنتج بنجاح!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        MyAppFunctions.showErrorOrWarningDialog(
            isError: false,
            context: context,
            subtitle: "مسح الخلايا",
            fct: () {
              _clearForm();
            });
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

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
//check if he choose image or not
    if (_pickedImage == null && productNetworkImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, subtitle: "اختر صورة للمنتج", fct: () {});
      return;
    }
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        //store picked image to firebase storage
        // if (_pickedImage != null) {
        //   final ref = FirebaseStorage.instance.ref();
        //   final imageRef = ref
        //       .child("productsImages")
        //       .child('${widget.productModel!.productId}.png');
        //   await imageRef.putFile(File(_pickedImage!.path));
        //   productImageUrl = await imageRef.getDownloadURL();
        // }
//the camera one image
        //store picked image to firebase storage
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance.ref();
          final imageRef = ref
              .child("productsImages")
              .child('${widget.productModel!.productId}.png');
          await imageRef.putFile(File(_pickedImage!.path));
          productImageUrl = await imageRef.getDownloadURL();
        }

//add picked images to firestorage
        for (var image in imageFileList) {
          final ref = FirebaseStorage.instance.ref();
          final imageRef =
              ref.child("productsImages").child('${Uuid().v4()}.png');
          await imageRef.putFile(File(image.path));
          final imageUrl = await imageRef.getDownloadURL();
          // imageFileList.add(imageUrl);
          imageFileListString!.add(imageUrl);
          // imageUrlFinal = imageUrl;
        }

        // final productId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection("products")
            .doc(widget.productModel!.productId)
            .update({
          "productId": widget.productModel!.productId,
          "productTitle": _titleController.text.trim(),
          "productCategory": _categoryValue,
          "productBeforeDiscount": "",
          "productPrice": int.parse(_priceController.text),
          "productDescription": _descriptionController.text,
          // "productImage": productImageUrl ?? productNetworkImage,
          "productImage":
              productImageUrl ?? productNetworkImage ?? imageFileListString![0],
          "imageFileList": imageFileListString,
          "createdAt": widget.productModel!.createdAt,
          "productQuantity": _quantityController.text,
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "تم تعديل المنتج بنجاح !",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        MyAppFunctions.showErrorOrWarningDialog(
            isError: false,
            context: context,
            subtitle: "مسح الخلايا",
            fct: () {
              _clearForm();
            });
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

  Future<void> localImagePicker() async {
    final picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
        context: context,
        cameraFCT: () async {
          _pickedImage = await picker.pickImage(
              source: ImageSource.camera,
              maxHeight: 480,
              maxWidth: 640,
              imageQuality: 50);
          setState(() {
            productNetworkImage = null;
          });
        },
        galleryFCT: () async {
          _pickedImage = await picker.pickImage(
              source: ImageSource.gallery,
              maxHeight: 480,
              maxWidth: 640,
              imageQuality: 50);
          setState(() {
            productNetworkImage = null;
          });
        },
        removeFCT: () async {
          setState(() {
            _pickedImage = null;
          });
        });
  }

  //create function to select multiple images
  final ImagePicker _picker = ImagePicker();
  List<XFile> imageFileList = [];
  List<dynamic>? imageFileListString = [];
  Future<void> localMultipleImagePicker() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage(
        maxHeight: 480, maxWidth: 640, imageQuality: 50);
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
      _pickedImage = imageFileList[0];
      print("imageFileList: ${imageFileList.length}");
      print("imageFileListString: ${imageFileListString!.length}");
    }
    setState(() {});
  }

  Future<void> localMultipleImagePickerCameraGallery() async {
    MyAppFunctions.multiImagePickerDialog(
        context: context,
        cameraFCT: () async {
          _pickedImage = await _picker.pickImage(
              source: ImageSource.camera,
              maxHeight: 480,
              maxWidth: 640,
              imageQuality: 50);
          setState(() {
            productNetworkImage = null;
          });
        },
        galleryFCT: () async {
          final List<XFile>? selectedImages = await _picker.pickMultiImage(
              maxHeight: 480, maxWidth: 640, imageQuality: 50);
          if (selectedImages!.isNotEmpty) {
            imageFileList.addAll(selectedImages);
            _pickedImage = imageFileList[0];
            print("imageFileList: ${imageFileList.length}");
            print("imageFileListString: ${imageFileListString!.length}");
          }
          setState(() {});
        },
        removeFCT: () async {
          setState(() {
            _pickedImage = null;
          });
        });
  }

  // int currentColor = 0;
  // final List<Color> colorSelected = [
  //   kCOlor1,
  //   kCOlor2,
  //   kCOlor3,
  //   kCOlor4,
  //   kCOlor5,
  // ];
  bool isChecked1 = false; //Blue
  bool isChecked2 = false; //Golden
  bool isChecked3 = false; //Red
  bool isChecked4 = false; //Yellow
  bool isChecked5 = false; //Black
  bool isChecked6 = false; //Green
  bool isChecked7 = false; //Silver
  int color1 = 0; //Blue
  int color2 = 0; //Golden
  int color3 = 0; //Red
  int color4 = 0; //Yellow
  int color5 = 0; //Black
  int color6 = 0; //Green

  int color7 = 0; //Silver
  // List<int> colorsProducts = [];
  //futurebuilder
  // getColorValue(String docId, String colorKey) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   DocumentSnapshot documentSnapshot =
  //       await firestore.collection('newProducts').doc(docId).get();
  //   Map<String, dynamic> colorsMap = documentSnapshot['colorsmap'];
  //   print(colorsMap);
  //   return colorsMap[colorKey];
  // }

  //streambuilder

  Stream<dynamic> getColorStream(String docId, String colorKey) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('products')
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      return snapshot.data()?['colorsMap'][colorKey];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final categoryProvider = Provider.of<CategoriesProvider>(context);
    // final productsProvider = Provider.of<ProductsProvider>(
    //   context,
    // );

    // List<int> uniqueProductList = [];
    // Future<List> returnedList = categoryProvider.getProductList();
    // returnedList.then((value) {
    //   // print(value);
    // });
    // void addNonZeroValues() {
    //   color1 != 0 ? uniqueProductList.add(color1) : null;
    //   color2 != 0 ? uniqueProductList.add(color2) : null;
    //   // print(uniqueProductList);
    // }

    return LoadingManager(
      isLoading: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            // backgroundColor: Colors.white.withOpacity(0.70),
            // floatingActionButton: FloatingActionButton(onPressed: () async {
            //   categoryProvider.addColorsMapToProducts();
            //   // categoryProvider.addColorsFieldToProducts();
            //   //test the colors feature
            //   // categoryProvider.getProductList();
            //   // print(returnedList);
            //   // getColorValue('CKle6aKVL73Xm3qtB814', "4279437290");
            //   // addNonZeroValues();
            //   // await FirebaseFirestore.instance
            //   //     .collection("newProducts")
            //   //     .doc('CKle6aKVL73Xm3qtB814')
            //   //     .update(
            //   //         {'colorsmap.$color1': isChecked1, 'colorsmap.red': 20});
            // }),
            resizeToAvoidBottomInset: true,
            bottomSheet: SizedBox(
              height: kBottomNavigationBarHeight + 10,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        _clearForm();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text(
                        "مسح",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          // textStyle: TextStyle(color: Colors.white),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        if (isEditing) {
                          categoryProvider.fetchCategoryStream();
                          _editProduct();
                        } else {
                          _uploadProduct();
                          // imageFileList.clear();
                          imageFileListString!.clear();
                        }
                      },
                      icon: const Icon(Icons.upload),
                      label: isEditing
                          ? const Text(
                              "تعديل المنتج",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          : Text(
                              "إضافة منتج",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: AppNameTextWidget(
                label: isEditing ? "تعديل المنتج" : "إضافة منتج جديد",
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),

                  //Image Picker
                  if (isEditing &&
                      productNetworkImage != null &&
                      productImages.isNotEmpty) ...[
                    Column(
                      children: [
                        Visibility(
                          visible: productImages.length == 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FancyShimmerImage(
                              imageUrl: productNetworkImage!,
                              height: size.width * 0.3,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: productImages.length > 1,
                          child: SizedBox(
                            height: 130,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GridView.builder(
                                itemCount: productImages.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: ClipRRect(
                                      child: FancyShimmerImage(
                                        imageUrl: (productImages[index]),
                                        height: 60,
                                        width: 40,
                                        boxFit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ] else if (isEditing &&
                      productNetworkImage != null &&
                      productImages.isEmpty &&
                      imageFileList.isEmpty) ...[
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FancyShimmerImage(
                            imageUrl: productNetworkImage!,
                            height: size.width * 0.4,
                            alignment: Alignment.center,
                          ),
                        ),
                        // SizedBox(
                        //   height: 80,
                        //   width: 250,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: GridView.builder(
                        //       itemCount: productImages.length,
                        //       itemBuilder: (BuildContext context, index) {
                        //         return Padding(
                        //           padding: const EdgeInsets.only(right: 8.0),
                        //           child: Image.network(
                        //             (productImages[index]),
                        //             height: 30,
                        //             width: 30,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         );
                        //       },
                        //       gridDelegate:
                        //           SliverGridDelegateWithFixedCrossAxisCount(
                        //               crossAxisCount: 3),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ] else if (_pickedImage == null) ...[
                    SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: GestureDetector(
                        onTap: () {
                          // localImagePicker();
                          localMultipleImagePickerCameraGallery();
                        },
                        child: DottedBorder(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // localImagePicker();
                                    localMultipleImagePickerCameraGallery();
                                  },
                                  child: Text("اختر صورة للمنتج"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ] else ...[
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(
                              _pickedImage!.path,
                            ),
                            height: size.width * 0.25,
                            // width: size.width * 0.5,
                            alignment: Alignment.center,
                          ),
                        ),
                        Visibility(
                          visible: imageFileList.isNotEmpty,
                          child: SizedBox(
                            height: 140,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                itemCount: imageFileList.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8),
                                    child: Image.file(
                                      File(imageFileList[index].path),
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                  _pickedImage != null || productNetworkImage != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                // localImagePicker();
                                localMultipleImagePickerCameraGallery();
                              },
                              child: Text("اختر صورة آخرى"),
                            ),
                            TextButton(
                              onPressed: () {
                                removePickedImage();
                              },
                              child: Text(
                                "امسح الصورة",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                  //DropDown Widget
                  // DropdownButton(
                  //     // items: AppConstants.catList,
                  //     items: AppConstants.categoriesDropDownList,
                  //     value: _categoryValue,
                  //     hint: Text("Choose a Category"),
                  //     onChanged: (String? value) {
                  //       setState(() {
                  //         _categoryValue = value;
                  //       });
                  //     }),

                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12, left: 12),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          List<DropdownMenuItem> categoryItems = [];
                          for (var doc in snapshot.data!.docs) {
                            categoryItems.add(
                              DropdownMenuItem(
                                child: Text(doc['categoryName']),
                                value: doc['categoryName'],
                              ),
                            );
                          }

                          return DropdownButtonFormField(
                            hint: Text('اختر التصنيف'),
                            value: _categoryValue,
                            items: categoryItems,
                            onChanged: (newValue) {
                              setState(() {
                                _categoryValue = newValue;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              key: ValueKey("Title"),
                              maxLength: 80,
                              maxLines: 2,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration:
                                  InputDecoration(hintText: "اسم المنتج"),
                              validator: (value) {
                                return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString: "اختر اسم صحيح للمنتج");
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _priceController,
                                    key: ValueKey("Price \$"),
                                    maxLength: 5,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "السعر",
                                      prefix: SubtitleTextWidget(
                                        label: "\$",
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                    validator: (value) {
                                      return MyValidators.uploadProdTexts(
                                          value: value,
                                          toBeReturnedString: "السعر مفقود");
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _quantityController,
                                    key: ValueKey("Quantity"),
                                    maxLength: 5,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]"),
                                      )
                                    ],
                                    decoration:
                                        InputDecoration(hintText: "الكمية"),
                                    validator: (value) {
                                      return MyValidators.uploadProdTexts(
                                          value: value,
                                          toBeReturnedString: "الكمية مفقودة");
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextFormField(
                                controller: _descriptionController,
                                key: ValueKey("Description"),
                                maxLength: 500,
                                maxLines: 5,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration:
                                    InputDecoration(hintText: "وصف المنتج"),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                      value: value,
                                      toBeReturnedString: "الوصف مفقود");
                                },
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Visibility(
                              visible: isEditing,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    // CheckBoxWidget(),
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "4279437290"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor: Colors.blue,
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked1,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.4279437290':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');
                                                        print(
                                                            "$isChecked1 + $color1");
                                                      });
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked1);
                                                      print(color1);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return Text('no blue');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? SubtitleTextWidget(
                                            label: "أزرق",
                                            color: Colors.blue,
                                            fontSize: 14,
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "0xffad9c00"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor:
                                                        Color(0xffad9c00),
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked2,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.0xffad9c00':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');
                                                        print(
                                                            "$isChecked2 + $color2");
                                                      });
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked1);
                                                      print(color1);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return Text('gfhgfhgfhgfh');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? SubtitleTextWidget(
                                            label: "ذهبى",
                                            color: Color(0xffad9c00),
                                            fontSize: 14,
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "0xFFEA1C07"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor: Colors.red,
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked3,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.0xFFEA1C07':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');
                                                        print(
                                                            "$isChecked2 + $color2");
                                                      });
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked1);
                                                      print(color1);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return SubtitleTextWidget(
                                                  label: 'لا يوجد ألوان');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? SubtitleTextWidget(
                                            label: "أحمر",
                                            color: Colors.red,
                                            fontSize: 14,
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "0xFFC3EA07"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor: Colors.yellow,
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked4,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.0xFFC3EA07':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');
                                                        print(
                                                            "$isChecked4 + $color4");
                                                      });
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked4);
                                                      print(color4);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return Text('gfhgfhgfhgfh');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? SubtitleTextWidget(
                                            label: "أصفر",
                                            color: Colors.yellow[700],
                                            fontSize: 14,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isEditing,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "0xFF0A0707"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor: Colors.black,
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked4,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.0xFF0A0707':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');
                                                        print(
                                                            "$isChecked5+ $color5");
                                                      });
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked5);
                                                      print(color5);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return Text('aa');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.white,
                                            highlightColor: Colors.black,
                                            period: const Duration(seconds: 4),
                                            child: SubtitleTextWidget(
                                              label: "أسود",
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          )
                                        : Container(),
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "0xFF0ED422"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor: Colors.green,
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked5,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.0xFF0ED422':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');
                                                        print(
                                                            "$isChecked6 + $color6");
                                                      });
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked6);
                                                      print(color6);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return Text('aa');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? SubtitleTextWidget(
                                            label: "أخضر",
                                            color: Colors.green,
                                            fontSize: 14,
                                          )
                                        : Container(),
                                    isEditing
                                        ? StreamBuilder<dynamic>(
                                            stream: getColorStream(
                                                widget.productModel!.productId,
                                                "0xFFC0C0C0"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('hhh');
                                              }
                                              if (snapshot.hasData) {
                                                dynamic colorValue =
                                                    snapshot.data;
                                                return Checkbox(
                                                    activeColor: Colors.black,
                                                    value: colorValue == true
                                                        ? colorValue
                                                        : isChecked7,
                                                    onChanged: (value) {
                                                      setState(() async {
                                                        colorValue = value!;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "products")
                                                            .doc(
                                                              widget
                                                                  .productModel!
                                                                  .productId,
                                                            )
                                                            .update({
                                                          'colorsMap.0xFFC0C0C0':
                                                              colorValue,
                                                        });
                                                        // color1 = isChecked1 == true
                                                        //     ? 0xFF1307EA
                                                        //     : 0;
                                                        // color1 != 0
                                                        //     ? colorsProducts.add(color1)
                                                        //     : null;

                                                        // uniqueProductList =
                                                        //     colorsProducts.toSet().toList();
                                                        // colorsProducts.remove(color1);
                                                        // print('aftereffect: $colorsProducts');

                                                        print(
                                                            "$isChecked7 + $color7");
                                                      });
                                                      // isChecked7
                                                      //     ? Fluttertoast.showToast(
                                                      //         msg:
                                                      //             "تم اختيار اللون الفضى")
                                                      //     : null;
                                                      // colorsProducts.toSet().toList();

                                                      print(isChecked7);
                                                      print(color7);
                                                      // print(colorsProducts);
                                                    });
                                                // Center(
                                                //   child:
                                                //       Text('Color value: $colorValue'));
                                              }
                                              return Text('aa');
                                            },
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    isEditing
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.white54,
                                            highlightColor: Colors.black,
                                            period: const Duration(seconds: 4),
                                            child: SubtitleTextWidget(
                                              label: "فضــى",
                                              color: Colors.white54,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                            // Container(
                            //   height: 50,
                            //   width: 200,
                            //   padding: EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //       color: Colors.black.withOpacity(0.3),
                            //       borderRadius: BorderRadius.circular(30)),
                            //   child: ListView.separated(
                            //       scrollDirection: Axis.horizontal,
                            //       itemBuilder: (context, index) {
                            //         return GestureDetector(
                            //           onTap: () {
                            //             setState(() {
                            //               currentColor = index;
                            //               print(currentColor);
                            //             });
                            //           },
                            //           child: ColorPicker(
                            //               outerBorder: currentColor == index,
                            //               color: colorSelected[index]),
                            //         );
                            //       },
                            //       separatorBuilder: (context, index) {
                            //         return SizedBox(
                            //           height: 3,
                            //         );
                            //       },
                            //       itemCount: colorSelected.length),
                            // ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
