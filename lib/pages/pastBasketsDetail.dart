import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import 'map.dart';

class PastBasketsDetail extends StatefulWidget {
  final Map<String, dynamic> basket;

  const PastBasketsDetail({super.key, required this.basket});

  @override
  State<StatefulWidget> createState() => _PastBasketsDetail();
}

class _PastBasketsDetail extends State<PastBasketsDetail> {
  List<ProductModel> allResults = [];

  @override
  void initState() {
    for (final item in widget.basket["content"]) {
      allResults.add(ProductModel(
          title: item["product"]["title"],
          category: item["product"]["category"],
          price: item["product"]["price"],
          vendor: item["product"]["vendor"],
          id: item["product"]["id"],
          image: item["product"]["image"]));
    }
    super.initState();
  }

  Widget _buildCard(Map<String, dynamic> product) {
    final Map<String, String> logoMap = {
      "itopya": "assets/images/104314.png",
      "vatan bilgisayar": "assets/images/Vatan_Computer.jpg",
      "teknosa": "assets/images/TEKnosa.png",
      "media markt": "assets/images/Media_Markt_red_textmark.png"
    };

    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5)
          ],
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: (product["product"]["category"].toString() ==
                              "search"
                          ? NetworkImage(product["product"]["image"].toString())
                          : AssetImage(product["product"]["image"].toString())
                              as ImageProvider),
                      fit: BoxFit.contain),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: 150,
                child: Column(
                  children: [
                    Text(
                      product["product"]["title"].toString().length >= 50
                          ? "${product["product"]["title"].toString().substring(0, 50)}..."
                          : product["product"]["title"].toString(),
                      style: const TextStyle(
                          color: Colors.deepPurple, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${product["product"]["price"].toString()} ₺",
                      style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: 60,
                width: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            logoMap[product["product"]["vendor"].toString()]!),
                        fit: BoxFit.contain)),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Quantity : ${product["quantity"]}",
                style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.purple,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Past Basket Detail",
          style: TextStyle(color: Colors.purple),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView(
              children: [
                for (final product in widget.basket["content"]) _buildCard(product),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
                child: Container(
                  color: Colors.purple,
                  height: 2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Total: ${widget.basket["total"]} ₺",
                style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(products: allResults),
                  ),
                );
              },
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.map_outlined),
            ),
          )
        ],
      ),
    );
  }
}
