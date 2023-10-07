import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../screens/logout.dart';
import '../../vandriverscreens/vancustomerlist.dart';

import 'adminbottom.dart';
import 'adminrejectedorders.dart';
import 'adminverifiedorders.dart';

class VanCollection extends StatefulWidget {
  const VanCollection({Key? key}) : super(key: key);
  static const String id = 'van_collection';

  @override
  State<VanCollection> createState() => _VanCollectionState();
}

class _VanCollectionState extends State<VanCollection> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Logout(),
              ),
            );
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'COLLECTION REPORTS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF213C54),
                Color(0xFF0059A5),
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AdminCustomBottomNavigator(),
      body: Column(
        children: [
          Container(
            // Elevated buttons container
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF213C54),
                  Color(0xFF0059A5),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenSize.width * 0.08,
                      foregroundColor: Colors.indigo,
                      backgroundImage: const AssetImage('assets/logo.jpg'),
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    CircleAvatar(
                      radius: screenSize.width * 0.08,
                      foregroundColor: Colors.indigo,
                      backgroundImage: const AssetImage('assets/lock.jpg'),
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    CircleAvatar(
                      radius: screenSize.width * 0.08,
                      foregroundColor: Colors.indigo,
                      backgroundImage: const AssetImage('assets/phone.jpg'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Two buttons one for rejected orders and the other for customers
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminRejectedOrdersScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: const Text('REJECTED ORDERS'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerListPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: const Text('CUSTOMERS'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Button for confirmed collection
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminverifiedOrdersScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: const Text('CONFIRMED COLLECTION'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            // Van drivers list container
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('Van Drivers').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching van driver data'));
                } else if (snapshot.hasData) {
                  final vanDrivers = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: vanDrivers.length,
                    itemBuilder: (context, index) {
                      final vanDriver = vanDrivers[index];
                      final vanDriverData = vanDriver.data() as Map<String, dynamic>;
                      final vanDriverName = vanDriverData['name'] ?? ''; // Name
                      final vanDrivervannumber = vanDriverData['vannumber'] ?? ''; // Van number
                      final vanDriverEmail = vanDriverData['email'] ?? ''; // Email
                      final vanDriverNumber = vanDriverData['phoneNumber'] ?? ''; // Phone Number

                      return ListTile(
                        title: Text(vanDriverName),
                        onTap: () {
                          // When a van driver folder is clicked, display their details
                          _showVanDriverDetails(context, vanDriverName, vanDrivervannumber, vanDriverEmail, vanDriverNumber);
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No van drivers available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showVanDriverDetails(BuildContext context, String name, String vannumber, String email, String number) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Van Number: $vannumber'),
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
