import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/models/user_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/login_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/orders_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/personal_profile.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/viewed_recently.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/wishlist.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  //to Fetch the user info once and keep it in the app we add the above line
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    // print(_currentLocale);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.currentLocaleProvider = _currentLocale;
    print(themeProvider.currentLocaleProvider);

    return Directionality(
      textDirection: themeProvider.currentLocaleProvider == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
          title: AppNameTextWidget(
            label: LocaleData.profileScreen.getString(context),
            fontSize: 22,
          ),
        ),
        body: LoadingManager(
          isLoading: _isLoading,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TitleTextWidget(
                        label:
                            LocaleData.profileScreenMessage.getString(context)),
                  ),
                ),
                userModel == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                                // image: DecorationImage(
                                //     image: NetworkImage(userModel!.userImage),
                                //     fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleTextWidget(label: userModel!.userName),
                                const SizedBox(
                                  height: 6,
                                ),
                                SubtitleTextWidget(label: userModel!.userEmail)
                              ],
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 18,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Divider(
                    thickness: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      TitleTextWidget(
                          label: LocaleData.general.getString(context)),
                    ],
                  ),
                ),
                Visibility(
                  visible: userModel == null ? false : true,
                  child: CustomListTile(
                    label: LocaleData.allOrders.getString(context),
                    imagePath: AssetsManager.orderSvg,
                    onTab: () {
                      Navigator.of(context)
                          .pushNamed(OrdersScreenFree.routeName);
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: userModel == null ? false : true,
                  child: CustomListTile(
                    label: LocaleData.wishList.getString(context),
                    imagePath: AssetsManager.wishlistSvg,
                    onTab: () async {
                      await Navigator.pushNamed(
                          context, WishListScreen.routeName);
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomListTile(
                  label: LocaleData.viewedRecently.getString(context),
                  imagePath: AssetsManager.recent,
                  onTab: () async {
                    await Navigator.pushNamed(
                        context, ViewedRecentlyScreen.routeName);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: userModel == null ? false : true,
                  child: CustomListTile(
                    label: LocaleData.personalProfile.getString(context),
                    imagePath: AssetsManager.profile,
                    onTab: () {
                      Navigator.pushNamed(context, PersonalProfile.routeName);
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Divider(
                    thickness: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: TitleTextWidget(
                      label: LocaleData.settings.getString(context)),
                ),
                SwitchListTile(
                    secondary: Image.asset(
                      AssetsManager.theme,
                      height: 34,
                    ),
                    title: Text(themeProvider.getIsDarkTheme
                        ? LocaleData.darkMode.getString(context)
                        : LocaleData.lightMode.getString(context)),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(value);
                    }),
                const SizedBox(
                  height: 8,
                ),
                ListTile(
                  leading: Image.asset(
                    AssetsManager.language,
                    height: 34,
                  ),
                  title: SubtitleTextWidget(
                    label: LocaleData.language.getString(context),
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _currentLocale,
                      items: const [
                        DropdownMenuItem(
                          value: "en",
                          child: Text("English"),
                        ),
                        DropdownMenuItem(
                          value: "ar",
                          child: Text("العربية"),
                        ),
                      ],
                      onChanged: (value) {
                        _setLocale(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                    child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (user == null) {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    } else {
                      await MyAppFunctions.showErrorOrWarningDialog(
                        context: context,
                        subTitle: LocaleData.logoutMessage.getString(context),
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);

                          // auth.signOut().then((value) => Navigator.of(context)
                          //     .pushNamed(RootScreen.routeName));
                        },
                        isError: false,
                      );
                    }
                  },
                  label: Text(
                    user == null
                        ? LocaleData.login.getString(context)
                        : LocaleData.logout.getString(context),
                    style: const TextStyle(fontSize: 20),
                  ),
                  icon: Icon(user == null ? Icons.login : Icons.logout),
                )
                    // child: ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.red,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   onPressed: () async {
                    //     if (user == null) {
                    //       Navigator.of(context).pushNamed(LoginScreen.routeName);
                    //     } else {
                    //       await MyAppFunctions.showErrorOrWarningDialog(
                    //         isError: false,
                    //         context: context,
                    //         subTitle: "Are You Sure You Want To SignOut?",
                    //         fct: () {
                    //           auth.signOut().then((value) => Navigator.of(context)
                    //               .pushNamed(RootScreen.routeName));
                    //         },
                    //       );
                    //     }
                    //   },
                    //   label: Text(
                    //     user == null ? "Login" : "Logout",
                    //     style: TextStyle(fontSize: 20),
                    //   ),
                    //   icon: Icon(user == null ? Icons.login : Icons.logout),
                    // ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setLocale(String? value) {
    if (value == null) return;
    if (value == "en") {
      _flutterLocalization.translate("en");
    } else {
      _flutterLocalization.translate("ar");
    }
    setState(() {
      _currentLocale = value;
    });
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.label,
      required this.imagePath,
      required this.onTab});

  final String label;
  final String imagePath;
  final Function() onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTab,
      title: SubtitleTextWidget(
        label: label,
      ),
      leading: Image.asset(
        imagePath,
        height: 34,
      ),
      trailing: Icon(IconlyLight.arrowRight2),
    );
  }
}
