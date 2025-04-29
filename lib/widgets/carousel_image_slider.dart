import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/product_detail_controller.dart';
import 'package:product_catelog_app/widgets/cache_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildImages(List<String> images,) {
  final ProductDetailController productDetailController = Get.find();
  final CarouselSliderController carouselSliderController = CarouselSliderController();
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          carouselController: carouselSliderController,
          options: CarouselOptions(
            height: 250,
            pageSnapping: true,
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              productDetailController.imageIndex.value = index;
            },
          ),
          items: images.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: const Offset(0, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: buildNetworkImage(imageUrl: url,width : 250.0, height : 250.0,)

                // Image.network(
                //   url,
                //   fit: BoxFit.contain,
                //   width: double.infinity,
                //   loadingBuilder: (context, child, progress) {
                //     if (progress == null) return child;
                //     return const Center(
                //       child: Skeletonizer(
                //         enabled: true,
                //         child: SizedBox(
                //           height: 250,
                //           width: double.infinity,
                //         ),
                //       ),
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Icon(Icons.broken_image);
                //   },
                // ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
