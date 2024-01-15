class Order {
  final int id;
  final int uid;
  final int itemId;
  final String itemTitle;
  final int itemPrice;
  final String itemCover;
  final int quantity;
  final int amount;
  final int createdAt;

  const Order({
    required this.id,
    required this.uid,
    required this.itemId,
    required this.itemTitle,
    required this.itemPrice,
    required this.itemCover,
    required this.quantity,
    required this.amount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        uid: json['uid'],
        itemId: json['item_id'],
        itemTitle: json['item_title'],
        itemPrice: json['item_price'],
        itemCover: json['item_cover'],
        quantity: json['quantity'],
        amount: json['amount'],
        createdAt: json['created_at'],
      );
}
