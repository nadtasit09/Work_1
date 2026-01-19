import 'package:flutter/material.dart';
import 'food_item1.dart';
import 'foods/food1.dart';
import 'foods/food2.dart';
import 'foods/food3.dart';
import 'foods/food4.dart';
import 'foods/food5.dart';
import 'foods/food6.dart';
import 'foods/food7.dart';
import 'foods/food8.dart';

class IngredientPage extends StatelessWidget {
  final List<FoodItem> foods = [
    food1, food2, food3, food4, food5, food6, food7, food8
  ];

  IngredientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('วัตถุดิบ/สูตรอาหาร'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(food.recipe, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
