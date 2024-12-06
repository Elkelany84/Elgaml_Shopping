import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/products_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  // TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
    // searchTextController.addListener(() {
    //   // setState(() {});
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   countProducts();
  //
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //     tooltip: "increment",
          //     onPressed: () {
          //       productsProvider.fetchProductNames();
          //     }),
          appBar: AppBar(
            // leading: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.asset(
            //     AssetsManager.shoppingCart,
            //   ),
            // ),
            title: AppNameTextWidget(
                label: passedCategory ??
                    "جميع المنتجات ( ${productsProvider.quer} )"),
          ),
          body: productList.isEmpty
              ? Center(
                  child: TitlesTextWidget(label: "No Products Found!"),
                )
              : StreamBuilder<List<ProductModel>>(
                  stream: productsProvider.fetchProductStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null) {
                      return const MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: SelectableText(snapshot.error.toString()),
                      );
                    } else if (snapshot.data == null) {
                      return Center(
                        child: SelectableText("No Products Found!"),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // TextField(
                          //   controller: searchTextController,
                          //   decoration: InputDecoration(
                          //     hintText: "Search",
                          //     prefixIcon: Icon(
                          //       Icons.search,
                          //     ),
                          //     suffixIcon: GestureDetector(
                          //       onTap: () {
                          //         searchTextController.clear();
                          //         FocusScope.of(context).unfocus();
                          //       },
                          //       child: Icon(
                          //         Icons.clear,
                          //         color: Colors.red,
                          //       ),
                          //     ),
                          //   ),
                          //   //Decrease The Performance a little bit
                          //   onChanged: (value) {
                          //     // setState(() {
                          //     productListSearch = productsProvider.searchQuery(
                          //         searchText: searchTextController.text,
                          //         passedList: productList);
                          //     // });
                          //   },
                          //   onSubmitted: (value) {
                          //     setState(() {
                          //       productListSearch = productsProvider.searchQuery(
                          //           searchText: searchTextController.text,
                          //           passedList: productList);
                          //     });
                          //   },
                          // ),
                          TypeAheadField(
                              // showOnFocus: false,
                              hideOnLoading: true,
                              hideOnError: true,
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "بحث",
                                      prefixIcon: Icon(Icons.search)),
                                );
                              },
                              errorBuilder: (context, error) =>
                                  const Text('لا توجد منتجات مطابقة للبحث'),
                              emptyBuilder: (context) =>
                                  const Text('لا توجد منتجات مطابقة للبحث'),
                              transitionBuilder: (context, animation, child) {
                                return FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                  child: child,
                                );
                              },
                              itemBuilder: (context, String suggestions) {
                                return ListTile(
                                  title: Text(suggestions),
                                );
                              },
                              onSelected: (value) {
                                setState(() {
                                  searchTextController.text = value;
                                  productListSearch =
                                      productsProvider.searchQuery(
                                          searchText: searchTextController.text,
                                          passedList: productList);
                                });
                              },
                              suggestionsCallback: (String search) {
                                return productsProvider.getSuggestions(search);
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          if (searchTextController.text.isNotEmpty &&
                              productListSearch.isEmpty) ...[
                            Center(
                                child:
                                    TitlesTextWidget(label: "لا توجد منتجات"))
                          ],
                          Expanded(
                            child: DynamicHeightGridView(
                              // mainAxisSpacing: 12,
                              // crossAxisSpacing: 12,
                              builder: (context, index) {
                                return ProductWidget(
                                  productId: searchTextController.text.isEmpty
                                      ? productList[index].productId
                                      : productListSearch[index].productId,
                                );
                              },
                              itemCount: searchTextController.text.isEmpty
                                  ? productList.length
                                  : productListSearch.length,
                              crossAxisCount: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
