import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:flutter/material.dart';
import 'package:Talks/utils/themeColor.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.leftIcon,
    required this.buttonText,
    required this.onPressed,
    required this.IconColor,
  });
  final leftIcon;
  final buttonText;
  final onPressed;
  final IconColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
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
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: IconColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      leftIcon,
                      size: 20,
                      color: IconColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: VerticalDivider(
                      width: 20,
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  Text(
                    buttonText,
                    style: ThemTextStyles.ButtonsTextStyle(context),
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
        ],
      ),
    );
  }
}
