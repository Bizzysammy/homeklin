


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final String customerName;

  const OrdersScreen({super.key, required this.customerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders for $customerName'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('completed orders')
            .where('name', isEqualTo: customerName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders data'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No completed orders found.'));
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
                final location = orderData['location'] as String?;
                final paymentmethod = orderData['paymentmethod'] as String?;
                final date = orderData['date'] as String?;
                final time = orderData['time'] as String?;
                final completedBy = orderData['completedBy'] as String?;


                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('name: ${name ?? 'N/A'}'),
                        Text('Phone: ${phone ?? 'N/A'}'),
                        Text('Place: ${place ?? 'N/A'}'),
                        Text('location: ${location ?? 'N/A'}'),
                        Text('paymentmethod: ${paymentmethod ?? 'N/A'}'),
                        Text('Date: ${date ?? 'N/A'}'),
                        Text('Time: ${time ?? 'N/A'}'),
                        Text('Completed By: ${completedBy ?? 'N/A'}'),
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
