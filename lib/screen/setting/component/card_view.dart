import 'package:flutter/material.dart';
import 'package:watherapp/widget/csutom_image.dart';

class CardView extends StatelessWidget {
  final String image;
  final String title;
  final String value;

  const CardView({super.key, required this.image, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     // blurRadius: 3,
        //     color: Colors.grey.shade900,
        //     // blurStyle: BlurStyle.inner,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: CustomImage(path: image, height: 20,color: Colors.white,),
          ),
          const SizedBox(width: 8),
          Text(
            "$title",
            style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontWeight: FontWeight.w500,
            ),
          ),
          // const SizedBox(height: 10),
          Text(
            "$value",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
