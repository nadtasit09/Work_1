import 'package:flutter/material.dart';
import 'food_item1.dart';
import 'menu_page.dart';
import 'calc_page.dart';
import 'foods/food1.dart';
import 'foods/food2.dart';
import 'foods/food3.dart';
import 'foods/food4.dart';
import 'foods/food5.dart';
import 'foods/food6.dart';
import 'foods/food7.dart';
import 'foods/food8.dart';

class HomePage extends StatefulWidget {
  final String category;
  final Map<FoodItem, int> cart;

  const HomePage({super.key, required this.category, required this.cart});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<FoodItem> foods;

  @override
  void initState() {
    super.initState();
    foods = [food1, food2, food3, food4, food5, food6, food7, food8]
        .where((f) => f.type == widget.category)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int totalItem = widget.cart.values.fold(0, (sum, e) => sum + e);

    return Scaffold(
      appBar: AppBar(
        title: Text('อาหาร ${widget.category}'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          final qty = widget.cart[food] ?? 0;

          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(food.image,
                      height: 170, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${food.price} บาท',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('จำนวน'),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: qty > 0
                                    ? () {
                                        setState(() {
                                          widget.cart[food] = qty - 1;
                                          if (widget.cart[food] == 0)
                                            widget.cart.remove(food);
                                        });
                                      }
                                    : null,
                              ),
                              Text('$qty'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    widget.cart[food] = qty + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MenuPage(food: food)),
                          );
                        },
                        child: const Text('ดูรายละเอียด'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: totalItem > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // ส่ง cart ไปยัง CalcPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CalcPage(cart: widget.cart)),
                ).then((_) {
                  setState(() {}); // รีเฟรชจำนวนสินค้า
                });
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text('ตะกร้า ($totalItem)'),
              backgroundColor: Colors.deepOrange,
            )
          : null,
    );
  }
}
