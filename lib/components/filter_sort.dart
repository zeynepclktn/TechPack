import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5),
                      side: const BorderSide(
                          color: Colors.deepPurple,
                          style: BorderStyle.solid,
                          width: 2))),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8))),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: const Text("Sort",
                      style: TextStyle(color: Colors.deepPurple)),
                ),
                const Icon(Icons.arrow_circle_up, color: Colors.deepPurple)
              ])),
          ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5),
                      side: const BorderSide(
                          color: Colors.deepPurple,
                          style: BorderStyle.solid,
                          width: 2))),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8))),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: const Text(
                    "Filter",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                const Icon(Icons.filter_list, color: Colors.deepPurple)
              ])),
        ],
      ),
    );
  }
}
