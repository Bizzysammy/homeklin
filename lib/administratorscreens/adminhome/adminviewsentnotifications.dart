import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adminbottom.dart';

class AdminsentNotificationScreen extends StatefulWidget {
  const AdminsentNotificationScreen({Key? key}) : super(key: key);

  @override
  AdminsentNotificationScreenState createState() => AdminsentNotificationScreenState();
}

class AdminsentNotificationScreenState extends State<AdminsentNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: const AdminCustomBottomNavigator(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin notifications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index].data() as Map<String, dynamic>?;

              final message = notification?['message'] as String? ?? '';
              final currentDateTime = DateTime.now();

              return ListTile(
                title: Text(message),
                subtitle: Text(
                  'Time: $currentDateTime', // Display the current date and time
                ),
              );
            },
          );
        },
      ),

    );
  }
}
