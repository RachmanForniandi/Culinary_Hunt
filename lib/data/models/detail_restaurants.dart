import 'dart:convert';
import 'category.dart';
import 'menu_item.dart';
import 'customer_review.dart';
import 'package:culinary_hunt/data/models/restaurant.dart';

DetailRestaurants detailRestaurantsFromMap(String str) =>
    DetailRestaurants.fromMap(json.decode(str));

class DetailRestaurants {
  bool? error;
  String? message;
  Restaurant? restaurant;

  DetailRestaurants({
    this.error,
    this.message,
    this.restaurant,
  });

  factory DetailRestaurants.fromMap(Map<String, dynamic> json) =>
      DetailRestaurants(
        error: json["error"],
        message: json["message"],
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromMap(json["restaurant"]),
      );
}



class Menus {
  List<MenuItem>? foods;
  List<MenuItem>? drinks;

  Menus({
    this.foods,
    this.drinks,
  });

  factory Menus.fromMap(Map<String, dynamic> json) => Menus(
        foods: json["foods"] == null
            ? []
            : List<MenuItem>.from(
                json["foods"].map((x) => MenuItem.fromMap(x)),
              ),
        drinks: json["drinks"] == null
            ? []
            : List<MenuItem>.from(
                json["drinks"].map((x) => MenuItem.fromMap(x)),
              ),
      );
}