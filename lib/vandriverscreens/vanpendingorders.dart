import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class VanpendingOrdersScreen extends StatelessWidget {
  const VanpendingOrdersScreen({Key? key}) : super(key: key);

  Future<void> _openLocationInMaps(String location) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$location');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _completeOrder(String orderId, String vanDriverName) async {
    final batch = FirebaseFirestore.instance.batch();

    // Retrieve the order document
    final orderReference =
    FirebaseFirestore.instance.collection('verified orders').doc(orderId);
    final orderSnapshot = await orderReference.get();

    if (orderSnapshot.exists) {
      final orderData = orderSnapshot.data() as Map<String, dynamic>;

      // Add the data to the "completed orders" collection.
      batch.set(
        FirebaseFirestore.instance.collection('completed orders').doc(),
        {
          ...orderData,
          'completedBy': vanDriverName,
        },
      );

      // Delete the document from the "verified orders" collection.
      batch.delete(orderReference);

      // Commit the batch operation
      await batch.commit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'Pending Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
        FirebaseFirestore.instance.collection('verified orders').get(),
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
                final orderId = orders[index].id;

                // Safely access properties with null-aware operators
                final name = orderData['name'] as String?;
                final phone = orderData['phonenumber'] as String?;
                final place = orderData['place'] as String?;
                final location = orderData['location'] as String?;
                final paymentmethod = orderData['paymentmethod'] as String?;
                final date = orderData['date'] as String?;
                final time = orderData['time'] as String?;
                final assignedTo = orderData['assignedTo'] as String?;

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
                          Text('ASSIGNNEDTO: ${assignedTo ?? 'N/A'}'),
                        ],
                      ),
                      tileColor: Colors.green,
                      trailing: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Completion'),
                              content: const Text(
                                  'Are you sure you want to complete this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Get the van driver's name
                                    final vanDriverName =
                                    await getVanDriverName();

                                    // Complete the order
                                    await _completeOrder(
                                        orderId, vanDriverName);

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Complete'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Complete'),
                      ),
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

Future<String> getVanDriverName() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    final driverSnapshot = await FirebaseFirestore.instance
        .collection('Van Drivers')
        .doc(userId)
        .get();

    if (driverSnapshot.exists) {
      final data = driverSnapshot.data() as Map<String, dynamic>;
      final driverName = data['name'] as String?;
      return driverName ?? '';
    } else {
      return '';
    }
  } catch (e) {
    print('Error getting van driver name: $e');
    return '';
  }
}
