import 'package:flutter/material.dart';
import 'package:techpack/pages/cart.dart';
import 'package:techpack/product_info.dart';
import '../search_delegate.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final productInfo = ProductInfo.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
        color: Colors.purple,
      ),
      title: Container(
        height: 50,
        child: Image.asset(
          "assets/images/logo.jpg",
        ),
      ),
      titleSpacing: 0,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(
                    products: productInfo.products,
                    cart: productInfo.cart,
                  ));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.purple,
              size: 30,
            )),
        Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Cart(
                      cart: productInfo.cart,
                      addToCart: productInfo.addToCart,
                      removeFromCart: productInfo.removeFromCart,
                    );
                  }));
                },
                icon: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.purple,
                  size: 30,
                )),
          ),
          Visibility(
            visible: productInfo.cart.isNotEmpty,
            child: Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
                child: Center(
                    child: Text(
                  productInfo.cart.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                )),
              ),
            ),
          )
        ])
      ],
    );
  }
}
