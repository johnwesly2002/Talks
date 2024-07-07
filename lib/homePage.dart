import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/services/firebase_Firestore_service.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/UserItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Talks", style: ThemTextStyles.HeadingStyles),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                FirebaseFirestoreService.updateUserInformation(
                  {'isOnline': false},
                );
                Navigator.pushReplacementNamed(context, '/loginPage');
              },
              icon: const Icon(Icons.logout, color: Colors.black))
        ],
      ),
      body: Consumer<FirebaseProvider>(builder: (context, value, child) {
        return ListView.separated(
          itemCount: value.users.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              value.users[index].uid != FirebaseAuth.instance.currentUser?.uid
                  ? UserItem(user: value.users[index])
                  : const SizedBox(),
        );
      }),
    );
  }
}
