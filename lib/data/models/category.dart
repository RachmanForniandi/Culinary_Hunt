class Category {
  String? name;

  Category({this.name});

  factory Category.fromMap(Map<String, dynamic> json) =>
      Category(name: json["name"]);
}