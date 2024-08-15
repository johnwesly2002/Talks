import 'package:Talks/ThemesPage.dart';
import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/services/firebase_Firestore_service.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Talks/utils/themeColor.dart';

class profilePage extends StatefulWidget {
  profilePage({super.key, required this.currentUser});
  final ChatUserModal? currentUser;
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late TextEditingController _emailController;
  late TextEditingController _joinedDateController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController =
        TextEditingController(text: widget.currentUser!.email ?? '');
    _nameController =
        TextEditingController(text: widget.currentUser!.name ?? '');
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  void _navigateToThemes() {
    Navigator.pushNamed(context, '/themeSelector');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talks Profile',
          style: ThemTextStyles.HeadingStyles,
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
              style: ThemTextStyles.homePageUsersText,
            ),
            subtitle: Text(
              widget.currentUser!.email,
              maxLines: 2,
              style: ThemTextStyles.ProfileEmailText,
            ),
            trailing: GestureDetector(
              onTap: () {
                _showEditModal(context);
              },
              child: Container(
                width: 65,
                height: 35,
                decoration: BoxDecoration(
                  color: themeColor.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: themeColor.chatInputIconsColor,
                      size: 15,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: ThemTextStyles.ProfileEditText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            leftIcon: Icons.nights_stay_rounded,
            buttonText: 'Themes',
            onPressed: _navigateToThemes,
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
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: themeColor.TextFieldColor,
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
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: themeColor.TextFieldColor,
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
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => themeColor.primaryColor),
                  ),
                  onPressed: () {
                    // Save the changes
                    _updateProfile();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: ThemTextStyles.ProfileSaveText,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
