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


              return Container(
                padding: const EdgeInsets.all(8.0), // Add padding here
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Place: ${order['place']}'),
                      Text('Date: ${order['date']}'),
                      Text('Time: ${order['time']}'),
                      Text('Paymentmethod: ${order['paymentmethod']}'),
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
