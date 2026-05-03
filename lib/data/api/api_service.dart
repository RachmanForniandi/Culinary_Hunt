
import 'dart:convert';

import 'package:culinary_hunt/data/models/detail_restaurants.dart';
import 'package:culinary_hunt/data/models/restaurants_response.dart';
import 'package:culinary_hunt/data/models/review_restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantsResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return RestaurantsResponse.fromMap(jsonData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<DetailRestaurants> getDetailRestaurant(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/detail/$id'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return DetailRestaurants.fromMap(jsonData);
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<ReviewRestaurants> postReview({
  required String id,
  required String name,
  required String review,
  }) async {
      final response = await http.post(
        Uri.parse('$baseUrl/review'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": id,
          "name": name,
          "review": review,
        }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ReviewRestaurants.fromMap(jsonData);
    } else {
      throw Exception('Failed to post review');
    }
  }
  
}