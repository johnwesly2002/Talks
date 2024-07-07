import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onOnboardingComplete;

  const OnboardingScreen({super.key, required this.onOnboardingComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardingData {
  final String imagePath;
  final String title;
  final String desc;

  OnboardingData({
    required this.imagePath,
    required this.title,
    required this.desc,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      imagePath: "assets/onboardingImage3.png",
      title: "Messaging",
      desc: "In a world full of noise, a simple message can create harmony",
    ),
    OnboardingData(
      imagePath: "assets/onboardingImage2.png",
      title: "Build",
      desc:
          "In every message, there's an opportunity to build a connection that lasts",
    ),
    OnboardingData(
      imagePath: "assets/onboardingImage1.png",
      title: "Enjoy",
      desc: "Tap, type, connect – the rhythm of modern relationships.",
    ),
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingPage(
                  imagePath: data.imagePath,
                  title: data.title,
                  desc: data.desc,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => _buildPageIndicator(_currentPage == index),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              minimumSize: Size(300, 50),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isFirstRun', false);
              Navigator.pushReplacementNamed(context, '/RegistrationPage');
            },
            child: Text(
              'Get Started',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage ? Colors.blue : Colors.grey.withOpacity(0.5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String desc;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 200),
          SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
