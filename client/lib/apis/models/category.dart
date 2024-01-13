class Category {
  final int id;
  final String title;

  const Category({
    required this.id,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int,
        title: json['title'] as String,
      );
}
