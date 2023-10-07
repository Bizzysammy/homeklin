import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'adminbottom.dart';

class AdminSendNotifications extends StatefulWidget {
  const AdminSendNotifications({Key? key}) : super(key: key);

  @override
  AdminSendNotificationsState createState() => AdminSendNotificationsState();
}

class AdminSendNotificationsState extends State<AdminSendNotifications> {
  final CollectionReference notificationsRef =
  FirebaseFirestore.instance.collection('admin notifications');
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void addNotification() {
    final random = Random();
    final int randomId = random.nextInt(100000);
    final String message = messageController.text;

    if (message.isNotEmpty) {
      notificationsRef.doc(randomId.toString()).set({'message': message})
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification added successfully')),
        );
        messageController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add notification')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text('Add Notification',
            style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: const AdminCustomBottomNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Notification Message'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addNotification,
              child: const Text('Add Notification'),
            ),
          ],
        ),
      ),
    );
  }
}