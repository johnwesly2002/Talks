import "package:flutter/material.dart";

class ChatBubble extends StatelessWidget {
  final alignment;
  final message;
  const ChatBubble({super.key, required this.alignment, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
                alignment: alignment,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Text( '$message', style: TextStyle(fontSize: 20, color: Colors.white),),
                    // Image(image: AssetImage('assets/LoginLogo.jpg'), width: 100, height: 100,)
                    ],
                  ),
                
                  margin: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  ),
                ),
              );
  }
}