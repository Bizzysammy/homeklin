import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'driverrejectedorders.dart';

class AdminRejectedOrdersScreen extends StatefulWidget {
  const AdminRejectedOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AdminRejectedOrdersScreen> createState() => AdminRejectedOrdersScreenState();
}

class AdminRejectedOrdersScreenState extends State<AdminRejectedOrdersScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'Rejected Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Van Drivers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching van driver data'));
          } else if (snapshot.hasData) {
            final vanDrivers = snapshot.data!.docs;

            // Check if vanDrivers is empty or null
            if (vanDrivers.isEmpty) {
              return const Center(child: Text('No van drivers found.'));
            }

            return ListView.builder(
              itemCount: vanDrivers.length,
              itemBuilder: (context, index) {
                final vanDriverData =
                vanDrivers[index].data() as Map<String, dynamic>;
                final vanDriverName = vanDriverData['name'] as String;

                return ListTile(
                  title: Text(vanDriverName),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            RejectOrdersScreen(driversName: vanDriverName),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No van drivers available.'));
          }
        },
      ),
    );
  }
}
