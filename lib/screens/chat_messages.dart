import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return KeyboardDismissOnTap(
      child: StreamBuilder(
          // listen for chnages
          stream: FirebaseFirestore.instance
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, messageSnapshots) {
            if (messageSnapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!messageSnapshots.hasData ||
                messageSnapshots.data!.docs.isEmpty) {
              const Center(
                child: Text('No messages found.'),
              );
            }
            if (messageSnapshots.hasError) {
              const Center(
                child: Text('Something went wrong...'),
              );
            }
      
            final loadedMessages = messageSnapshots.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              itemCount: loadedMessages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
      
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;

                    // checks if the next message sent was from the current user
                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;
      
                if (nextUserIsSame) {
                  return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                } else {
                  return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                }
              },
            );
          }),
    );
    // /Center(child: Text('No messages found'),);
  }
}
