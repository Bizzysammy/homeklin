import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text('Completed Orders',
            style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('verified orders').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching customer data'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No verified orders found.'));
          } else {
            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderData = orders[index].data() as Map<String, dynamic>;


                // Safely access properties with null-aware operators
                final place = orderData['place'] as String?;
                final date = orderData['date'] as String?;
                final time = orderData['time'] as String?;
                final paymentmethod = orderData['paymentmethod'] as String?;
                final orderName = orders[index].id;
                return Container(
                  padding: const EdgeInsets.all(8.0), // Add padding here
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(orderName),
                          // Display order name inside the folder
                        ),
                        Text('Place: ${place ?? 'N/A'}'),
                        Text('Date: ${date ?? 'N/A'}'),
                        Text('Time: ${time ?? 'N/A'}'),
                        Text('paymentmethod: ${paymentmethod ?? 'N/A'}'),
                      ],
                    ),
                    tileColor: Colors.green, // Set tile color to green for verified orders
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
