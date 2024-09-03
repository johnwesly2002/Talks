import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/profile_Page.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/services/pushNotification_service.dart';
import 'package:Talks/usersSearchScreen.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/UserItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Talks/widgets/webChatPage.dart';
import 'package:Talks/utils/themeColor.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final CurrentUserId = FirebaseAuth.instance.currentUser;
  final notificationService = NotificationsService();
  ChatUserModal? currentUserData;
  String? selectedUser;
  ChatUserModal? selectedUsers;
  @override
  void initState() {
    _currentUserData();
    _refreshUsersList();
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

  Future<void> _refreshUsersList() async {
    print("refresh triggered");
    await Provider.of<FirebaseProvider>(context, listen: false)
        .getAllUsers(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Talks", style: ThemTextStyles.HeadingStyles(context)),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const UserSearchScreen())),
                icon: const Icon(Icons.search_rounded)),
            if (currentUserData != null)
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Profile') {
                        _navigateProfilePage();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Profile'}.map((String option) {
                        return PopupMenuItem<String>(
                          value: option,
                          child: Row(
                            children: [
                              Icon(Icons.person_2_rounded,
                                  color: themeColor.attachIconColor(context)),
                              const SizedBox(width: 10),
                              Text(
                                option,
                                style: ThemTextStyles.MenuOptionsText(context),
                              ),
                            ],
                          ),
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
                      backgroundImage: NetworkImage(
                        currentUserData!.image,
                      ),
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
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Profile'}.map((String option) {
                      return PopupMenuItem<String>(
                        value: option,
                        child: Row(
                          children: [
                            const Icon(Icons.person_2_rounded,
                                color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              option,
                              style: ThemTextStyles.MenuOptionsText(context),
                            ),
                          ],
                        ),
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
                  child: const CircleAvatar(
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return _webLayout();
            } else {
              return _mobileLayout();
            }
          },
        ));
  }

  Widget _webLayout() {
    return Row(
      children: [
        //Users List
        Expanded(
          flex: 3,
          child: Consumer<FirebaseProvider>(
            builder: (context, value, child) {
              return RefreshIndicator(
                onRefresh: _refreshUsersList,
                child: ListView.separated(
                  itemCount: value.users.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final user = value.users[index];
                    selectedUsers = value.users[index];
                    if (user.uid != FirebaseAuth.instance.currentUser?.uid) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserItem(
                          isSelected: selectedUser == user.uid,
                          user: user,
                          onUserSelected: (uid) {
                            setState(() {
                              selectedUser = uid;
                            });
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
        VerticalDivider(
          width: 1,
          color: Colors.grey.shade300,
        ),
        // Chat area on the right side
        Expanded(
          flex: 7,
          child: selectedUser != null
              ? webChatPage(userId: selectedUser!, user: selectedUsers!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/TalksLogo.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      Text(
                        'Select a user to start chatting',
                        style: ThemTextStyles.WebEmptyChat(context),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _mobileLayout() {
    return Consumer<FirebaseProvider>(builder: (context, value, child) {
      return RefreshIndicator(
        onRefresh: _refreshUsersList,
        child: ListView.separated(
          itemCount: value.users.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              value.users[index].uid != FirebaseAuth.instance.currentUser?.uid
                  ? UserItem(user: value.users[index])
                  : const SizedBox(),
        ),
      );
    });
  }
}
