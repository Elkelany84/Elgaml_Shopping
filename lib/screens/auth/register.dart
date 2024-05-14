import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/validator.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/login_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/root_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/auth/google_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String routeName = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscureText = true;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;
  late TextEditingController _phoneController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _repeatPasswordFocusNode;
  late final FocusNode _phoneFocusNode;
  final _formKey = GlobalKey<FormState>();
  // XFile? pickedImage;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _phoneController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
//check if he choose image or not
//     if (pickedImage == null) {
//       MyAppFunctions.showErrorOrWarningDialog(
//           context: context, fct: () {}, subTitle: "Please Choose an Image");
//       return;
//     }
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        await auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        final User user = auth.currentUser!;
        final String uid = user.uid;

        //store picked image to firebase storage
        // final ref = FirebaseStorage.instance.ref();
        // final imageRef =
        //     ref.child("usersImages").child(auth.currentUser!.uid + ".jpg");
        // await imageRef.putFile(File(pickedImage!.path));
        // final imageUrl = await imageRef.getDownloadURL();

        //Register user in FirebaseFirestore
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "userId": uid,
          "userName": _nameController.text.trim(),
          "userEmail": _emailController.text.trim().toLowerCase(),
          "userImage": "",
          "createdAt": Timestamp.now(),
          "userAddress": "",
          "userPhone": _phoneController.text,
          "userCart": [],
          "userWish": [],
          "orderSummary": [],
        });

        //Customize create userOrderProfile in orderAdvanced in FirebaseFirestore
        // await FirebaseFirestore.instance
        //     .collection("ordersAdvanced")
        //     .doc(uid)
        //     .set({"userId": uid, "userOrder": [], "orderSummary": []});

        //SToast Message
        Fluttertoast.showToast(
            msg: LocaleData.signUpMessage.getString(context),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subTitle: error.message.toString());
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subTitle: error.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Future<void> localImagePicker() async {
  //   final ImagePicker imagePicker = ImagePicker();
  //
  //   await MyAppFunctions.imagePickerDialog(
  //       context: context,
  //       cameraFct: () async {
  //         pickedImage = await imagePicker.pickImage(
  //             source: ImageSource.camera,
  //             maxHeight: 480,
  //             maxWidth: 640,
  //             imageQuality: 50);
  //         setState(() {});
  //       },
  //       galleryFct: () async {
  //         pickedImage = await imagePicker.pickImage(
  //             source: ImageSource.gallery,
  //             maxHeight: 480,
  //             maxWidth: 640,
  //             imageQuality: 85);
  //         setState(() {});
  //       },
  //       removeFct: () {
  //         setState(() {
  //           pickedImage = null;
  //         });
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
        textDirection: themeProvider.currentLocaleProvider == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: LoadingManager(
            isLoading: isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    const AppNameTextWidget(
                        label: "Elgaml Stores", fontSize: 24),
                    const SizedBox(
                      height: 20,
                    ),
                    TitleTextWidget(
                        label: LocaleData.welcome.getString(context)),
                    const SizedBox(
                      height: 10,
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     await localImagePicker();
                    //   },
                    //   child: SizedBox(
                    //       height: size.width * 0.3,
                    //       width: size.width * 0.3,
                    //       child: ImagePickerWidget(
                    //           function: () async {
                    //             await localImagePicker();
                    //           },
                    //           pickedImage: pickedImage)),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText:
                                  LocaleData.signUpToName.getString(context),
                              prefixIcon: const Icon(Icons.person),
                            ),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                            validator: (value) {
                              return MyValidators.displayNamevalidator(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText:
                                  LocaleData.signUpToEmail.getString(context),
                              prefixIcon: const Icon(IconlyLight.message),
                            ),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              return MyValidators.emailValidator(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            obscureText: isObscureText,
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                hintText: LocaleData.signUpToPassword
                                    .getString(context),
                                prefixIcon: const Icon(IconlyLight.lock),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObscureText = !isObscureText;
                                    });
                                  },
                                  icon: Icon(isObscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                )),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_repeatPasswordFocusNode);
                            },
                            validator: (value) {
                              return MyValidators.passwordValidator(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            obscureText: isObscureText,
                            controller: _repeatPasswordController,
                            focusNode: _repeatPasswordFocusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: LocaleData.signUpToConfirmPassword
                                  .getString(context),
                              prefixIcon: const Icon(IconlyLight.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscureText = !isObscureText;
                                  });
                                },
                                icon: Icon(isObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            onFieldSubmitted: (value) async {
                              await registerFct();
                            },
                            validator: (value) {
                              return MyValidators.repeatPasswordValidator(
                                  value: value,
                                  password: _passwordController.text);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText:
                                  LocaleData.signUpPhone.getString(context),
                              prefixIcon: const Icon(IconlyLight.call),
                            ),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode);
                            },
                            validator: (value) {
                              return MyValidators.phonevalidator(value);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                await registerFct();
                              },
                              label: Text(
                                LocaleData.signUp.getString(context),
                                style: const TextStyle(fontSize: 20),
                              ),
                              icon: const Icon(IconlyLight.addUser),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SubtitleTextWidget(
                            label: LocaleData.signUpConnectUsing
                                .getString(context),
                          ),
                          const GoogleButton(
                            sign: "Up",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SubtitleTextWidget(
                                  label: LocaleData.signUpToAlreadyHaveAccount
                                      .getString(context)),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(LoginScreen.routeName);
                                },
                                child: SubtitleTextWidget(
                                  label: LocaleData.signIn.getString(context),
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
