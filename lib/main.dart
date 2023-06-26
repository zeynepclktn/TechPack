import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import 'package:techpack/widget_tree.dart';

import 'models/stores_data.dart';
import 'models/stores_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final database = openDatabase(
    Path.join(await getDatabasesPath(), 'techpack_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE stores(id INTEGER PRIMARY KEY, name TEXT, latitude TEXT, longitude TEXT, address TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertStores(List<Store> stores) async {
    final db = await database;

    for (var store in stores) {
      await db.insert(
        'stores',
        store.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Store>> stores() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('stores');

    return List.generate(maps.length, (i) {
      return Store(
        id: maps[i]['id'],
        name: maps[i]['name'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        address: maps[i]['address'],
      );
    });
  }

/*
  Future<void> deleteStore(int id) async {
    final db = await database;

    await db.delete(
      'stores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  */

  await insertStores([
    vatan0,
    vatan1,
    vatan2,
    vatan3,
    vatan4,
    vatan5,
    vatan6,
    vatan7,
    vatan8,
    vatan9,
    vatan10,
    vatan11,
    vatan12,
    vatan13,
    vatan14,
    vatan15,
    vatan16,
    vatan17,
    vatan18,
    vatan19,
    mediamarkt0,
    mediamarkt1,
    mediamarkt2,
    mediamarkt3,
    mediamarkt4,
    mediamarkt5,
    mediamarkt6,
    mediamarkt7,
    mediamarkt8,
    mediamarkt9,
    mediamarkt10,
    mediamarkt11,
    mediamarkt12,
    mediamarkt13,
    mediamarkt14,
    mediamarkt15,
    mediamarkt16,
    mediamarkt17,
    mediamarkt18,
    mediamarkt19,
    itopya0,
    itopya1,
    itopya2,
    itopya3,
    itopya4,
    teknosa0,
    teknosa1,
    teknosa2,
    teknosa3,
    teknosa4,
    teknosa5,
    teknosa6,
    teknosa7,
    teknosa8,
    teknosa9,
    teknosa10,
    teknosa11,
    teknosa12,
    teknosa13,
    teknosa14,
    teknosa15,
    teknosa16,
    teknosa17,
    teknosa18,
    teknosa19,
    teknosa20,
    teknosa21,
    teknosa22,
    teknosa23,
    teknosa24,
    teknosa25,
  ]);

  runApp(MaterialApp(
      title: "tech pack",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WidgetTree()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.asset('assets/images/104314.png'),
            ),
            Expanded(
              flex: 1,
              child: Image.asset('assets/images/Vatan_Computer.jpg'),
            ),
            Expanded(
              flex: 1,
              child: Image.asset('assets/images/TEKnosa.png'),
            ),
            Expanded(
              flex: 2,
              child: Image.asset('assets/logo.jpg'),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
