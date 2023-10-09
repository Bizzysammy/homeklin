import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Customers')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching customer data'));
          } else if (snapshot.hasData) {
            final customers = snapshot.data!.docs;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                final customerData = customer.data() as Map<String, dynamic>;
                final customerName = customerData['name'] ?? ''; // Name
                final customerLocation = customerData['location'] ?? ''; // Location
                final customerEmail = customerData['email'] ?? ''; // Email
                final customerNumber = customerData['phoneNumber'] ?? ''; // Phone Number

                return ListTile(
                  title: Text(customerName),
                  onTap: () {
                    // When a customer folder is clicked, display their details
                    _showCustomerDetails(context, customerName, customerLocation, customerEmail, customerNumber);
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No customers available.'));
          }
        },
      ),
    );
  }

  void _showCustomerDetails(BuildContext context, String name, String location, String email, String number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Location: $location'),
              Text('Email: $email'),
              Text('Number: $number'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
