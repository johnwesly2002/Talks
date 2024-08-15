import 'package:Talks/Chat_Page.dart';
import 'package:Talks/modals/chatUserModal.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});
  final ChatUserModal user;
  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
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
              Text(widget.user.name, style: ThemTextStyles.homePageUsersText),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChatPage(userId: widget.user.uid)))
        },
        child: ListTile(
          leading: Stack(alignment: Alignment.bottomRight, children: [
            GestureDetector(
              onTap: () => _showProfilePicture(context, widget.user.image),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.user.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                backgroundColor:
                    widget.user.isOnline ? Colors.green : Colors.red,
                radius: 5,
              ),
            )
          ]),
          title: Text(
            widget.user.name,
            style: ThemTextStyles.homePageUsersText,
          ),
          subtitle: Text(
            'Last Seen: ${timeago.format(widget.user.lastActive)}',
            maxLines: 2,
            style: ThemTextStyles.lastSeenText,
          ),
        ),
      );
}
