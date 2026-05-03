import 'dart:convert';

ReviewRestaurants reviewRestaurantsFromMap(String str) =>
    ReviewRestaurants.fromMap(json.decode(str));

String reviewRestaurantsToMap(ReviewRestaurants data) =>
    json.encode(data.toMap());

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

  Map<String, dynamic> toMap() => {
    "error": error,
    "message": message,
    "customerReviews": customerReviews == null
        ? []
        : List<dynamic>.from(customerReviews!.map((x) => x.toMap())),
  };
}

class CustomerReview {
  String? name;
  String? review;
  String? date;

  CustomerReview({this.name, this.review, this.date});

  factory CustomerReview.fromMap(Map<String, dynamic> json) => CustomerReview(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "review": review,
    "date": date,
  };
}
