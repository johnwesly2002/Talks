import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/UserItem.dart';
import 'package:Talks/widgets/emptyChatWidget.dart';
import 'package:Talks/widgets/userSearchWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _userSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talks Search',
          style: ThemTextStyles.userSearchText,
        ),
      ),
      body: Column(
        children: [
          UserSearchWidget(
              controller: _userSearchController,
              hintText: 'Search User',
              obscureText: true,
              iconName: const Icon(Icons.search_rounded)),
          Consumer<FirebaseProvider>(
              builder: (context, value, child) => Expanded(
                  child: _userSearchController.text.isEmpty
                      ? const EmptyWidget(
                          icon: 'assets/searchUsers.json', text: 'Search Users')
                      : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: value.searchUsers.length,
                          itemBuilder: (context, index) =>
                              value.searchUsers[index].uid !=
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? UserItem(user: value.searchUsers[index])
                                  : const SizedBox(),
                        )))
        ],
      ),
    );
  }
}
