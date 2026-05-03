class MenuItem {
  String? name;

  MenuItem({this.name});

  factory MenuItem.fromMap(Map<String, dynamic> json) =>
      MenuItem(name: json["name"]);
}