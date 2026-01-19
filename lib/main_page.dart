import 'package:flutter/material.dart';
import 'home_page.dart';
import 'ingredient_page.dart';
import 'map_all_page.dart';
import 'video_list_page.dart';
import 'food_item1.dart';
import 'foods/food1.dart';
import 'foods/food2.dart';
import 'foods/food3.dart';
import 'foods/food4.dart';
import 'foods/food5.dart';
import 'foods/food6.dart';
import 'foods/food7.dart';
import 'foods/food8.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final Map<FoodItem, int> cart = {}; // เก็บจำนวนอาหาร

  late final List<Widget> _pages;
  final List<FoodItem> allFoods = [
    food1, food2, food3, food4, food5, food6, food7, food8
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(category: 'คาว', cart: cart),
      IngredientPage(),
      VideoListPage(foods: allFoods), // ส่งรายการอาหารทั้งหมด
      const MapAllPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'เมนู'),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'วัตถุดิบ'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'วิดีโอ'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'แผนที่'),
        ],
      ),
    );
  }
}
