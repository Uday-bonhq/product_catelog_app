
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';


void showRatingBottomSheet(BuildContext context) {
  int selectedRating = 0;

  Get.bottomSheet(
    Container(
      width: Get.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Rate Your Experience',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StatefulBuilder(
            builder: (context, setState) {
              return RatingStars(
                rating: selectedRating,
                color: Theme.of(context).colorScheme.primary,
                onRatingChanged: (value) {
                  setState(() => selectedRating = value);
                },
              );
            },
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Save or send the rating
              print("Rated: $selectedRating stars");
              Get.back(); // Close bottom sheet
            },
            child: Container(
              width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:  const Center(child: Text('Submit',style: TextStyle(color:AppColors.primary,),))),
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}


class RatingStars extends StatelessWidget {
  final int rating;
  final void Function(int)? onRatingChanged;
  final Color? color;

  const RatingStars({
    Key? key,
    required this.rating,
    this.onRatingChanged,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < rating;
        return IconButton(
          icon: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: primaryColor,
            size: 30,
          ),
          onPressed: onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}
