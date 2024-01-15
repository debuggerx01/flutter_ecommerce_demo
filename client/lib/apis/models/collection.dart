class Collection {
  final int id;
  final int uid;
  final int itemId;
  final int updatedAt;
  final int price;
  final String title;
  final String cover;

  const Collection({
    required this.id,
    required this.uid,
    required this.itemId,
    required this.updatedAt,
    required this.price,
    required this.title,
    required this.cover,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json['id'] as int,
        uid: json['uid'] as int,
        itemId: json['item_id'] as int,
        updatedAt: json['updated_at'] as int,
        price: json['price'] as int,
        title: json['title'] as String,
        cover: json['cover'] as String,
      );
}
