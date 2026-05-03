
import 'package:culinary_hunt/data/models/restaurant.dart';

class RestaurantsResponse {
  bool? error;
  String? message;
  int? count;
  List<Restaurant>? restaurants;

  RestaurantsResponse({
    this.error,
    this.message,
    this.count,
    this.restaurants,
  });

  factory RestaurantsResponse.fromMap(Map<String, dynamic> json) =>
      RestaurantsResponse(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromMap(x)),
        ),
      );
}