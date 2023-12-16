import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeklin/screens/customerorders.dart';
import 'package:homeklin/screens/customerrejected.dart';


class RejectedOrdersScreen extends StatefulWidget {
  const RejectedOrdersScreen({Key? key}) : super(key: key);

  @override
  State<RejectedOrdersScreen> createState() =>
      RejectedOrdersScreenState();
}

class RejectedOrdersScreenState extends State<RejectedOrdersScreen> {
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Customers')
            .doc(getCurrentUserId())
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching van driver data'));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            final CustomerData = snapshot.data!.data() as Map<String, dynamic>;
            final CustomersName = CustomerData['name'] as String;

            return ListTile(
              title: Text(CustomersName),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CustomerOrders(customerName: CustomersName),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No customer data available.'));
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