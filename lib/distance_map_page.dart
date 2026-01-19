import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../food_item1.dart';

class DistanceMapPage extends StatefulWidget {
  final FoodItem food;

  const DistanceMapPage({super.key, required this.food});

  @override
  State<DistanceMapPage> createState() => _DistanceMapPageState();
}

class _DistanceMapPageState extends State<DistanceMapPage> {
  double? currentLat;
  double? currentLng;
  double distance = 0;
  final MapController _mapController = MapController();

  Future<void> _requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โปรดเปิด Location ของอุปกรณ์')),
      );
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<void> _getCurrentPosition() async {
    await _requestPermission();
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double dist = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      widget.food.lat,
      widget.food.lng,
    ) / 1000;

    setState(() {
      currentLat = pos.latitude;
      currentLng = pos.longitude;
      distance = dist;
      _mapController.move(LatLng(currentLat!, currentLng!), 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng targetPoint = LatLng(widget.food.lat, widget.food.lng);

    return Scaffold(
      appBar: AppBar(
        title: Text('แผนที่ ${widget.food.name}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: targetPoint,
                zoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (currentLat != null && currentLng != null)
                      Marker(
                        width: 40,
                        height: 40,
                        point: LatLng(currentLat!, currentLng!),
                        builder: (_) => const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    Marker(
                      width: 40,
                      height: 40,
                      point: targetPoint,
                      builder: (_) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                if (currentLat != null && currentLng != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [
                          LatLng(currentLat!, currentLng!),
                          targetPoint,
                        ],
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Text(
                  currentLat == null
                      ? "กดปุ่มเพื่อดึงตำแหน่งปัจจุบัน"
                      : "ตำแหน่งปัจจุบัน:\nLat: $currentLat\nLng: $currentLng",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "ระยะทาง: ${distance.toStringAsFixed(3)} กม.",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _getCurrentPosition,
                  icon: const Icon(Icons.location_searching),
                  label: const Text("ดึงตำแหน่งปัจจุบัน"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
