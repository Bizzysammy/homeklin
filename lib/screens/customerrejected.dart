import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrders extends StatelessWidget {
  final String customerName;

  const CustomerOrders({Key? key, required this.customerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: Text(
          'Rejected Orders for $customerName',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('rejected orders')
            .where('name', isEqualTo: customerName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching rejected orders data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rejected orders found.'));
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
                final paymentMethod = orderData['paymentmethod'] as String?;

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Place: ${place ?? 'N/A'}'),
                        Text('Date: ${date ?? 'N/A'}'),
                        Text('Time: ${time ?? 'N/A'}'),
                        Text('Payment Method: ${paymentMethod ?? 'N/A'}'),
                      ],
                    ),
                    tileColor: Colors.red,
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
