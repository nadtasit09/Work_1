import 'package:flutter/material.dart';
import 'food_item1.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _name = TextEditingController();
  final _shop = TextEditingController();
  final _image = TextEditingController();
  final _taste = TextEditingController();
  final _benefit = TextEditingController();
  final _gmap = TextEditingController();
  final _price = TextEditingController();
  final _recipe = TextEditingController();
  final _video = TextEditingController();
  final _detail = TextEditingController();
  final _lat = TextEditingController();
  final _lng = TextEditingController();

  String _type = 'คาว';

  void _saveFood() {
    if (_name.text.isEmpty || _price.text.isEmpty) return;

    final food = FoodItem(
      name: _name.text,
      shop: _shop.text,
      lat: double.tryParse(_lat.text) ?? 0,
      lng: double.tryParse(_lng.text) ?? 0,
      image: _image.text.isEmpty
          ? 'assets/images/no_image.png'
          : _image.text,
      taste: _taste.text,
      benefit: _benefit.text,
      gmapLink: _gmap.text,
      price: int.parse(_price.text),
      type: _type,
      recipe: _recipe.text,
      videoUrl: _video.text,
      detail: _detail.text,
    );

    Navigator.pop(context, food);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเมนูอาหาร'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _input(_name, 'ชื่ออาหาร'),
            _input(_shop, 'ชื่อร้าน'),
            _input(_price, 'ราคา', isNumber: true),

            DropdownButtonFormField(
              value: _type,
              decoration: const InputDecoration(labelText: 'ประเภทอาหาร'),
              items: const [
                DropdownMenuItem(value: 'คาว', child: Text('คาว')),
                DropdownMenuItem(value: 'หวาน', child: Text('หวาน')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),

            _input(_image, 'path รูปภาพ'),
            _input(_taste, 'รสชาติ'),
            _input(_benefit, 'ประโยชน์'),
            _input(_detail, 'รายละเอียด', maxLine: 3),
            _input(_recipe, 'วิธีทำ', maxLine: 4),
            _input(_video, 'ลิงก์วิดีโอ'),
            _input(_gmap, 'Google Map Link'),
            _input(_lat, 'Latitude', isNumber: true),
            _input(_lng, 'Longitude', isNumber: true),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'บันทึกอาหาร',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String label, {
    bool isNumber = false,
    int maxLine = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLine,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
  