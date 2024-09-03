import 'package:Talks/RegistrationPage.dart';
import 'package:Talks/Signup_Page.dart';
import 'package:Talks/ThemesPage.dart';
import 'package:Talks/homePage.dart';
import 'package:Talks/onBoardingScreen.dart';
import 'package:Talks/services/Themeprovider.dart';
import 'package:Talks/services/auth_Service.dart';
import 'package:Talks/services/firebase_Firestore_service.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/services/pushNotification_service.dart';
import 'package:Talks/utils/themeColor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Talks/Login_Page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final themeProvider = ThemeProvider();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => themeProvider),
      ChangeNotifierProvider(create: (_) => FirebaseProvider()),
      ChangeNotifierProvider(create: (_) => AuthService())
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
  ThemeData _themeData = ThemeData.light();
  final notificationService = NotificationsService();
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
      FirebaseFirestoreService.updateUserInformation(
        {'isOnline': true},
      );
    });
  }

  void setTheme(ThemeData theme) {
    setState(() {
      _themeData = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      final theme = themeProvider.themeData;
      final splashBackgroundColor = theme.brightness == Brightness.dark
          ? Color.fromARGB(255, 28, 28, 28)
          : Colors.white;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'Talks',
        home: FlutterSplashScreen(
          backgroundColor: splashBackgroundColor,
          splashScreenBody: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/TalksLogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Talks',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: themeColor.primaryColor(context))),
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
          '/themeSelector': (context) => ThemeSelector(),
        },
      );
    });
  }
}
