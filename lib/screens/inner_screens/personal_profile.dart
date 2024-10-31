import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/validator.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/models/user_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/root_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class PersonalProfile extends StatefulWidget {
  const PersonalProfile({
    super.key,
  });

  static const String routeName = '/personal-profile';

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  // User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  // bool? _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        // _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
      setState(() {
        //Update the controllers
        _firstNameController.text = userModel!.userName;
        _phoneController.text = userModel!.userPhone;
        _addressController.text = userModel!.userAddress;
      });
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        // _isLoading = false;
      });
    }
  }

  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _userEmailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _createdAtController;
  late final FocusNode _firstNameFocusNode;
  late final FocusNode _userEmailFocusNode;
  late final FocusNode _addressFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _createdAtFocusNode;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _isLoading == true ? null : fetchUserInfo();
    // print(user);
    user != null ? fetchUserInfo() : null;
    _firstNameController = TextEditingController();
    _userEmailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _createdAtController = TextEditingController();
    _firstNameFocusNode = FocusNode();
    _userEmailFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _createdAtFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _userEmailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _createdAtController.dispose();
    _firstNameFocusNode.dispose();
    _userEmailFocusNode.dispose();
    _addressFocusNode.dispose();
    _phoneFocusNode.dispose();
    _createdAtFocusNode.dispose();
    super.dispose();
  }

  Future<void> updateUserDetailsFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        final User user = auth.currentUser!;
        final String uid = user.uid;

        //Register user in FirebaseFirestore
        await FirebaseFirestore.instance.collection("users").doc(uid).update({
          "userName": _firstNameController.text.trim(),
          "userAddress": _addressController.text.trim(),
          "userPhone": _phoneController.text.trim(),
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: LocaleData.updateAccountMessage.getString(context),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, RootScreen.routeName);
        // Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Directionality(
      textDirection: themeProvider.currentLocaleProvider == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          // leading: Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Image.asset(AssetsManager.shoppingCart),
          // ),
          title: AppNameTextWidget(
            label: LocaleData.profileScreen.getString(context),
            fontSize: 24,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: userModel == null
              ? EmptyBag(
                  imagePath: AssetsManager.orderBag,
                  title: "برجاء بدء التسوق أولا",
                  titleFont: 18,
                  // subtitle: "Looks Like Your Cart is Empty,Start Shopping!",
                  // details: "Looks Like Your Cart is Empty,Start Shopping!",
                  buttonText: LocaleData.shopNow.getString(context),
                  buttonFont: 18,
                )

              // const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubtitleTextWidget(
                        label: LocaleData.yourDetails.getString(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        textDecoration: TextDecoration.underline,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SubtitleTextWidget(
                        label: LocaleData.subDetails.getString(context),
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleTextWidget(
                              label: LocaleData.firstName.getString(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: userModel!.userName,
                                prefixIcon: const Icon(Icons.person),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocusNode);
                              },
                              validator: (value) {
                                return MyValidators.displayNamevalidator(value);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SubtitleTextWidget(
                              label: LocaleData.email.getString(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: _userEmailController,
                              focusNode: _userEmailFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: userModel!.userEmail,
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SubtitleTextWidget(
                              label: LocaleData.address.getString(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _addressController,
                              focusNode: _addressFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: userModel!.userAddress,
                                prefixIcon: const Icon(Icons.location_city),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_phoneFocusNode);
                              },
                              validator: (value) {
                                return MyValidators.addressvalidator(value);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SubtitleTextWidget(
                              label: LocaleData.phone.getString(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: userModel!.userPhone,
                                prefixIcon: const Icon(Icons.phone),
                              ),
                              onFieldSubmitted: (value) async {
                                await updateUserDetailsFct();
                              },
                              validator: (value) {
                                return MyValidators.phonevalidator(value);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SubtitleTextWidget(
                              label: LocaleData.creationDate.getString(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: _createdAtController,
                              focusNode: _createdAtFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText:
                                    // timeago.format(userModel!.createdAt.toDate()),
                                    userModel!.createdAt
                                        .toDate()
                                        .toString()
                                        .substring(0, 10),
                                prefixIcon: const Icon(Icons.date_range),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
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
                                  await updateUserDetailsFct();
                                },
                                label: Text(
                                  LocaleData.save.getString(context),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                icon: const Icon(IconlyLight.addUser),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
