import 'package:Talks/RegistrationPage.dart';
import 'package:Talks/Signup_Page.dart';
import 'package:Talks/homePage.dart';
import 'package:Talks/onBoardingScreen.dart';
import 'package:Talks/services/auth_Service.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/utils/themeColor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Talks/Chat_Page.dart';
import 'package:Talks/Login_Page.dart';
import 'package:Talks/StatefulEx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => FirebaseProvider()),
    ],
    child: ChatApp(),
  ));
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool _isFirstRun = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
    _checkLoginStatus();
  }

  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    setState(() {
      _isFirstRun = isFirstRun;
    });
  }

  Future<void> _checkLoginStatus() async {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isLoggedIn = authService.isLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      title: 'Talks',
      home: FlutterSplashScreen(
        backgroundColor: Colors.white,
        splashScreenBody: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.0), // Add some padding if needed
                child: Image.asset(
                  'assets/TalksLogo.png',
                  fit: BoxFit
                      .contain, // Make sure the image is contained within its box
                ),
              ),
              Text(
                'Talks',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: themeColor.primaryColor)),
              )
            ],
          ),
        ),
        nextScreen: _isFirstRun
            ? OnboardingScreen(
                onOnboardingComplete: () {
                  setState(() {
                    _isFirstRun = false;
                  });
                },
              )
            : _isLoggedIn
                ? homePage()
                : LoginPage(),
      ),
      routes: {
        '/loginPage': (context) => LoginPage(),
        '/signupPage': (context) => signupPage(),
        '/homePage': (context) => homePage(),
        '/RegistrationPage': (context) => RegistrationPage(),
      },
    );
  }
}
