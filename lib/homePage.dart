import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/profile_Page.dart';
import 'package:Talks/services/firebase_Firestore_service.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/usersSearchScreen.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/UserItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final CurrentUserId = FirebaseAuth.instance.currentUser;
  ChatUserModal? currentUserData;
  @override
  void initState() {
    _currentUserData();
    Provider.of<FirebaseProvider>(context, listen: false)
        .getAllUsers(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  Future<void> _currentUserData() async {
    if (CurrentUserId != null) {
      currentUserData =
          await FirebaseProvider.getCurrentUser(CurrentUserId!.uid);
      setState(() {
        // Set the currentUserData after fetching
        currentUserData = currentUserData;
      });
    }
    print('currentUserData........ ${currentUserData}');
  }

  void _navigateProfilePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => profilePage(
              currentUser: currentUserData,
            )));
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
        title: Text("Talks", style: ThemTextStyles.HeadingStyles),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UserSearchScreen())),
              icon: const Icon(Icons.search_rounded)),
          if (currentUserData != null)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Profile') {
                      _navigateProfilePage();
                    } else if (value == 'Logout') {
                      _logOut();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Profile', 'Logout'}.map((String option) {
                      return PopupMenuItem<String>(
                        child: Row(
                          children: [
                            Icon(
                                option == 'Profile'
                                    ? Icons.person_2_rounded
                                    : Icons.logout_rounded,
                                color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              option,
                              style: ThemTextStyles.MenuOptionsText,
                            ),
                          ],
                        ),
                        value: option,
                      );
                    }).toList();
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  offset: const Offset(0, 40),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(currentUserData!.image),
                  ),
                )
                // child: CircleAvatar(
                //   radius: 20,
                //   backgroundImage: NetworkImage(currentUserData!.image),
                // ),
                )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Profile') {
                    _navigateProfilePage();
                  } else if (value == 'Logout') {
                    _logOut();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Profile', 'Logout'}.map((String option) {
                    return PopupMenuItem<String>(
                      child: Row(
                        children: [
                          Icon(
                              option == 'Profile'
                                  ? Icons.person_2_rounded
                                  : Icons.logout_rounded,
                              color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            option,
                            style: ThemTextStyles.MenuOptionsText,
                          ),
                        ],
                      ),
                      value: option,
                    );
                  }).toList();
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                offset: const Offset(0, 40),
                child: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
              ),
            )

          // IconButton(
          //     onPressed: () {
          //       FirebaseAuth.instance.signOut();
          //       FirebaseFirestoreService.updateUserInformation(
          //         {'isOnline': false},
          //       );
          //       Navigator.pushReplacementNamed(context, '/loginPage');
          //     },
          //     icon: const Icon(Icons.logout, color: Colors.black)),
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
