


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final String driverName;

  const OrdersScreen({super.key, required this.driverName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders for $driverName'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('verified orders')
            .where('verifiedBy', isEqualTo: driverName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders data'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No verified orders found.'));
          } else {
            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderData = orders[index].data() as Map<String, dynamic>;

                // Safely access properties with null-aware operators
                final name = orderData['name'] as String?;
                final phone = orderData['phonenumber'] as String?;
                final place = orderData['place'] as String?;
                final date = orderData['date'] as String?;
                final time = orderData['time'] as String?;
                final verified = orderData['verifiedBy'] as String?;

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${name ?? 'N/A'}'),
                        Text('Phone: ${phone ?? 'N/A'}'),
                        Text('Place: ${place ?? 'N/A'}'),
                        Text('Date: ${date ?? 'N/A'}'),
                        Text('Time: ${time ?? 'N/A'}'),
                        Text('Verified by: ${verified ?? 'N/A'}'),
                      ],
                    ),
                    tileColor: Colors.green,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
