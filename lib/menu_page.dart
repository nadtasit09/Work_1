// menu_page.dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'food_item1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'distance_map_page.dart'; // import หน้า DistanceMapPage

class MenuPage extends StatefulWidget {
  final FoodItem food;

  const MenuPage({super.key, required this.food});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late YoutubePlayerController _controller;
  bool showVideo = false; // เช็คว่ากดปุ่มแล้ว
  bool videoAvailable = false;

  @override
  void initState() {
    super.initState();
    final videoId = widget.food.videoUrl.isNotEmpty
        ? YoutubePlayer.convertUrlToId(widget.food.videoUrl)
        : null;
    if (videoId != null && videoId.isNotEmpty) {
      videoAvailable = true;
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (videoAvailable) _controller.dispose();
    super.dispose();
  }

  // เปิด Google Maps
  Future<void> _openLocation() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.food.lat},${widget.food.lng}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดแผนที่ได้')),
      );
    }
  }

  void _showRecipeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(widget.food.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.food.recipe),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(widget.food.image, fit: BoxFit.cover),
              const SizedBox(height: 12),
              Text(widget.food.name,
                  style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${widget.food.price} บาท',
                  style: const TextStyle(fontSize: 18, color: Colors.green)),
              const SizedBox(height: 12),
              Text('รายละเอียด:',
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(widget.food.taste, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              // ปุ่ม: วัตถุดิบ/วิธีทำ, คำนวณระยะทาง, เปิด Google Maps
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.menu_book),
                      label: const Text('วัตถุดิบ/วิธีทำ'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
                      onPressed: _showRecipeDialog,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.directions),
                      label: const Text('คำนวณระยะทาง'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DistanceMapPage(food: widget.food),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('เปิด Google Maps'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: _openLocation,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ปุ่มเปิดวิดีโอ
              if (videoAvailable && !showVideo)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text('เปิดวิดีโอวิธีทำ'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange),
                    onPressed: () {
                      setState(() {
                        showVideo = true;
                      });
                    },
                  ),
                ),

              const SizedBox(height: 12),

              // แสดงวิดีโอ
              if (showVideo && videoAvailable)
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.deepOrange,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
