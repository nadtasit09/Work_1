class FoodItem {
  final String name;
  final String shop;
  final double lat;
  final double lng;
  final String image;

  final String taste;
  final String benefit;
  final String gmapLink;

  final int price;

  final String type;
  final String recipe;
  final String videoUrl;

  final String detail; // <-- เพิ่มตรงนี้

  const FoodItem({
    required this.name,
    required this.shop,
    required this.lat,
    required this.lng,
    required this.image,
    required this.taste,
    required this.benefit,
    required this.gmapLink,
    required this.price,
    required this.type,
    required this.recipe,
    required this.videoUrl,
    this.detail = '', // <-- default เป็นว่าง
  });
}
