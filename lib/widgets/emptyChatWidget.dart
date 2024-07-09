import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              icon,
              width: 200,
              height: 200,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
}
