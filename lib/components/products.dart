import 'package:flutter/material.dart';
import 'package:techpack/components/product_page.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(left: 20),
        children: [
          const Text("Categories",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple)),
          const SizedBox(height: 10),
          TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 30),
              tabs: const [
                Tab(
                    child: Text(
                  "Laptops",
                  style: TextStyle(fontSize: 19),
                )),
                Tab(
                    child: Text(
                  "Monitors",
                  style: TextStyle(fontSize: 19),
                )),
                Tab(
                    child: Text(
                  "Graphic Cards",
                  style: TextStyle(fontSize: 19),
                )),
                Tab(
                    child: Text(
                  "Headsets",
                  style: TextStyle(fontSize: 19),
                ))
              ]),
          SizedBox(
            height: MediaQuery.of(context).size.height-100,
            width: double.infinity,
            child: TabBarView(controller: _tabController, children: const[
              ProductPage(category:"laptop",isCategory:true),
              ProductPage(category:"monitor",isCategory:true),
              ProductPage(category:"graphics card",isCategory:true),
              ProductPage(category:"headset",isCategory:true),
            ]),
          )
        ],
      ),
    );
  }
}
