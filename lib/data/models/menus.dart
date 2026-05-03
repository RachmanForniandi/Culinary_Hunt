import 'package:culinary_hunt/data/models/category.dart';
class Menus {
  List<Category>? foods;
  List<Category>? drinks;

  Menus({this.foods, this.drinks});

  factory Menus.fromMap(Map<String, dynamic> json) => Menus(
    foods: json["foods"] == null
        ? []
        : List<Category>.from(
        json["foods"].map((x) => Category.fromMap(x))),
    drinks: json["drinks"] == null
        ? []
        : List<Category>.from(
        json["drinks"].map((x) => Category.fromMap(x))),
  );
}