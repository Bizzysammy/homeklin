import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeklin/vandriverscreens/vancollectorbottom.dart';

import 'vanprofilesetting.dart';
import 'package:homeklin/screens/logout.dart';
import 'dart:math';

class Vanprofile extends StatefulWidget {
  const Vanprofile({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  @override
  State<Vanprofile> createState() => _VanprofileState();
}

class _VanprofileState extends State<Vanprofile> {

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


  double responsiveHeight(double height) {
    return MediaQuery.of(context).size.height * (height / 896.0);
  }

  double responsiveWidth(double width) {
    return MediaQuery.of(context).size.width * (width / 414.0);
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
                      builder: (context) => const Vanprofilesetting()
                  ));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const VanCustomBottomNavigator(),
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

                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("Van Drivers")
                            .doc(userId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data() as Map<String, dynamic>?; // Explicit cast to Map<String, dynamic>
                            String? imageUrl = data?['profile_photo'] as String?;
                            return CircleAvatar(
                              backgroundImage: imageUrl != null
                                  ? Image.network(imageUrl).image
                                  : const AssetImage('assets/logo.jpg'),
                              maxRadius: 60,
                              minRadius: 50,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),

                    ),
                  ),

                ],
              ),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Van Drivers")
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

                    // Category

    Padding(
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

                      ],
                         ),

                    ),


                ),
              );





  }
}