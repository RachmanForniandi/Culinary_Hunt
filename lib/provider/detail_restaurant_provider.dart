import 'package:culinary_hunt/data/api/api_service.dart';
import 'package:culinary_hunt/data/models/detail_restaurants.dart';
import 'package:culinary_hunt/utils/result_state.dart';
import 'package:flutter/material.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailRestaurantProvider(this.apiService);

  ResultState _state = Loading();
  ResultState get state => _state;

  DetailRestaurants? _detail;
  DetailRestaurants? get detail => _detail;

  Future<void> fetchDetail(String id) async {
    try {
      _state = Loading();
      notifyListeners();

      final result = await apiService.getDetailRestaurant(id);

      _detail = result;
      _state = HasData(result);
    } catch (e) {
      _state = Error(e.toString());
    }

    notifyListeners();
  }

  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final result = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );
      final reviews = result.customerReviews ?? [];

      // UPDATE LIST REVIEW TANPA RELOAD
      if (_detail?.restaurant != null) {
        _detail!.restaurant!.customerReviews = List.from(reviews);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('ERROR ADD REVIEW: $e'); //LIHAT ERROR ASLI
      rethrow;
    }
  }
}
