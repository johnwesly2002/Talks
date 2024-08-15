import 'package:Talks/database/database.dart';
import 'package:Talks/modals/userModal.dart';
import 'package:Talks/utils/spaces.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/LoginTextField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Talks/utils/texts.dart';

class signupPage extends StatefulWidget {
  const signupPage({Key? key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  final _formKey = GlobalKey<FormState>();

  final PhoneNumberController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final db = TalksDatabase();
  //signup Method
  Future<void> SignupUser() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      var response = await db
          .signup(Users(
              usrName: userNameController.text,
              usrPassword: passwordController.text,
              usrPhoneNumber: PhoneNumberController.text))
          .whenComplete(() {
        Navigator.pushReplacementNamed(context, '/loginPage');
      });
    } else {
      Fluttertoast.showToast(
          msg: "Signup Failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget _SignupHeader() {
    return Column(
      children: [
        Container(
          child: Image.asset(
            'assets/TalksLogo.png',
            height: 200,
            width: 200,
          ),
        ),
      ],
    );
  }

  Widget _SignupForm(context) {
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
                      return 'Please fill the PhoneNumber';
                    } else if (value.length < 5) {
                      return 'Your PhoneNumber should be more than 10 digits';
                    }
                    return null;
                  },
                  controller: PhoneNumberController,
                  hintText: 'PhoneNumber',
                  obscureText: false,
                  iconName: Icon(Icons.phone),
                ),
                verticalSpacing(10),
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
                verticalSpacing(10),
                LoginTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill the Password';
                    } else if (value.length < 5) {
                      return 'Your Password should be more than 5 characters';
                    }
                    return null;
                  },
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  iconName: Icon(Icons.lock),
                ),
                verticalSpacing(10),
                LoginTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill the ConfirmPassword';
                    } else if (value.length < 5) {
                      return 'Your ConfirmPassword should be more than 5 characters';
                    }
                    return null;
                  },
                  controller: confirmpasswordController,
                  hintText: 'ConfirmPassword',
                  obscureText: true,
                  iconName: Icon(Icons.lock),
                ),
              ],
            )),
        verticalSpacing(16),
        ElevatedButton(
          onPressed: () async {
            await SignupUser();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: const Text(
            'Signup',
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

  Widget _SignupFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(HeadingText.signuptoLoginText,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w300))),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacementNamed(context, '/loginPage');
                    print('onTap');
                  },
                  child: Text(
                    HeadingText.signuptoLoginText2,
                    style: ThemTextStyles.SingupAccountHeadingStyles,
                  ),
                )
              ],
            ),
          ],
        ),
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
                            _SignupHeader(),
                            _SignupFooter(),
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(child: _SignupForm(context)),
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
                    _SignupHeader(),
                    _SignupForm(context),
                    SizedBox(height: 32),
                    _SignupFooter(),
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
