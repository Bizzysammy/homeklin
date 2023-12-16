import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeklin/screens/customerprofilesetting.dart';




import 'dart:math';

import 'package:homeklin/widgets/custom_bottomnav.dart';

class Customerprofile extends StatefulWidget {
  const Customerprofile({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  @override
  State<Customerprofile> createState() => _CustomerprofileState();
}

class _CustomerprofileState extends State<Customerprofile> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? imageUrl;

  final CollectionReference notificationsRef =
  FirebaseFirestore.instance.collection('notifications');
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
      notificationsRef
          .doc(randomId.toString())
          .set({'message': message})
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
        title: const Text(
          'PROFILE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Profilesetting()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!) // Use NetworkImage if imageUrl is not null
                            : const AssetImage('assets/logo.jpg') as ImageProvider,// Use AssetImage and cast it to ImageProvider
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Customers")
                    .doc(userId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data?["name"] ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Text("Loading...");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: messageController,
                      decoration:
                      const InputDecoration(labelText: 'Notification Message'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: addNotification,
                      child: const Text('Add Notification'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
