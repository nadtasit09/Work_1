import 'package:flutter/material.dart';
import 'food_item1.dart';
import 'receipt_page.dart';

class CalcPage extends StatelessWidget {
  final Map<FoodItem, int> cart; // รับ cart จาก HomePage

  const CalcPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    // คำนวณ total
    final total =
        cart.entries.fold<int>(0, (sum, e) => sum + e.key.price * e.value);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('หน้าคิดเงิน'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('ตะกร้าว่าง'))
                  : ListView(
                      children: cart.entries.map((e) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            title: Text(e.key.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text('จำนวน ${e.value} รายการ'),
                            trailing: Text('${e.key.price * e.value} บาท',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('รวมทั้งหมด',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('$total บาท',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cart.isEmpty
                          ? null
                          : () {
                              // ไปหน้า ReceiptPage พร้อมส่ง cart
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => ReceiptPage(cart: cart)),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text('ชำระเงิน',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
