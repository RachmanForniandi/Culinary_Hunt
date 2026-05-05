import 'package:culinary_hunt/provider/detail_restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/result_state.dart';

class DetailPage extends StatefulWidget {
  final String restaurantId;

  const DetailPage({super.key, required this.restaurantId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailRestaurantProvider>(
        context,
        listen: false,
      ).fetchDetail(widget.restaurantId);
    });
  }

  String imageUrl(String id) =>
      'https://restaurant-api.dicoding.dev/images/large/$id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailRestaurantProvider>(
        builder: (context, provider, child) {
          if (provider.state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state is HasData) {
            final restaurant = provider.detail!.restaurant!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 IMAGE HEADER
                  Stack(
                    children: [
                      Hero(
                        tag: restaurant.id!,
                        child: Image.network(
                          imageUrl(restaurant.pictureId!),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        top: 40,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// 🔥 CONTENT
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME + RATING
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                restaurant.name ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                Text('${restaurant.rating}'),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// LOCATION
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 4),
                            Text('${restaurant.city}, ${restaurant.address}'),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// CATEGORY
                        Wrap(
                          spacing: 8,
                          children: restaurant.categories!
                              .map(
                                (e) => Chip(
                                  label: Text(e.name ?? ''),
                                  backgroundColor: Colors.green,
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 16),

                        /// DESCRIPTION
                        const Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(restaurant.description ?? ''),

                        const SizedBox(height: 16),

                        /// MENU FOODS
                        const Text(
                          'Foods',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          spacing: 8,
                          children: restaurant.menus!.foods!
                              .map((e) => Chip(label: Text(e.name ?? '')))
                              .toList(),
                        ),

                        const SizedBox(height: 12),

                        /// MENU DRINKS
                        const Text(
                          'Drinks',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          spacing: 8,
                          children: restaurant.menus!.drinks!
                              .map((e) => Chip(label: Text(e.name ?? '')))
                              .toList(),
                        ),

                        const SizedBox(height: 20),

                        /// REVIEW TITLE
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// REVIEW LIST
                        Column(
                          children: restaurant.customerReviews!
                              .map(
                                (review) => ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(review.name ?? ''),
                                  subtitle: Text(review.review ?? ''),
                                  trailing: Text(review.date ?? ''),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 20),

                        /// BUTTON REVIEW
                        ElevatedButton(
                          onPressed: () {
                            showReviewDialog(context);
                          },
                          child: const Text('Add Review'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.state is Error) {
            return const Center(child: Text('Failed to load data'));
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// 🔥 DIALOG INPUT REVIEW
  void showReviewDialog(BuildContext context) {
    final nameController = TextEditingController();
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        final provider = Provider.of<DetailRestaurantProvider>(
          context,
          listen: false,
        );

        //final restaurantId = provider.detail?.restaurant?.id ?? '';
        final restaurantId = widget.restaurantId;

        return AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: 'Review'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    reviewController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                if (restaurantId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ID restoran tidak ditemukan'),
                    ),
                  );
                  return;
                }

                try {
                  await provider.addReview(
                    id: restaurantId,
                    name: nameController.text,
                    review: reviewController.text,
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review berhasil dikirim')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
