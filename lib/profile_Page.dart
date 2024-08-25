import 'package:Talks/ThemesPage.dart';
import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/services/firebase_Firestore_service.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:Talks/utils/themeColor.dart';

// ignore: camel_case_types
class profilePage extends StatefulWidget {
  const profilePage({super.key, required this.currentUser});
  final ChatUserModal? currentUser;
  @override
  State<profilePage> createState() => _profilePageState();
}

// ignore: camel_case_types
class _profilePageState extends State<profilePage> {
  late TextEditingController _emailController;
  late TextEditingController _joinedDateController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentUser!.email);
    _nameController = TextEditingController(text: widget.currentUser!.name);
    _joinedDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.currentUser!.lastActive));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _joinedDateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      setState(() {
        widget.currentUser!.name = _nameController.text;
        widget.currentUser!.email = _emailController.text;
      });
      // Update the Firestore database
      await FirebaseFirestoreService.updateUserInformation({
        'email': widget.currentUser!.email,
        'name': widget.currentUser!.name,
      });

      // Show a confirmation message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      // Show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  void _navigateToThemes() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ThemeSelector();
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set width to 80% of the screen
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: themeColor.primaryColor(context),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Confirm Logout',
                  style: ThemTextStyles.HeadingStyles(context),
                ),
                const SizedBox(height: 20),
                Text(
                  'Are you sure you want to logout?',
                  style: ThemTextStyles.ProfileHeading(context),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: themeColor.grey(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              color: Colors.white), // Text color
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text(
                          'Cancel',
                          style: ThemTextStyles.LogoutButtonsStyle(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                        color: themeColor.primaryColor(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: _logOut,
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.white),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text(
                          'Yes, Logout',
                          style: ThemTextStyles.LogoutButtonsStyle(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logOut() {
    FirebaseAuth.instance.signOut();
    FirebaseFirestoreService.updateUserInformation({'isOnline': false});
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talks Profile',
          style: ThemTextStyles.HeadingStyles(context),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Stack(children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.currentUser!.image),
                radius: 30,
              )
            ]),
            title: Text(
              widget.currentUser!.name,
              style: ThemTextStyles.homePageUsersText(context),
            ),
            subtitle: Text(
              widget.currentUser!.email,
              maxLines: 2,
              style: ThemTextStyles.ProfileEmailText(context),
            ),
            trailing: GestureDetector(
              onTap: () {
                _showEditModal(context);
              },
              child: Container(
                width: 65,
                height: 35,
                decoration: BoxDecoration(
                  color: themeColor.primaryColor(context),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: themeColor.chatInputIconsColor(context),
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: ThemTextStyles.ProfileEditText(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Personalize Your Profile Section
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Personalization',
                style: ThemTextStyles.ProfileHeading(context),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: themeColor.TextFieldColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                CustomButton(
                  leftIcon: Icons.nights_stay_rounded,
                  buttonText: 'Themes',
                  onPressed: _navigateToThemes,
                  IconColor: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  leftIcon: Icons.notifications,
                  buttonText: 'Notifications',
                  onPressed: _navigateToThemes,
                  IconColor: Colors.blue,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  leftIcon: Icons.language,
                  buttonText: 'Languages',
                  onPressed: _navigateToThemes,
                  IconColor: Colors.orange,
                ),
              ],
            ),
          ),

          // Help & Feedback Section
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Text(
                'Help & Feedback',
                style: ThemTextStyles.ProfileHeading(context),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: themeColor.TextFieldColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomButton(
              leftIcon: Icons.help,
              buttonText: 'Help',
              onPressed: _navigateToThemes,
              IconColor: Colors.green,
            ),
          ),

          // Account Section
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Text(
                'Account',
                style: ThemTextStyles.ProfileHeading(context),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: themeColor.TextFieldColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomButton(
              leftIcon: Icons.logout,
              buttonText: 'Logout',
              onPressed: _confirmLogout,
              IconColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: themeColor.TextFieldColor(context),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'UserName',
                    icon: Icon(Icons.person),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: themeColor.TextFieldColor(context),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email_rounded),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => themeColor.primaryColor(context)),
                  ),
                  onPressed: () {
                    // Save the changes
                    _updateProfile();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: ThemTextStyles.ProfileSaveText(context),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
