import 'dart:convert';

import 'package:culinary_hunt/data/models/customer_review.dart';

ReviewRestaurants reviewRestaurantsFromMap(String str) =>
    ReviewRestaurants.fromMap(json.decode(str));

class ReviewRestaurants {
  bool? error;
  String? message;
  List<CustomerReview>? customerReviews;

  ReviewRestaurants({this.error, this.message, this.customerReviews});

  factory ReviewRestaurants.fromMap(Map<String, dynamic> json) =>
      ReviewRestaurants(
        error: json["error"],
        message: json["message"],
        customerReviews: json["customerReviews"] == null
            ? []
            : List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromMap(x)),
              ),
      );
}
