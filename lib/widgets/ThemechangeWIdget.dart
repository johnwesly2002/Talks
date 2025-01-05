import 'package:flutter/material.dart';

class LightThemeSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 30,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 30,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 30,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

class DarkThemeSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 20,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 30,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 20,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 30,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 20,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 30,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
