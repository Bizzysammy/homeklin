import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeklin/vandriverscreens/vanorders.dart';

class vandrivername extends StatefulWidget {
  const vandrivername({Key? key}) : super(key: key);

  @override
  State<vandrivername> createState() =>
      vandrivernameState();
}

class vandrivernameState extends State<vandrivername> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'Completed Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Van Drivers')
            .doc(getCurrentUserId())
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching van driver data'));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            final vanDriverData = snapshot.data!.data() as Map<String, dynamic>;
            final vanDriverName = vanDriverData['name'] as String;

            return ListTile(
              title: Text(vanDriverName),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Vanorders(driverName: vanDriverName),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No van driver data available.'));
          }
        },
      ),
    );
  }

  String getCurrentUserId() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return userId;
  }
}
