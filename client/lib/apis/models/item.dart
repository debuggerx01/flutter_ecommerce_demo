class Item {
  final int id;
  final int cid;
  final String title;
  final String cover;
  final int price;
  final int? sales;
  final String? content;

  const Item({
    required this.id,
    required this.cid,
    required this.title,
    required this.cover,
    required this.price,
    this.sales,
    this.content,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as int,
        cid: json['cid'] as int,
        title: json['title'] as String,
        cover: json['cover'] as String,
        price: json['price'] as int,
        sales: json['sales'] as int?,
        content: json['content'] as String?,
      );
}
