// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, depend_on_referenced_packages, library_prefixes
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import '../components/gradiantText.dart';
import '../models/product_model.dart';
import '../models/stores_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.products});

  final List<ProductModel> products; //Ürün listesi

  @override
  _MapPageViewState createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late GoogleMapController mapController; //Harita controller'ı
  Set<Marker> markers = {}; //Harite markerları

  //Kullanıcının konumu (enlem, boylam)
  late Position _currentPosition;

  List<Store> stores = []; //Tüm mağazalar
  List<String> storeNamelist = []; //Sepetteki mağazaların isimleri
  List<Store> closestStores = []; //En yakındaki mağazalar

  //CircleProgressIndicator'ün gösteilmesini kontrol eden değer
  bool isLoading = true;

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  //Harita üzerindeki markerları döndürür
  Future<BitmapDescriptor> _getStoreBitmapIcon(String name) async {
    if (name.contains("vatan")) {
      return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/marker_vatan.png",
      );
    } else if (name.contains("itopya")) {
      return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/marker_itopya.png",
      );
    } else if (name.contains("teknosa")) {
      return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/marker_teknosa.png",
      );
    } else if (name.contains("media markt")) {
      return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/marker_mediamarkt.png",
      );
    }

    return BitmapDescriptor.defaultMarker;
  }

  //Harita üzerine markerları ekler ve polyline çizmesi için createPolylines'ı çağırır
  Future<bool> _setupMarkersAndDrawPolylines() async {
    try {
      Marker startMarker;

      for (int index = 0; index < closestStores.length - 1; index++) {
        var startLat = double.parse(closestStores[index].latitude);
        var startLong = double.parse(closestStores[index].longitude);

        startMarker = Marker(
            markerId: MarkerId(index.toString()),
            position: LatLng(startLat, startLong),
            infoWindow: InfoWindow(
              title: closestStores[index].name,
              snippet: closestStores[index].address,
            ),
            icon: await _getStoreBitmapIcon(closestStores[index].name));

        markers.add(startMarker);

        await _createPolylines(index, index + 1);
      }

      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return false;
  }

  /*
    Hesaplama sonucunda en yakındaki bulunan marketlerin indexleri verilir. 
    Bu 2 nokta arasında Google Directions API sayesinde rota bulunur.
    Rotanın polyline noktaları arasında çizgiler çizdirilir ve polyline oluşturulur.
  */
  Future _createPolylines(int startIndex, int endIndex) async {
    var startLat = double.parse(closestStores[startIndex].latitude);
    var startLong = double.parse(closestStores[startIndex].longitude);

    var endLat = double.parse(closestStores[endIndex].latitude);
    var endLong = double.parse(closestStores[endIndex].longitude);

    polylinePoints = PolylinePoints();

    //Google Direction API'ye 2 nokta arasında rota bulması için istek atılır,
    //Sonuç result değerinde tutulur
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCHeCkv14TSN02WunbYwJqp4jV5etix6LM", //Google API KEY
      PointLatLng(startLat, startLong),
      PointLatLng(endLat, endLong),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId("polyline");

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.purple,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
  }

  Future _showRoute() async {
    setState(() {
      if (markers.isNotEmpty) markers.clear();
      if (polylines.isNotEmpty) polylines.clear();
      if (polylineCoordinates.isNotEmpty) polylineCoordinates.clear();
    });

    _setupMarkersAndDrawPolylines().then((isSuccess) {
      if (isSuccess) {
        setState(() {
          //CircularProgressIndicator gizlenir, harita gösterilir
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Route is ready'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Route is failure'),
        ));
      }
    });
  }

  //Ürünlerin bulunduğu mağaza isimlerini bulur
  Future _findStoreNames() async {
    for (var product in widget.products) {
      if (storeNamelist.contains(product.vendor) == false) {
        storeNamelist.add(product.vendor);
      }
    }
    print(storeNamelist);
  }

  //Sqlite veritabanından tüm mağazaları çeker
  Future _getStores() async {
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'techpack_database.db'),
    );

    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('stores');

    stores = List.generate(
      maps.length,
      (i) {
        return Store(
          id: maps[i]['id'],
          name: maps[i]['name'],
          latitude: maps[i]['latitude'],
          longitude: maps[i]['longitude'],
          address: maps[i]['address'],
        );
      },
    );
  }

  //Kullanıcının konumunu bulur
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
  }

  //Mapazaların konumunun kullanıcıya olan uzaklığını bulur
  double _coordinateDistance(double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - _currentPosition.latitude) * p) / 2 +
        c(_currentPosition.latitude * p) *
            c(lat2 * p) *
            (1 - c((lon2 - _currentPosition.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  //En yakındaki mağazaları ve kullanıcının konumunu listeye ekler
  Future _determineClosestStores() async {
    for (var storeName in storeNamelist) {
      closestStores.add(findClosestStore(storeName));
    }

    //Bulunan yakınlardaki mağazaları en kısa rota için kullanıcıya uzaklığına göre sıralar
    closestStores.sort((a, b) => b.distance.compareTo(a.distance));

    //Kullanıcı ile en yakınındaki mağaza arasında da polyline çizilebilmesi için eklendi
    closestStores.add(
      Store(
          id: 999,
          name: "My Location",
          latitude: "${_currentPosition.latitude}",
          longitude: "${_currentPosition.longitude}",
          address: ""),
    );
  }

  //En yakındaki mağazayı bulur (vendor: mağaza adı)
  Store findClosestStore(String vendor) {
    double distance = 9999999;
    Store returnStore = stores[0];

    for (var store in stores) {
      if (store.name.contains(vendor)) {
        var storeDistance = _coordinateDistance(
            double.parse(store.latitude), double.parse(store.longitude));
        if (storeDistance < distance) {
          distance = storeDistance;
          returnStore = store;
          returnStore.distance = distance;
        }
      }
    }
    return returnStore;
  }

  @override
  void initState() {
    _findStoreNames().then((value) => {
          _determinePosition().then((value) => {
                _getStores().then((value) => {
                      _determineClosestStores().then((value) => {_showRoute()})
                    })
              })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
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
            "Route",
            style: TextStyle(color: Colors.purple),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 60,
          elevation: 0,
          actions: [
            IconButton(onPressed: (){
              for(int i=0;i<3;i++) {
                Navigator.pop(context);
              }
            }, icon: Icon(Icons.home,color: Colors.purple,))
          ],
        ),
        key: _scaffoldKey,
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(color: Colors.purple),
                      SizedBox(width: 12),
                      GradientText(
                        'Loading',
                        style: TextStyle(fontSize: 26),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 73, 21, 136),
                          Color.fromARGB(255, 190, 118, 202),
                        ]),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      markers: Set<Marker>.from(markers),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      polylines: Set<Polyline>.of(polylines.values),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(closestStores.last.latitude),
                          double.parse(closestStores.last.longitude),
                        ),
                        zoom: 8,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        Timer(Duration(seconds: 1), () {
                          mapController
                              .animateCamera(CameraUpdate.zoomTo(11.5));
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
