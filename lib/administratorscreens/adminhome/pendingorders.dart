import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class adminPendingOrdersScreen extends StatefulWidget {
  const adminPendingOrdersScreen({Key? key}) : super(key: key);

  @override
  State<adminPendingOrdersScreen> createState() =>
      _adminPendingOrdersScreenState();
}

class _adminPendingOrdersScreenState extends State<adminPendingOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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


                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, orderIndex) {
                      final order = orders[orderIndex].data();
                      final orderName = orders[orderIndex].id;

                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(orderName),
                              ),
                              Text('name: ${order['name']}'),
                              Text('Phone: ${order['phonenumber']}'),
                              Text('Place: ${order['place']}'),
                              Text('Date: ${order['date']}'),
                              Text('Time: ${order['time']}'),
                            ],
                          ),
                          tileColor: Colors.orange,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      String vanDriverName = '';

                                      return AlertDialog(
                                        title: const Text(
                                            'Assign Order to Van Driver'),
                                        content: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                                'Enter the name of the van driver:'),
                                            TextField(
                                              onChanged: (value) {
                                                vanDriverName = value;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              moveDataToTargetCollectionVerifiedWithDriver(
                                                userDoc,
                                                vanDriverName,
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Assign'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Verify'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
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
                                            moveDataToTargetCollectionRejected(
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

  void moveDataToTargetCollectionVerifiedWithDriver(
      DocumentSnapshot userDoc,
      String vanDriverName,
      ) async {
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

      // Add the data to the target collection (e.g., "verified orders").
      batch.set(
        FirebaseFirestore.instance.collection('verified orders').doc(),
        {
          ...orderData,
          'assignedTo': vanDriverName, // Add the assignedTo field
        },
      );

      // Delete the document from the source collection ("myorders").
      batch.delete(orderDoc.reference);
    }

    await batch.commit();
  }

  void moveDataToTargetCollectionRejected(DocumentSnapshot userDoc) async {
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
      // Add the data to the target collection (e.g., "rejected orders").
      batch.set(
        FirebaseFirestore.instance.collection('rejected orders').doc(),
        orderDoc.data(), // Copy order data as is
      );

      // Delete the document from the source collection ("myorders").
      batch.delete(orderDoc.reference);
    }

    await batch.commit();
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
