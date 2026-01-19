import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'food_item1.dart';

class MapPage extends StatefulWidget {
  final FoodItem food;

  const MapPage({super.key, required this.food});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double? distanceKm;

  // 🔴 เปิด Google Maps จากลิงก์ ggmap โดยตรง (ไม่แปลงอะไรเลย)
  Future<void> _openMap() async {
    final String gmapLink = widget.food.gmapLink.trim();
    final Uri url = Uri.parse(gmapLink);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิด Google Maps ได้')),
      );
    }
  }

  // 🟢 คำนวณระยะทางจากตำแหน่งปัจจุบัน -> ร้าน
  Future<void> _calculateDistance() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โปรดเปิด Location ของอุปกรณ์')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('สิทธิ์ Location ถูกปฏิเสธ')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location ถูกปฏิเสธถาวร โปรดไปตั้งค่า'),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      widget.food.lat,
      widget.food.lng,
    );

    setState(() {
      distanceKm = distanceInMeters / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ที่ตั้งร้าน ${widget.food.name}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (distanceKm != null)
              Text(
                'ระยะทางจากคุณไปยังร้าน: ${distanceKm!.toStringAsFixed(2)} กม.',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _calculateDistance,
              icon: const Icon(Icons.directions),
              label: const Text('คำนวณระยะทาง'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _openMap,
              icon: const Icon(Icons.map),
              label: const Text('เปิด Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
