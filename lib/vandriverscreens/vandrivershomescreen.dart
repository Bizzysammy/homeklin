import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeklin/screens/logout.dart';
import 'package:homeklin/vandriverscreens/vancompletedorders.dart';

import 'package:homeklin/vandriverscreens/vanpendingorders.dart';

import 'package:homeklin/vandriverscreens/vancollectorbottom.dart';

import 'addreports.dart';

class Vandrivershomescreen extends StatefulWidget {
  const Vandrivershomescreen({Key? key}) : super(key: key);
  static const String id = 'van_collection';

  @override
  State<Vandrivershomescreen> createState() => _VandrivershomescreenState();
}

class _VandrivershomescreenState extends State<Vandrivershomescreen> {
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        leading:
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Logout()
                ));
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'VAN COLLECTION',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  addreports()
                  ));
            },
            icon: const Icon(
              Icons.file_copy,
              color: Colors.white,
            ),
          ),
        ],
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
      bottomNavigationBar: const VanCustomBottomNavigator(),
      body: Column(children: [
        Container(
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

          child: Column(children: [
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

            SizedBox(height: screenSize.height * 0.07),
          ]),
        ),

        Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //two buttons one for complete and the other for in progress
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VanpendingOrdersScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('PENDING ORDERS'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const vandrivername()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('COMPELETED ORDERS '),
            ),
          ),
        ]),
        Expanded(child:
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('admin notifications').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final notifications = snapshot.data?.docs ?? [];

            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications found.'));
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index].data() as Map<String, dynamic>?;

                final message = notification?['message'] as String? ?? '';
                final currentDateTime = DateTime.now();

                return ListTile(
                  title: Text(message),
                  subtitle: Text(
                    'Time: $currentDateTime', // Display the current date and time
                  ),
                );
              },
            );
          },
        ),
        ),
      ]),
    ]
      ),
    );
  }
}
