import 'package:flutter/material.dart';
import 'home_page.dart';
import 'food_item1.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<FoodItem, int> cart = {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกประเภทอาหาร'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              title: 'อาหารคาว',
              icon: Icons.restaurant,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      category: 'คาว',
                      cart: cart,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              title: 'อาหารหวาน',
              icon: Icons.cake,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      category: 'หวาน',
                      cart: cart,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(title, style: const TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
