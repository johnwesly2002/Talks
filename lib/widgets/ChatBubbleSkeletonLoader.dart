import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatBubbleSkeletonLoader extends StatelessWidget {
  const ChatBubbleSkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 150,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.zero,
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 30,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 5),
              Container(
                width: 150,
                height: 25,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
