import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({Key? key}) : super(key: key);

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text('Pending Orders',
            style: TextStyle(color: Colors.white),
        ),

      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('Customers')
            .doc(userId)
            .collection('myorders')
            .snapshots(),
        builder: (context, ordersSnapshot) {
          if (!ordersSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = ordersSnapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
              child: Text('No pending orders found.'),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data();
              final orderName = orders[index].id;

              return Container(
                padding: const EdgeInsets.all(8.0), // Add padding here
                child: ListTile(
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Customers")
                        .doc(userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data = snapshot.data!.data() as Map<String, dynamic>?; // Explicit cast to Map<String, dynamic>
                        String? userName = data?['name'] as String?;
                        return Text(userName ?? "");
                      } else {
                        return const Text("Loading...");
                      }
                    },
                  ),
                  // Display customer name as the main title
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(orderName),
                        // Display order name inside the folder
                      ),
                      Text('Place: ${order['place']}'),
                      Text('Date: ${order['date']}'),
                      Text('Time: ${order['time']}'),
                    ],
                  ),
                  tileColor: Colors.orange, // Set tile color to orange
                ),
              );
            },
          );
        },
      ),
    );
  }
}
