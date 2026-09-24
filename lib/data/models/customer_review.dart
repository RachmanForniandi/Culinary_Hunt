class CustomerReview {
  String? name;
  String? review;
  String? date;

  CustomerReview({this.name, this.review, this.date});

  factory CustomerReview.fromMap(Map<String, dynamic> json) =>
      CustomerReview(
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