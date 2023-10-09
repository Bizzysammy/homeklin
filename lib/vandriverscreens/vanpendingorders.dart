import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VanPendingOrdersScreen extends StatefulWidget {
  const VanPendingOrdersScreen({Key? key}) : super(key: key);

  @override
  State<VanPendingOrdersScreen> createState() => _VanPendingOrdersScreenState();
}

class _VanPendingOrdersScreenState extends State<VanPendingOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        stream: _firestore.collection('Customers').snapshots(),
        builder: (context, customersSnapshot) {
          if (!customersSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final customers = customersSnapshot.data!.docs;

          if (customers.isEmpty) {
            return const Center(
              child: Text('No customers found.'),
            );
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, customerIndex) {
              final userDoc = customers[customerIndex];

              return StreamBuilder(
                stream: _firestore
                    .collection('Customers')
                    .doc(userDoc.id)
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, orderIndex) {
                      final order = orders[orderIndex].data();
                      final orderName = orders[orderIndex].id;

                      return Container(
                        padding: const EdgeInsets.all(8.0), // Add padding here
                        child: ListTile(
                          // Display customer name as the main title
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                    orderName), // Display order name inside the folder
                              ),
                              Text('name: ${order['name']}'),
                              Text('Phone: ${order['phonenumber']}'),
                              Text('Place: ${order['place']}'),
                              Text('Date: ${order['date']}'),
                              Text('Time: ${order['time']}'),

                            ],
                          ),
                          tileColor: Colors.orange,
                          // Set tile color to orange
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Display a confirmation dialog before moving the order
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: const Text('Confirm'),
                                          content: const Text(
                                              'Are you sure you want to verify this order?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Handle verify button press
                                                moveDataToTargetCollectionverified(
                                                    userDoc);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Verify'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                child: const Text('Verify'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Display a confirmation dialog before moving the order
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: const Text('Confirm'),
                                          content: const Text(
                                              'Are you sure you want to reject this order?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Handle reject button press
                                                moveDataToTargetCollectionrejected(
                                                    userDoc);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Reject'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to move an order to the specified collection and delete it
  void moveDataToTargetCollectionverified(DocumentSnapshot userDoc) async {
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(userDoc.id)
        .collection('myorders')
        .get();

    if (ordersSnapshot.docs.isEmpty) {
      return; // No pending orders found.
    }

    final batch = FirebaseFirestore.instance.batch();

    for (final orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data(); // Cast orderData here

      final vanDriverName = await getVanDriverName(); // Implement getVanDriverName()

      // Update the "verifiedBy" field in the order data
      orderData['verifiedBy'] = vanDriverName;

      // Add the data to the target collection (e.g., "verified orders").
      batch.set(
        FirebaseFirestore.instance.collection('verified orders').doc(),
        orderData,
      );

      // Delete the document from the source collection ("myorders").
      batch.delete(orderDoc.reference);
    }

    await batch.commit();
  }

  // Function to move an order to the specified collection and delete it
  void moveDataToTargetCollectionrejected(DocumentSnapshot userDoc) async {
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(userDoc.id)
        .collection('myorders')
        .get();

    if (ordersSnapshot.docs.isEmpty) {
      return; // No pending orders found.
    }

    final batch = FirebaseFirestore.instance.batch();

    for (final orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data(); // Cast orderData here

      // Retrieve the van driver's name or identifier (replace with your logic)
      final vanDriverName = await getVanDriverName(); // Implement getVanDriverName()

      // Update the "verifiedBy" field in the order data
      orderData['rejectedBy'] = vanDriverName;

      // Add the data to the target collection (e.g., "verified orders").
      batch.set(
        FirebaseFirestore.instance.collection('rejected orders').doc(),
        orderData,
      );

      // Delete the document from the source collection ("myorders").
      batch.delete(orderDoc.reference);
    }

    await batch.commit();
  }
}
// Function to retrieve the van driver's name
Future<String> getVanDriverName() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    final driverSnapshot = await FirebaseFirestore.instance
        .collection('Van Drivers')
        .doc(userId) // Assuming the van driver's document ID is the same as their user ID
        .get();

    if (driverSnapshot.exists) {
      final data = driverSnapshot.data() as Map<String, dynamic>;
      final driverName = data['name'] as String?;
      return driverName ?? ''; // Return the driver's name or an empty string if not found
    } else {
      return ''; // Return an empty string if the driver's document doesn't exist
    }
  } catch (e) {
    print('Error getting van driver name: $e');
    return ''; // Return an empty string in case of an error
  }
}
