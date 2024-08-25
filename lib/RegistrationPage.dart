import 'dart:io';

import 'package:Talks/modals/signupUserModal.dart';
import 'package:Talks/widgets/emptyChatWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:Talks/utils/themeColor.dart';
import 'package:Talks/utils/textFeilds_styles.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  File? _profileImageFile;
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  int _currentPage = 0;
  bool get isProfileImageSelected => _profileImageFile != null;
  bool get isNameFilled => _nameController.text.isNotEmpty;
  bool get isEmailFilled => _emailController.text.isNotEmpty;
  bool get isPasswordFilled => _passwordController.text.isNotEmpty;

  bool get canProceed {
    switch (_currentPage) {
      case 0:
        return isProfileImageSelected;
      case 1:
        return isNameFilled;
      case 2:
        return isEmailFilled;
      case 3:
        return isPasswordFilled;
      default:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    setState(() {
      _currentPage = _pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talks',
          style: ThemTextStyles.HeadingStyles(context),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: canProceed
                ? BouncingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildProfileImagePage(),
              _buildNamePage(),
              _buildEmailPage(),
              _buildPasswordPage(),
              _buildReviewPage(),
            ],
          ),
          if (_isLoading)
            // Center(
            //   child: Container(
            //     child: Lottie.asset(
            //       'assets/TalksLoadingAnimation.json',
            //       width: 350,
            //       height: 350,
            //     ),
            //   ),
            // ),
            const EmptyWidget(
                icon: 'assets/TalksLoadingAnimation.json', text: 'Loading...')
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: themeColor.chatInputIconsColor(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _currentPage > 0
                ? TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text(
                      'Back',
                      style: ThemTextStyles.HeadingStyles(context),
                    ),
                  )
                : SizedBox.shrink(),
            _currentPage < 4
                ? Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: canProceed
                          ? themeColor.primaryColor(context)
                          : themeColor.chatInputColor(context),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: canProceed
                          ? () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                              );
                            }
                          : null,
                      child: Text(
                        'Next',
                        style: ThemTextStyles.RegistrationText(context),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      bottomSheet: _buildPageIndicator(),
    );
  }

  Widget _buildProfileImagePage() {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personalize your account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'with a profile picture.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: _profileImageFile != null
                          ? FileImage(_profileImageFile!)
                          : const AssetImage('assets/profileimage.jpg')
                              as ImageProvider,
                    ),
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.add_a_photo,
                          size: 33,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNamePage() {
    return Stack(children: [
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Every journey starts with a name',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'What\'s yours?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeColor.TextFieldColor(context),
            ),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'username',
                border: InputBorder.none,
              ),
              onChanged: (_) => _updateState(),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildEmailPage() {
    return Stack(children: [
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s stay in touch!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'What\'s your email?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeColor.TextFieldColor(context),
            ),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email Id',
                border: InputBorder.none,
              ),
              onChanged: (_) => _updateState(),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildPasswordPage() {
    return Stack(children: [
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s your key ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'to joining us?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeColor.TextFieldColor(context),
            ),
            child: TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: InputBorder.none,
              ),
              onChanged: (_) => _updateState(),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildReviewPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to dive in?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sign up now!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: _profileImageFile != null
                            ? FileImage(_profileImageFile!)
                            : const AssetImage('assets/profileimage.jpg')
                                as ImageProvider,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${_nameController.text}',
                        style: ThemTextStyles.HeadingStyles(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: canProceed
                  ? themeColor.primaryColor(context)
                  : themeColor.chatInputColor(context),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextButton(
              onPressed: canProceed ? _registerUser : null,
              child: Text(
                'Signup',
                style: ThemTextStyles.RegistrationText(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return DotsIndicator(
      dotsCount: 5,
      position: _currentPage.toDouble(),
      decorator: DotsDecorator(
        activeColor: themeColor.primaryColor(context),
        color: Colors.grey,
        size: const Size.square(8.0),
        activeSize: const Size(18.0, 9.0),
        spacing: const EdgeInsets.symmetric(horizontal: 4.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImageFile = File(image.path);
      });
    }
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user!.uid;

      String? imageUrl;
      if (_profileImageFile != null) {
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
        UploadTask uploadTask = storageRef.putFile(_profileImageFile!);
        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      final SignupUserModal newUser = SignupUserModal(
        uid: uid,
        name: name,
        email: email,
        password: password,
        image: imageUrl,
        lastActive: DateTime.now(),
        isOnline: true,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newUser.toJson());

      Navigator.pushReplacementNamed(context, '/homePage');
    } catch (e) {
      print('Error registering user: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
