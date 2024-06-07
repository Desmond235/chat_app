import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    // close keyboard
    FocusScope.of(context).unfocus();

    // clear the text field
    messageController.clear();

    // get the current user  from firebase
    final user = FirebaseAuth.instance.currentUser!;

//  get users credentials from firebase_firestore
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

// send messages to firebase_firestore
    FirebaseFirestore.instance.collection('messages').add({
      'text': enteredMessage,
      'time': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['username'],
      'userImage': userData.data()!['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18,
        right: 3,
        bottom: 40,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
