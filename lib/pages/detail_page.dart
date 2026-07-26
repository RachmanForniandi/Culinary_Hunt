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
class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    Future.microtask(() {
      Provider.of<DetailRestaurantProvider>(
        context,
        listen: false,
      ).fetchDetail(widget.restaurantId).then((_) {
        _animController.forward();
      });
    });
  }
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  String imageUrl(String id) =>
      'https://restaurant-api.dicoding.dev/images/large/$id';
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Consumer<DetailRestaurantProvider>(
        builder: (context, provider, child) {
          if (provider.state is Loading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (provider.state is HasData) {
            final restaurant = provider.detail!.restaurant!;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ── IMAGE HEADER ──────────────────────────────────
                      Stack(
                        children: [
                          Hero(
                            tag: restaurant.id!,
                            child: Image.network(
                              imageUrl(restaurant.pictureId!),
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          /// Gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    isDark
                                        ? const Color(0xFF121212)
                                        : const Color(0xFFF8FAFD),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /// Back button
                          Positioned(
                            top: 44,
                            left: 16,
                            child: _GlassButton(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back_ios_new,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      /// ── CONTENT ───────────────────────────────────────
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// NAME + RATING
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        restaurant.name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _RatingBadge(
                                        rating: restaurant.rating ?? 0.0),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                /// LOCATION
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                        size: 16,
                                        color: colorScheme.primary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${restaurant.city}, ${restaurant.address}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                /// CATEGORIES
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: restaurant.categories!
                                      .map((e) => _CategoryChip(
                                            label: e.name ?? '',
                                            color: colorScheme.primary,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 20),
                                /// DESCRIPTION
                                _SectionTitle(title: 'Description'),
                                const SizedBox(height: 8),
                                Text(
                                  restaurant.description ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        height: 1.6,
                                        color: isDark
                                            ? Colors.grey[300]
                                            : Colors.grey[700],
                                      ),
                                ),
                                const SizedBox(height: 20),
                                /// MENU FOODS
                                _SectionTitle(title: 'Foods'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: restaurant.menus!.foods!
                                      .map((e) => _MenuChip(
                                            label: e.name ?? '',
                                            icon: Icons.restaurant,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                                /// MENU DRINKS
                                _SectionTitle(title: 'Drinks'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: restaurant.menus!.drinks!
                                      .map((e) => _MenuChip(
                                            label: e.name ?? '',
                                            icon: Icons.local_drink,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 24),
                                /// REVIEW SECTION HEADER
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _SectionTitle(title: 'Reviews'),
                                    Text(
                                      '${restaurant.customerReviews?.length ?? 0} reviews',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                /// REVIEW CARDS
                                Column(
                                  children: restaurant.customerReviews!
                                      .map((review) => _ReviewCard(
                                            name: review.name ?? '',
                                            reviewText: review.review ?? '',
                                            date: review.date ?? '',
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 24),
                                /// ADD REVIEW BUTTON (Premium)
                                _AddReviewButton(
                                  onPressed: () => showReviewDialog(context),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (provider.state is Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load data',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  /// REVIEW DIALOG 
  void showReviewDialog(BuildContext context) {
    final nameController = TextEditingController();
    final reviewController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showGeneralDialog(
      context: context,
      barrierLabel: 'Review Dialog',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, secondAnim, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: anim,
            child: _ReviewDialog(
              formKey: formKey,
              nameController: nameController,
              reviewController: reviewController,
              restaurantId: widget.restaurantId,
            ),
          ),
        );
      },
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE COMPONENT WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassButton({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }
}
class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB300)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$rating',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryChip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
class _MenuChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _MenuChip({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600]),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
class _ReviewCard extends StatelessWidget {
  final String name;
  final String reviewText;
  final String date;
  const _ReviewCard({
    required this.name,
    required this.reviewText,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    // Generate avatar color from name
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6584),
      const Color(0xFF43B89C),
      const Color(0xFFFF8C42),
      const Color(0xFF2979FF),
    ];
    final avatarColor = colors[name.hashCode.abs() % colors.length];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  reviewText,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _AddReviewButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AddReviewButton({required this.onPressed});
  @override
  State<_AddReviewButton> createState() => _AddReviewButtonState();
}
class _AddReviewButtonState extends State<_AddReviewButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2979FF), Color(0xFF00B8D4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2979FF).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rate_review_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Write a Review',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// REVIEW DIALOG
// ─────────────────────────────────────────────────────────────────────────────
class _ReviewDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController reviewController;
  final String restaurantId;
  const _ReviewDialog({
    required this.formKey,
    required this.nameController,
    required this.reviewController,
    required this.restaurantId,
  });
  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}
class _ReviewDialogState extends State<_ReviewDialog> {
  bool _isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.15),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2979FF), Color(0xFF00B8D4)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.rate_review_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write a Review',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Share your experience',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                    ),
                    /// Close
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.grey.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 18,
                            color:
                                isDark ? Colors.grey[300] : Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                /// Name field
                _StyledTextField(
                  controller: widget.nameController,
                  label: 'Your Name',
                  hint: 'Enter your name...',
                  icon: Icons.person_outline_rounded,
                  isDark: isDark,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                /// Review field
                _StyledTextField(
                  controller: widget.reviewController,
                  label: 'Your Review',
                  hint: 'Tell others what you think...',
                  icon: Icons.chat_bubble_outline_rounded,
                  isDark: isDark,
                  maxLines: 4,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Review is required' : null,
                ),
                const SizedBox(height: 28),
                /// Action buttons
                Row(
                  children: [
                    /// Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _isSubmitting ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    /// Submit
                    Expanded(
                      flex: 2,
                      child: _isSubmitting
                          ? Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2979FF),
                                    Color(0xFF00B8D4)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => _submitReview(context),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2979FF),
                                      Color(0xFF00B8D4)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary
                                          .withOpacity(0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Submit Review',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _submitReview(BuildContext context) async {
    if (!widget.formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final provider =
        Provider.of<DetailRestaurantProvider>(context, listen: false);
    try {
      await provider.addReview(
        id: widget.restaurantId,
        name: widget.nameController.text.trim(),
        review: widget.reviewController.text.trim(),
      );
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Review submitted successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF2979FF),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isDark;
  final int maxLines;
  final String? Function(String?)? validator;
  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    this.maxLines = 1,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(icon,
                size: 20,
                color: isDark ? Colors.grey[500] : Colors.grey[500]),
            filled: true,
            fillColor: isDark
                ? Colors.white.withOpacity(0.06)
                : const Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF2979FF),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

