import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'food_item1.dart';
import 'foods/food1.dart';
import 'foods/food2.dart';
import 'foods/food3.dart';
import 'foods/food4.dart';
import 'foods/food5.dart';
import 'foods/food6.dart';
import 'foods/food7.dart';
import 'foods/food8.dart';

class MapAllPage extends StatefulWidget {
  const MapAllPage({super.key});

  @override
  State<MapAllPage> createState() => _MapAllPageState();
}

class _MapAllPageState extends State<MapAllPage> {
  final List<FoodItem> foods = [
    food1, food2, food3, food4, food5, food6, food7, food8
  ];


  double? currentLat;
  double? currentLng;
  final MapController _mapController = MapController();

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _getCurrentPosition() async {
    await _requestPermission();
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLat = pos.latitude;
      currentLng = pos.longitude;
    });
    if (currentLat != null && currentLng != null) {
      _mapController.move(LatLng(currentLat!, currentLng!), 14);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = foods
        .map(
          (f) => Marker(
            width: 40,
            height: 40,
            point: LatLng(f.lat, f.lng),
            builder: (ctx) => const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        )
        .toList();

    if (currentLat != null && currentLng != null) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(currentLat!, currentLng!),
          builder: (ctx) => const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่ร้านอาหาร'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: currentLat != null && currentLng != null
              ? LatLng(currentLat!, currentLng!)
              : LatLng(18.292, 99.510),
          zoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: markers),
          if (currentLat != null && currentLng != null)
            PolylineLayer(
              polylines: foods
                  .map(
                    (f) => Polyline(
                      points: [
                        LatLng(currentLat!, currentLng!),
                        LatLng(f.lat, f.lng),
                      ],
                      strokeWidth: 2,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentPosition,
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
