import 'package:flutter/material.dart';
import 'pastBasketsDetail.dart';

class PastBaskets extends StatefulWidget {
  final List<Map<String, dynamic>> baskets;
  const PastBaskets({super.key, required this.baskets});

  @override
  State<PastBaskets> createState() => _PastBaskets();
}

class _PastBaskets extends State<PastBaskets> {

  Widget _buildCard(Map<String, dynamic> pastbasket) {
    String datetime =
        "${pastbasket["timestamp"].day}/${pastbasket["timestamp"].month}/${pastbasket["timestamp"].year} , ${pastbasket["timestamp"].hour.toString().length == 1 ? "0${pastbasket["timestamp"].hour}" : pastbasket["timestamp"].hour}:${pastbasket["timestamp"].minute.toString().length == 1 ? "0${pastbasket["timestamp"].minute}" : pastbasket["timestamp"].minute}";

    return Container(
      margin: const EdgeInsets.only(left: 15, top: 25, right: 15),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(datetime,
                  style:
                      const TextStyle(color: Colors.deepPurple, fontSize: 15)),
              Text(
                "Total : ${(pastbasket["total"].toString())} ₺",
                style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (pastbasket["content"].length > 2)
                        for (int i = 0; i < 2; i++)
                          _buildimage(pastbasket["content"][i])
                      else
                        for (int i = 0; i < pastbasket["content"].length; i++)
                          _buildimage(pastbasket["content"][i]),
                      const SizedBox(width: 5,),
                      Text(
                        (pastbasket["content"].length) > 2
                            ? "+${pastbasket["content"].length - 2} more"
                            : "",
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PastBasketsDetail(basket: pastbasket)));
                    },
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.deepPurple),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildimage(Map<String, dynamic> content) {
    return Container(
      height: 60,
      width: 70,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: (content["product"]["category"].toString() == "search"
                  ? NetworkImage(content["product"]["image"].toString())
                  : AssetImage(content["product"]["image"].toString())
                      as ImageProvider),
              fit: BoxFit.contain),
          shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 3)
        ],
      color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.purple,
        ),
        title: const Text(
          "Past Baskets",
          style: TextStyle(
            color: Colors.purple,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (final basket in widget.baskets) _buildCard(basket),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
