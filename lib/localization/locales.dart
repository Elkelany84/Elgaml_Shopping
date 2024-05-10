import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("ar", LocaleData.AR),
];

mixin LocaleData {
  //Signup Screen
  static const String welcome = "Welcome !";
  static const String signUpToName = "Enter Your Name";
  static const String signUpToEmail = "Enter Your Email";
  static const String signUpToPassword = "Enter Your Password";
  static const String signUpToConfirmPassword = "Repeat Password";
  static const String signUpToSignUp = "Sign Up";
  static const String signUpConnectUsing = "Or Sign Up using ";
  static const String signUpToAlreadyHaveAccount = "Already have an account?";

  //Login Screen
  static const String welcomeBack = "Welcome Back!";
  static const String loginEmail = "Email Address";
  static const String password = "Password";
  static const String forgotPassword = "Forgot Password?";
  static const String newHere = "New Here?";
  static const String loginConnectUsing = "Or Connect Using";
  static const String signIn = "Sign In";
  static const String signUp = "Sign Up";
  static const String guest = "Guest";
  static const String googleSignin = "SignIn With Google";

  //Forgot Password Screen
  static const String forgotPasswordScreen = "Forgot Password ?";
  static const String forgotPasswordScreenMessage =
      "Enter your email address to reset your password.";
  static const String forgotPasswordScreenToEmail = "Enter Your Email Address";
  static const String forgotPasswordRequestLink = "Request Link";

  //Root Screen
  static const String home = "Home";
  static const String search = "Search";
  static const String cart = "Cart";
  static const String profile = "Profile";

  //Search Screen
  static const String searchProducts = "Search Products";

  //Home Screen
  static const String latestArrivals = "Latest Arrivals";
  static const String categories = "Categories";
  static const String showAll = "Show All";

  //Cart Screen
  static const String total = "Total";
  static const String products = "Products";
  static const String items = "Items";
  static const String clearCart = "Clear Cart";
  static const String checkout = "Checkout";
  static const String emptyCartMessage = "Looks Like Your Cart Is Empty!";
  static const String shopNow = "Shop now";

  //Profile Screen
  static const String profileScreen = "Profile Screen";
  static const String general = "General";
  static const String allOrders = "All Orders";
  static const String wishList = "WishList";
  static const String viewedRecently = "Viewed Recently";
  static const String personalProfile = "Personal Profile";
  static const String settings = "Settings";
  static const String lightMode = "LightMode";
  static const String darkMode = "DarkMode";
  static const String language = "Language";
  static const String login = "Login";
  static const String logout = "Logout";
  static const String logoutMessage = "Are You Sure You Want To SignOut?";

  //Personal Profile
  static const String yourDetails = "Your Details: ";
  static const String subDetails =
      "You Can Change your Details From Here , Then Press Save. ";
  static const String firstName = "First Name: ";
  static const String email = "E-mail: You Can\'t Change Your E-mail ";
  static const String phone = "Phone: ";
  static const String address = "Address: ";
  static const String creationDate = "Creation Date: ";
  static const String save = "Save";
  static const String updateAccountMessage = "An Account Has been Updated!";

  //WishList Screen
  static const String wishListScreen = "WishList";
  static const String clearWishList = "Clear Wishlist";
  static const String wishListMessage = "Looks Like Your Wishlist Is Empty!";

  //Viewed Recently
  static const String viewedRecentlyScreen = "Viewed Recently";
  static const String clearViewedRecently = "Clear Viewed Recently";
  static const String viewedRecentlyMessage =
      "Looks Like You Have Not Viewed Any Product!";

  //PaymentSuccess
  static const String continueShopping = "Continue Shopping";
  static const String paymentSuccessMessage =
      "Your Order Place Successfully and \n            Forward to Our Store!";

  //Categories Screen
  static const String allCategories = "All Categories";

  static const Map<String, dynamic> EN = {
    //Root Screen
    home: "Home",
    search: "Search",
    cart: "Cart",
    profile: "Profile",

    //Signup Screen
    welcome: "Welcome !",
    signUpToName: "Enter Your Name",
    signUpToEmail: "Enter Your Email",
    signUpToPassword: "Enter Your Password",
    signUpToConfirmPassword: "Repeat Password",
    signUpToAlreadyHaveAccount: "Already Have An Account?",
    signUpConnectUsing: "Or Sign Up using ",

    //Login Screen
    signIn: "Sign In",
    signUp: "Sign Up",
    loginEmail: "Email Address",
    password: "Password",
    welcomeBack: "Welcome Back!",
    forgotPassword: "Forgot Password?",
    newHere: "New Here?",
    loginConnectUsing: "Or Connect Using",
    guest: "Guest",
    googleSignin: "SignIn With Google",

    //Forgot Password
    forgotPasswordScreen: "Forgot Password",
    forgotPasswordScreenMessage: "Enter Your Email To Reset Your Password",
    forgotPasswordScreenToEmail: "Enter Your Email Address",
    forgotPasswordRequestLink: "Request Link",

    //Home Screen
    latestArrivals: "Latest Arrivals",
    categories: "Categories",
    showAll: "Show All",

    //Search Screen
    searchProducts: "Search Products",

    //Cart Screen
    total: "Total",
    products: "Products",
    items: "Items",
    clearCart: "Clear Cart ?",
    checkout: "Checkout",
    emptyCartMessage: "Looks Like Your Cart Is Empty!",
    shopNow: "Shop now",

    //PaymentSuccess
    continueShopping: "Continue Shopping",
    paymentSuccessMessage:
        "Your Order Place Successfully and \n            Forward to Our Store!",

    //Profile Screen
    profileScreen: "Profile Screen",
    general: "General",
    allOrders: "All Orders",
    wishList: "WishList",
    viewedRecently: "Viewed Recently",
    personalProfile: "Personal Profile",
    settings: "Settings",
    lightMode: "LightMode",
    darkMode: "DarkMode",
    language: "Language",
    login: "Login",
    logout: "Logout",
    logoutMessage: "Are You Sure You Want To SignOut?",

    //Personal Profile
    yourDetails: "Your Details: ",
    subDetails: "You Can Change your Details From Here , Then Press Save. ",
    firstName: "First Name: ",
    email: "E-mail: You Can\'t Change Your E-mail ",
    phone: "Phone: ",
    address: "Address: ",
    creationDate: "Creation Date: ",
    save: "Save",
    updateAccountMessage: "An Account Has been Updated!",

    //WishList Screen

    clearWishList: "Clear Wishlist",
    wishListMessage: "Looks Like Your Wishlist Is Empty!",

    //Categories Screen
    allCategories: "All Categories",

    //Viewed Recently
    clearViewedRecently: "Clear Viewed Recently",
    viewedRecentlyMessage: "Looks Like You Have Not Viewed Any Product!",
  };

  static const Map<String, dynamic> AR = {
    //Signup Screen
    welcome: "مرحبا بك",
    signUpToName: "ادخل إسمك",
    signUpToEmail: "ادخل بريدك الإليكترونى",
    signUpToPassword: "ادخل كلمة السر",
    signUpToConfirmPassword: "أعد كلمة السر",
    signUpToAlreadyHaveAccount: "هل لديك حساب بالفعل ؟",
    //Login Screen
    signIn: "دخول",
    signUp: "تسجيل جديد",
    loginEmail: "ادخل بريدك الإليكترونى",
    password: "ادخل كلمة السر",
    welcomeBack: "مرحبا بك",
    forgotPassword: "هل نسيت كلمة السر ؟",
    newHere: "مستخدم جديد",
    loginConnectUsing: "الدخول بواسطة",
    guest: "التصفح كضيف",
    googleSignin: "الدخول بحساب جوجل",

    //Forgot Password
    forgotPasswordScreen: "هل نسيت كلمة السر ؟",
    forgotPasswordScreenMessage:
        "ادخل بريدك الإليكترونى لتحصل على رابط كلمة السر",
    forgotPasswordScreenToEmail: "ادخل بريدك الإليكترونى",
    forgotPasswordRequestLink: "ارسل الرابط",

    //Root Screen
    home: "الرئيسية",
    search: "بحث",
    cart: "سلة التسوق",
    profile: "الملف الشخصى",
    //Home Screen
    latestArrivals: "أحدث المنتجات",
    categories: "التصنيفات",
    showAll: "عرض الكل",
    //Search Screen
    searchProducts: "المنتجات",

    //Cart Screen
    total: "المجموع",
    products: "المنتجات",
    items: "العناصر",
    clearCart: "مسح سلة التسوق ؟",
    checkout: "الدفع",
    emptyCartMessage: "يبدو أن سلة التسوق فارغة!",
    shopNow: "تسوق الآن",

    //PaymentSuccess
    continueShopping: "استمر في التسوق",
    paymentSuccessMessage: "تم تسجيل طلبك بنجاح وجارى العمل عليه",

    //Profile Screen
    profileScreen: "الملف الشخصى",
    general: "عـــام",
    allOrders: "طلبياتى",
    wishList: "المفضلة",
    viewedRecently: "شوهد مؤخرا",
    personalProfile: "ملفى الشخصى",
    settings: "الإعدادات",
    darkMode: "الوضع الداكن",
    lightMode: "الوضع المشرق",
    language: "اللغة",
    login: "دخول",
    logout: "خروج",
    logoutMessage: "هل أنت متأكد من أنك تريد تسجيل الخروج؟",

    //Personal Profile
    yourDetails: "تفاصيلك: ",
    subDetails: "يمكنك تغيير تفاصيلك من هنا ثم انقر على حفظ. ",
    firstName: "الاسم: ",
    email: "البريد الالكتروني: لا يمكنك تغيير بريدك الالكتروني ",
    phone: "رقم الهاتف: ",
    address: "العنوان: ",
    creationDate: "تاريخ الإنشاء: ",
    save: "حفظ",
    updateAccountMessage: "تم تحديث ملفك الشخصى!",

    //WishList Screen

    clearWishList: "مسح المفضلة",
    wishListMessage: "يبدو أن سلة المفضلة فارغة!",

    //Viewed Recently

    clearViewedRecently: "مسح المشاهدة المؤخرة",
    viewedRecentlyMessage: "يبدو أنك لم ترى أي منتج مؤخرا!",
    //Categories Screen
    allCategories: "جميع التصنيفات",
  };
}
