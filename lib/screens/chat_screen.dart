import 'package:chat_app/screens/chat_messages.dart';
import 'package:chat_app/screens/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black45.withOpacity(0.4),
        builder: (context) {
          return AlertDialog(
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(
              'Do you want to log out?',
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  )
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FlutterChat'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => showAlertDialog(context),
            ),
          ],
        ),
        body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ));
  }
}
