import 'package:flutter/material.dart';
import 'package:techpack/components/filter_sort.dart';
import 'package:techpack/components/navbar.dart';
import 'package:techpack/components/products.dart';
import 'package:techpack/components/searchedProducts.dart';
import '../models/product_model.dart';
import '../product_info.dart';

class Categories extends StatefulWidget {
  final String content;
  final List<ProductModel> products;

  const Categories(
      {super.key, required this.content, required this.products});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<ProductModel> _cart = [];

  void _addToCart(ProductModel product) {
    setState(() {
      _cart = [..._cart, product];
    });
  }

  void _removeFromCart(ProductModel product) {
    setState(() {
      _cart.remove(product);
      _cart = [..._cart];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProductInfo(
            cart: _cart,
            products: widget.products,
            removeFromCart: _removeFromCart,
            addToCart: _addToCart,
            child: Scaffold(
              appBar: const Navbar(),
              body: Center(
                child: Column(
                  children: [
                    Filter(),
                    widget.content == "categories"
                        ? Products()
                        : SearchedProducts()
                  ],
                ),
              ),
            ),
          );
  }
}
