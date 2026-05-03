import 'package:culinary_hunt/data/models/restaurant.dart';
class SearchResponse {
  bool? error;
  int? founded;
  List<Restaurant>? restaurants;

  SearchResponse({this.error, this.founded, this.restaurants});

  factory SearchResponse.fromMap(Map<String, dynamic> json) =>
      SearchResponse(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromMap(x)),
        ),
      );
}