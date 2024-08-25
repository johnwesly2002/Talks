import 'package:Talks/Chat_Page.dart';
import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/services/firebase_StorageService.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/utils/themeColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatefulWidget {
  const UserItem({
    super.key,
    required this.user,
    this.onUserSelected,
    this.isSelected = false,
  });

  final ChatUserModal user;
  final bool isSelected;
  final void Function(String)? onUserSelected;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool _isHovered = false;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _showProfilePicture(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(widget.user.image),
              ),
              const SizedBox(height: 10),
              Text(widget.user.name,
                  style: ThemTextStyles.homePageUsersText(context)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final firebaseService = Provider.of<FirebaseProvider>(context);
    final unreadMessageCount = firebaseService.getUnreadMessageCountStream(
        currentUserId, widget.user.uid);
    print("unreadcount${unreadMessageCount}");
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () async {
          if (widget.onUserSelected != null) {
            widget.onUserSelected!(widget.user.uid);
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChatPage(userId: widget.user.uid),
            ));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          ),
          child: ListTile(
              leading: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: () =>
                        _showProfilePicture(context, widget.user.image),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.user.image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      backgroundColor:
                          widget.user.isOnline ? Colors.green : Colors.orange,
                      radius: 8,
                      child: Center(
                        child: Icon(
                          widget.user.isOnline ? Icons.check : Icons.link_off,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              title: Text(
                widget.user.name,
                style: ThemTextStyles.homePageUsersText(context),
              ),
              subtitle: Text(
                'Last Seen: ${timeago.format(widget.user.lastActive)}',
                maxLines: 2,
                style: ThemTextStyles.lastSeenText(context),
              ),
              trailing: StreamBuilder<int>(
                stream: unreadMessageCount,
                builder: (context, snapshot) {
                  final unreadMessageCount = snapshot.data ?? 0;
                  return unreadMessageCount > 0
                      ? CircleAvatar(
                          backgroundColor: themeColor.primaryColor(context),
                          radius: 10,
                          child: Text(
                            '$unreadMessageCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              )),
        ),
      ),
    );
  }
}
