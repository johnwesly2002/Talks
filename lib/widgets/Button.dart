import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:flutter/material.dart';
import 'package:Talks/utils/themeColor.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.leftIcon,
    required this.buttonText,
    required this.onPressed,
  });
  final leftIcon;
  final buttonText;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Icon(
                leftIcon,
                size: 25,
              ),
              const SizedBox(width: 4),
              Text(
                buttonText,
                style: ThemTextStyles.ButtonsTextStyle,
              ),
              const Spacer(), // This will push the second icon to the right
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
