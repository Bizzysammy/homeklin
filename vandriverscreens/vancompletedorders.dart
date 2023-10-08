import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class VanverifiedOrdersScreen extends StatelessWidget {
  const VanverifiedOrdersScreen({Key? key}) : super(key: key);

  Future<void> _openLocationInMaps(String location) async {
    final url =  Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'Verified Orders',
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
                final name = orderData['name'] as String?;
                final phone = orderData['phonenumber'] as String?;
                final place = orderData['place'] as String?;
                final location = orderData['location'] as String?;
                final paymentmethod = orderData['paymentmethod'] as String?;
                final date = orderData['date'] as String?;
                final time = orderData['time'] as String?;

                return GestureDetector(
                  onTap: () {
                    if (location != null) {
                      _openLocationInMaps(location);
                    }
                  },
                  child: Container(
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
                        ],
                      ),
                      tileColor: Colors.green,
                    ),
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
