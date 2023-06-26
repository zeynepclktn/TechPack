import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:techpack/authentication/auth.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:html/dom.dart' as dom;
import 'package:techpack/pages/categories.dart';
import 'package:http/http.dart' as http;
import 'package:techpack/pages/pastBaskets.dart';
import '../models/product_model.dart';
import 'dart:math';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  bool isLoadingActive = false;

  String queryBuilder(String query, String vendor) {
    String url;

    if (vendor == "teknosa") {
      url = "https://www.teknosa.com/arama/?s=$query";
    } else if (vendor == "itopya") {
      url = "https://www.itopya.com/AramaSonuclari?text=$query";
    } else {
      url = "https://www.vatanbilgisayar.com/arama/$query/";
    }

    return url;
  }

  List<ProductModel>? scraper(String vendor, http.Response response) {
    List<String> titles = [];
    List<String> prices = [];
    List<String> images = [];
    Random rnd = Random();
    List<ProductModel> searchedProducts = [];
    dom.Document html = dom.Document.html(response.body);

    try{

      if (vendor == "teknosa" && html.querySelectorAll('#product-item > a.prd-link').isNotEmpty) {
        titles = html
            .querySelectorAll('#product-item > a.prd-link')
            .take(4)
            .map((e) => e.attributes['title']!)
            .toList();

        prices = html
            .querySelectorAll('#product-item')
            .take(4)
            .map((e) => e.attributes['data-product-price']!)
            .toList();

        images = html
            .querySelectorAll(
            '#product-item > div > div.prd-media > figure > img')
            .take(4)
            .map((e) => e.attributes['data-srcset']!)
            .toList();
      } else if (vendor == "vatan bilgisayar" && html.querySelectorAll("div.product-list__content > a > div.product-list__product-name > h3").isNotEmpty) {
        titles = html.querySelectorAll(
            "div.product-list__content > a > div.product-list__product-name > h3")
            .take(4)
            .map((e) => e.innerHtml.trim())
            .toList();

        prices = html
            .querySelectorAll(
            "div.product-list__content > div.product-list__cost > span.product-list__price")
            .take(4)
            .map((e) {
          String price = e.innerHtml.trim();
          String formattedPrice = price.replaceAll(".", "");
          return formattedPrice;
        }).toList();

        images = html
            .querySelectorAll(
            "div.product-list__image-safe > a > div:nth-child(1) > img")
            .take(4)
            .map((e) => e.attributes["data-src"]!)
            .toList();
      } else if (vendor == "itopya" && html.querySelectorAll("#productList > div.product > div.product-body > a").isNotEmpty) {
        titles = html
            .querySelectorAll("#productList > div.product > div.product-body > a")
            .take(4)
            .map((e) => e.innerHtml.trim())
            .toList();

        prices = html
            .querySelectorAll(
            "#productList > div.product > div.product-footer > div.price > strong")
            .take(4)
            .map((e) {
          String price = e.innerHtml.trim();
          String formattedPrice = price.substring(0, price.indexOf(","));
          String formattedPrice2 = formattedPrice.replaceAll(".", "");
          return formattedPrice2;
        }).toList();

        images = html
            .querySelectorAll(
            "#productList > div.product > div.product-header > a.image > img")
            .take(4)
            .map((e) => e.attributes["data-src"]!)
            .toList();
      }

      for (int i = 0; i < titles.length; i++) {
        searchedProducts.add(ProductModel(
            title: titles[i],
            category: "search",
            price: double.parse(prices[i]),
            vendor: vendor,
            id: rnd.nextInt(10000),
            image: images[i]));
      }

      return searchedProducts;


    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future<List<ProductModel>?> extractData(String query, String vendor) async {
    List<ProductModel> products = [];
    final response = await http.get(Uri.parse(queryBuilder(query, vendor)));

    try{
      if (response.statusCode == 200) {
        products = scraper(vendor, response)!;
        return products;
      }
      print('Error: ${response.statusCode}.');
      return products;

    }catch(e){
      return null;
    }

  }

  Future<List<ProductModel>?> getSearchProducts(String value) async {
    List<ProductModel> allResults = [];

    try {
      setState(() {
        isLoadingActive = true;
      });

      final teknosaResults = await extractData(value, "teknosa");
      final itopyaResults = await extractData(value, "itopya");
      final vatanResults = await extractData(value, "vatan bilgisayar");

      setState(() {
        isLoadingActive = false;
      });

      allResults.addAll(teknosaResults!);
      allResults.addAll(itopyaResults!);
      allResults.addAll(vatanResults!);

      return allResults;

    }catch(e){
      return null;
    }

  }

  Future<List<ProductModel>> getCategoriesProducts() async {
    setState(() {
      isLoadingActive = true;
    });

    List<dynamic> data = json
        .decode(await rootBundle.loadString("assets/data/mock_products.json"));
    List<ProductModel> prods =
        data.map((data) => ProductModel.fromJson(data)).toList();

    setState(() {
      isLoadingActive = false;
    });

    return prods;
  }

  Future<List<Map<String, dynamic>>> readPastBaskets() async {
    setState(() {
      isLoadingActive = true;
    });

    var records = await FirebaseFirestore.instance
        .collection("past-baskets")
        .where("user",isEqualTo:Auth().currentUser?.uid)
        .orderBy("timestamp",descending: true)
        .limit(3)
        .get();

    var list = records.docs
        .map((record) => {
              "id": record.data()["id"],
              "user": record.data()["user"],
              "total": record.data()["total"],
              "timestamp": (record.data()["timestamp"] as Timestamp).toDate(),
              "content": record.data()["content"],
            })
        .toList();

    setState(() {
      isLoadingActive = false;
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingActive
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text("Loading",
                      style: TextStyle(color: Colors.purple, fontSize: 18))
                ],
              ),
            ))
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Text(
                        "Logged in as ${Auth().currentUser?.email ?? 'User email'}",style: const TextStyle(color: Colors.purple)),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset('assets/logo.jpg',height:150,width: 300,),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 300.0,
                      child: TextField(
                        onSubmitted: (value) async {
                          List<ProductModel>? searchProducts =
                              await getSearchProducts(value);

                          if (searchProducts == null) {
                            final error = SnackBar(
                              content: const Text(
                                  'We couldn\'t find any results 🙁'),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: () {},
                              ),
                            );

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(error);
                          } else if (searchProducts.isEmpty){
                            final error = SnackBar(
                              content: const Text(
                                  'We couldn\'t find any results 🙁'),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: () {},
                              ),
                            );

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(error);
                          }else {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Categories(
                                      content: "searched products",
                                      products: searchProducts)),
                            );
                          }
                        },
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.0),
                          border: GradientOutlineInputBorder(
                              width: 3.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              gradient: LinearGradient(colors: [
                                Colors.deepPurpleAccent,
                                Colors.purple
                              ])),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                            onPressed: () {
                              Auth().signOut();
                            },
                            icon: const Icon(Icons.logout_outlined,
                                color: Colors.purple),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              textStyle: const TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.normal),
                              shadowColor: Colors.purple,
                            ),
                            label: const Text("Logout",
                                style: TextStyle(color: Colors.purple))),
                        TextButton.icon(
                          onPressed: () async {
                            final pastBasketList = await readPastBaskets();

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PastBaskets(baskets : pastBasketList)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.normal),
                            shadowColor: Colors.purple,
                          ),
                          label: const Text('Past Baskets',
                              style: TextStyle(color: Colors.purple)),
                          icon: const Icon(
                            Icons.shopping_basket_outlined,
                            color: Colors.purple,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            List<ProductModel> categoriesProducts =
                                await getCategoriesProducts();

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Categories(
                                        content: "categories",
                                        products: categoriesProducts,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.normal),
                            shadowColor: Colors.purple,
                          ),
                          label: const Text('Categories',
                              style: TextStyle(color: Colors.purple)),
                          icon: const Icon(
                            Icons.dehaze,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );
  }
}
