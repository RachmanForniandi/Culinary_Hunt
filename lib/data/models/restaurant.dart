import 'package:culinary_hunt/data/models/category.dart';
import 'package:culinary_hunt/data/models/menus.dart';
import 'package:culinary_hunt/data/models/customer_review.dart';


class Restaurant {
  String? id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  double? rating;

  List<Category>? categories;
  Menus? menus;
  List<CustomerReview>? customerReviews;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.rating,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  factory Restaurant.fromMap(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    address: json["address"], // hanya ada di detail
    pictureId: json["pictureId"],
    rating: json["rating"]?.toDouble(),
    categories: json["categories"] == null
        ? []
        : List<Category>.from(
        json["categories"].map((x) => Category.fromMap(x))),
    menus: json["menus"] == null
        ? null
        : Menus.fromMap(json["menus"]),
    customerReviews: json["customerReviews"] == null
        ? []
        : List<CustomerReview>.from(json["customerReviews"]
        .map((x) => CustomerReview.fromMap(x))),
  );
}