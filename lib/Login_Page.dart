// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unnecessary_string_interpolations, use_build_context_synchronously, avoid_unnecessary_containers

import "package:Talks/services/auth_Service.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:Talks/Chat_Page.dart";
import "package:Talks/utils/spaces.dart";
import "package:Talks/utils/textFeilds_styles.dart";
import "package:Talks/widgets/LoginTextField.dart";
import "package:flutter/widgets.dart";
import "package:provider/provider.dart";
import "package:social_media_buttons/social_media_button.dart";
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> loginUser(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await context.read<AuthService>().loginUser(userNameController.text);
      Navigator.pushReplacementNamed(context, '/chatPage',
          arguments: '${userNameController.text}');
    } else {
      print('not successful');
    }
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Let\'s you sign in!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.deepPurple,
          ),
        ),
        Column(
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.deepPurple,
              ),
            ),
            Text(
              'You\'ve been missed!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.deepPurple,
              ),
            )
          ],
        ),
        Container(
          child: Image.network(
            'https://img.freepik.com/free-vector/my-password-concept-illustration_114360-4294.jpg?w=740&t=st=1715519845~exp=1715520445~hmac=15446596c1cd2c30f44e7244bded01965bd17b283488e0656e5be8384bcb5220',
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
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onDoubleTap: () {
            print("DoubleTap pressing");
          },
          onTap: () async {
            if (!await launchUrl(Uri.parse('https://google.com'))) {
              throw Exception('Could not launch Url');
            }
            print('onTap');
          },
          onLongPress: () {
            print('LongPress');
          },
          child: Column(
            children: [
              Text('LinkedIn'),
              Text('https://google.com'),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialMediaButton.twitter(
              color: Colors.blue,
              url: 'https://www.twitter.com',
            ),
            SocialMediaButton.instagram(
              color: Colors.purple,
              url: 'https://www.instagram.com',
            ),
            SocialMediaButton.linkedin(
              color: Colors.blueAccent,
              url: 'https://www.linkedin.com/in/johnwesly-u-a440ab215/',
            ),
          ],
        )
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
