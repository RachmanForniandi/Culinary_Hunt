
import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/models/restaurants_response.dart';
import '../utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchRestaurants();
  }

  //STATE
  ResultState _state = Loading();
  ResultState get state => _state;

  //DATA
  RestaurantsResponse? _restaurants;
  RestaurantsResponse? get restaurants => _restaurants;

  //FETCH DATA
  Future<void> fetchRestaurants() async {
    try {
      _state = Loading();
      notifyListeners();

      final result = await apiService.getRestaurantList();

      _restaurants = result;
      _state = HasData(result);

    } catch (e) {
      _state = Error(e.toString());
    }

    notifyListeners();
  }
}