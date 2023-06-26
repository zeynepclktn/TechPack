import 'package:flutter/material.dart';
import 'package:techpack/models/product_model.dart';
import 'package:techpack/product_info.dart';



class ProductPage extends StatefulWidget {
  final bool isCategory;
  const ProductPage({super.key, required this.category, required this.isCategory});

  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {
  Widget _buildCard(ProductModel product, context) {
    final productInfo = ProductInfo.of(context);

    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        child: Container(
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
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    product.logoMapper()!),
                                fit: BoxFit.contain)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: widget.category== "search"
                              ? NetworkImage(product.image)
                              : AssetImage(product.image) as ImageProvider,
                          fit: BoxFit.contain)),
                ),
                const SizedBox(height: 6),
                Text(
                  "${product.price} ₺",
                  style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    product.title.length>=50 ? "${product.title.substring(0,50)}..." : product.title,
                    style:
                        const TextStyle(color: Colors.deepPurple, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (productInfo.cart.contains(product)) ...[
                          IconButton(
                              onPressed: () {
                                productInfo.removeFromCart(product);
                              },
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.purple)),
                          Text(
                            productInfo.cart
                                .where((productInCart) =>
                                    productInCart.id == product.id)
                                .toList()
                                .length
                                .toString(),
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          IconButton(
                              onPressed: () {
                                productInfo.addToCart(product);
                              },
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.purple))
                        ] else
                          IconButton(
                              onPressed: () {
                                productInfo.addToCart(product);
                              },
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.purple,
                              ))
                      ]),
                )
              ],
            )));
  }


  @override


  Widget build(BuildContext context) {
    final productInfo = ProductInfo.of(context);
    return Scaffold(
        body: ListView(
      children: [
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width-30,
            height: widget.isCategory ? MediaQuery.of(context).size.height-345 : MediaQuery.of(context).size.height-300,
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.63,
              children: <Widget>[
                for (final product in productInfo.products)
                  if (product.category == widget.category)
                    _buildCard(product, context),
              ],
            ))
      ],
    ));
  }
}












































































































































