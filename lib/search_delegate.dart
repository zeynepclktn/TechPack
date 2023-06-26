import 'package:flutter/material.dart';
import 'package:techpack/models/product_model.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<ProductModel> products;
  final List<ProductModel> cart;

  ProductSearchDelegate(
      {required this.products, required this.cart});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
          toolbarHeight: 60, elevation: 0, color: Colors.white),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.purple,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.purple));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != "") {
      List<ProductModel> matchQuery = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.vendor.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return ListView.builder(
          itemCount: matchQuery.length ,
          itemBuilder: ((context, index) {
            ProductModel result = matchQuery[index];

            return Container(
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5)
                  ],
                  color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: result.category== "search"
                                        ? NetworkImage(result.image)
                                        : AssetImage(result.image) as ImageProvider,
                                    fit: BoxFit.contain)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: 150,
                            child: Column(
                              children: [
                                Text(
                                  result.title.length>=50 ? "${result.title.substring(0,50)}..." : result.title,
                                  style: const TextStyle(
                                      color: Colors.deepPurple, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Text(
                                    "${result.price} ₺",
                                    style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          cart.contains(result)
                              ? Row(
                                  children: const [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: Colors.deepPurple,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "In your cart",
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 12),
                                    )
                                  ],
                                )
                              : const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(result.logoMapper()!),
                                    fit: BoxFit.contain)),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          }));
    } else {
      return const Center(
          child: Text(
        "Please enter a keyword",
        style: TextStyle(color: Colors.purple),
      ));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != "") {
      List<ProductModel> matchQuery = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.vendor.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: ((context, index) {
            ProductModel result = matchQuery[index];

            return Container(
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5)
                  ],
                  color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: result.category== "search"
                                        ? NetworkImage(result.image)
                                        : AssetImage(result.image) as ImageProvider,
                                    fit: BoxFit.contain)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: 150,
                            child: Column(
                              children: [
                                Text(
                                  result.title.length>=50 ? "${result.title.substring(0,50)}..." : result.title,
                                  style: const TextStyle(
                                      color: Colors.deepPurple, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Text(
                                    "${result.price} ₺",
                                    style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          cart.contains(result)
                              ? Row(
                                  children: const [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                      color: Colors.deepPurple,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "In your cart",
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 12),
                                    )
                                  ],
                                )
                              : const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(result.logoMapper()!),
                                    fit: BoxFit.contain)),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          }));
    } else {
      return const Center(
          child: Text(
        "Please enter a keyword",
        style: TextStyle(color: Colors.purple),
      ));
    }
  }
}
