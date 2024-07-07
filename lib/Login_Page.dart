// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unnecessary_string_interpolations, use_build_context_synchronously, avoid_unnecessary_containers

import "package:Talks/database/database.dart";
import "package:Talks/modals/userModal.dart";
import "package:Talks/services/auth_Service.dart";
import "package:Talks/services/firebase_Firestore_service.dart";
import "package:Talks/utils/texts.dart";
import "package:Talks/utils/themeColor.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:Talks/Chat_Page.dart";
import "package:Talks/utils/spaces.dart";
import "package:Talks/utils/textFeilds_styles.dart";
import "package:Talks/widgets/LoginTextField.dart";
import "package:flutter/widgets.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:social_media_buttons/social_media_button.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  final db = TalksDatabase();

  late AnimationController _controller;

  late Animation<double> _animation;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loginUser(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      var response = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userNameController.text.trim(),
          password: passwordController.text.trim());
      await FirebaseFirestoreService.updateUserInformation(
        {'lastActive': DateTime.now()},
      );
      if (response.user != null) {
        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacementNamed(context, '/homePage',
            arguments: '${userNameController.text}');
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      print('not successful');
    }
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   'Let\'s you sign in!',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 30,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 0.5,
        //     color: Colors.deepPurple,
        //   ),
        // ),
        // Column(
        //   children: [
        //     Text(
        //       'Welcome Back!',
        //       style: TextStyle(
        //         fontSize: 15,
        //         fontWeight: FontWeight.bold,
        //         letterSpacing: 0.5,
        //         color: Colors.deepPurple,
        //       ),
        //     ),
        //     Text(
        //       'Let\'s connect world',
        //       style: TextStyle(
        //         fontSize: 15,
        //         fontWeight: FontWeight.bold,
        //         letterSpacing: 0.5,
        //         color: Colors.deepPurple,
        //       ),
        //     )
        //   ],
        // ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: child,
            );
          },
          child: Container(
            child: Image.asset(
              'assets/TalksLogo.png',
              height: 300,
              width: 300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              LoginTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill the UserName';
                  } else if (value.length < 5) {
                    return 'Your username should be more than 5 characters';
                  }
                  return null;
                },
                controller: userNameController,
                hintText: 'Username',
                obscureText: false,
                iconName: Icon(Icons.person),
              ),
              verticalSpacing(18), // Add some spacing between fields
              LoginTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill the Password';
                  } else if (value.length < 5) {
                    return 'Your password should be more than 5 characters';
                  }
                  return null;
                },
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                iconName: Icon(Icons.lock),
              ),
            ],
          ),
        ),
        verticalSpacing(16),
        ElevatedButton(
          onPressed: () async {
            await loginUser(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 3),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(HeadingText.AccountSignupText1,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w300))),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacementNamed(context, '/signupPage');
                    print('onTap');
                  },
                  child: Text(
                    HeadingText.AccountSignupText2,
                    style: ThemTextStyles.SingupAccountHeadingStyles,
                  ),
                )
              ],
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SocialMediaButton.twitter(
        //       color: Colors.blue,
        //       url: 'https://www.twitter.com',
        //     ),
        //     SocialMediaButton.instagram(
        //       color: Colors.purple,
        //       url: 'https://www.instagram.com',
        //     ),
        //     SocialMediaButton.linkedin(
        //       color: Colors.blueAccent,
        //       url: 'https://www.linkedin.com/in/johnwesly-u-a440ab215/',
        //     ),
        //   ],
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                if (constraints.maxWidth > 1000) {
                  return Row(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _buildHeader(),
                            _buildFooter(),
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(child: _buildForm(context)),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    _buildForm(context),
                    SizedBox(height: 32),
                    _buildFooter(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
