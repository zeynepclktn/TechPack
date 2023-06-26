import 'package:flutter/material.dart';
import 'models/product_model.dart';

class ProductInfo extends InheritedWidget {
  const ProductInfo(
      {Key? key,
      required Widget child,
      required this.products,
      required this.cart,
      required this.addToCart,
      required this.removeFromCart})
      : super(key: key, child: child);

  final List<ProductModel> products;
  final List<ProductModel> cart;
  final void Function(ProductModel product) addToCart;
  final void Function(ProductModel product) removeFromCart;

  static ProductInfo of(BuildContext context) {
    final ProductInfo? result =
        context.dependOnInheritedWidgetOfExactType<ProductInfo>();
    assert(result != null, "No product info found in context");
    return result!;
  }

  @override
  bool updateShouldNotify(ProductInfo oldWidget) {
    return oldWidget.products != products ||
        oldWidget.cart != cart ||
        oldWidget.addToCart != addToCart ||
        oldWidget.removeFromCart != removeFromCart ;
  }
}
