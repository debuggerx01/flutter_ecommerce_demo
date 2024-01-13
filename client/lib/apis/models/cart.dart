class Cart {
  final int id;
  final int uid;
  final int itemId;
  final int updatedAt;
  final int quantity;
  final int price;
  final String title;

  const Cart({
    required this.id,
    required this.uid,
    required this.itemId,
    required this.updatedAt,
    required this.quantity,
    required this.price,
    required this.title,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json['id'] as int,
        uid: json['uid'] as int,
        itemId: json['item_id'] as int,
        updatedAt: json['updated_at'] as int,
        quantity: json['quantity'] as int,
        price: json['price'] as int,
        title: json['title'] as String,
      );
}