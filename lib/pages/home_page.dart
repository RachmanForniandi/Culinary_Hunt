import 'package:culinary_hunt/pages/settings_page.dart';
import 'package:culinary_hunt/pages/detail_page.dart';
import 'package:culinary_hunt/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';

import 'package:culinary_hunt/data/models/restaurant.dart';
import 'package:provider/provider.dart';

import '../utils/result_state.dart';
import '../widgets/item_restaurant.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Restaurant> filteredRestaurants = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        actions: [
          //SETTINGS BUTTON
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<RestaurantProvider>(
        builder:(context, provider, child) {
          if (provider.state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state is HasData) {
            final data = (provider.state as HasData).data;
            final restaurants = data.restaurants;


            if (filteredRestaurants.isEmpty) {
              filteredRestaurants = restaurants;
            }
            if (filteredRestaurants.isEmpty) {
              filteredRestaurants = restaurants;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //HEADER TEXT
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    'Restaurant',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recommendation restaurant for you!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                //SEARCH
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) {
                      searchRestaurant(value, restaurants);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari restoran...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                // LIST / GRID
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        // LIST VIEW
                        return ListView.builder(
                          itemCount: filteredRestaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = filteredRestaurants[index];

                            return InkWell(
                              onTap: () {
                                navigateToDetailPage(restaurant);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    //HERO IMAGE
                                    Hero(
                                      tag: restaurant.id!,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    // TEXT INFO
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              restaurant.name ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              restaurant.city ?? '',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '⭐ ${restaurant.rating}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredRestaurants.length,
                          gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final restaurant = filteredRestaurants[index];

                            return ItemRestaurant(
                              restaurant: restaurant,
                              onTap: () {
                                navigateToDetailPage(restaurant);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void searchRestaurant(String query, List<Restaurant> restaurants) {
    final result = restaurants.where((restaurant) {
      final name = restaurant.name?.toLowerCase() ?? '';
      final city = restaurant.city?.toLowerCase() ?? '';
      final input = query.toLowerCase();

      return name.contains(input) || city.contains(input);
    }).toList();

    setState(() {
      filteredRestaurants = result;
    });
  }

  void navigateToDetailPage(Restaurant restaurant) {
    Navigator.push(
      context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DetailPage(restaurantId: restaurant.id!),

            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween = Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },

          transitionDuration: const Duration(milliseconds: 300),
        ),
    );
  }
}

