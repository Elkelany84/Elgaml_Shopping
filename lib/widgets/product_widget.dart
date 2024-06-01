import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/edit_upload_product_form.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'subtitle_text.dart';
import 'title_text.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findByProdId(widget.productId);
    Size size = MediaQuery.of(context).size;

    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: GestureDetector(
              onLongPress: () async {
                await MyAppFunctions.confirmDeleteProduct(
                    isError: false,
                    context: context,
                    subtitle: "مسح المنتج ؟",
                    fct: () {
                      productsProvider.deleteProduct(getCurrProduct.productId);
                    });
              },
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditOrUploadProductForm(
                    productModel: getCurrProduct,
                  );
                }));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      height: size.height * 0.22,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: TitlesTextWidget(
                        label: getCurrProduct.productTitle,
                        fontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SubtitleTextWidget(
                      textDirection: TextDirection.rtl,
                      label: "${getCurrProduct.productPrice} جنيه ",
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          );
  }
}
