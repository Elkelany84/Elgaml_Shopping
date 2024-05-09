import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("ar", LocaleData.AR),
];

mixin LocaleData {
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
