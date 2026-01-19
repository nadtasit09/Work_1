import 'package:flutter/material.dart';
import 'food_item1.dart';
import 'video_page.dart';

class VideoListPage extends StatelessWidget {
  final List<FoodItem> foods;

  const VideoListPage({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('วิดีโอวิธีทำอาหาร'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];

          if (food.videoUrl.isEmpty) return const SizedBox();

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                food.image,
                width: 60,
                fit: BoxFit.cover,
              ),
              title: Text(food.name),
              trailing: const Icon(Icons.play_circle_fill,
                  color: Colors.red),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPage(food: food),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
