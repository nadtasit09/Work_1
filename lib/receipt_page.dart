import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_item1.dart';
import 'package:intl/intl.dart';
import 'category_page.dart';

class ReceiptPage extends StatelessWidget {
  final Map<FoodItem, int> cart;

  const ReceiptPage({super.key, required this.cart});

  Future<void> saveOrderToFirebase() async {
    try {
      final now = DateTime.now();
      final orderId = now.millisecondsSinceEpoch.toString();
      final orderData = {
        'timestamp': now,
        'items': cart.entries
            .map((e) => {
                  'name': e.key.name,
                  'price': e.key.price,
                  'quantity': e.value,
                  'total': e.key.price * e.value,
                })
            .toList(),
        'totalAmount':
            cart.entries.fold(0, (sum, e) => sum + (e.key.price * e.value)),
      };

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderData);
    } catch (e) {
      debugPrint('Error saving order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = cart.entries.fold(0, (sum, e) => sum + e.key.price * e.value);
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    return Scaffold(
      appBar: AppBar(
          title: const Text('ใบเสร็จ'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('วันที่: $formattedDate',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: cart.entries.map((e) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(e.key.name),
                      subtitle: Text('จำนวน ${e.value}'),
                      trailing: Text('${e.key.price * e.value} บาท'),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('รวมทั้งหมด',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('$total บาท',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await saveOrderToFirebase(); // บันทึก Firebase
                  cart.clear(); // เคลียร์ตะกร้า

                  // แสดง snackbar ยืนยัน
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('สั่งซื้อสำเร็จ'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // รอให้ snackbar แสดงก่อน
                  await Future.delayed(const Duration(seconds: 2));

                  // กลับหน้า CategoryPage และลบ stack หน้าเก่า
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'สำเร็จ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
