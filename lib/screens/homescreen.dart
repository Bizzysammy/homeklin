import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_bottomnav.dart';
import 'customerprofilesetting.dart';
import 'logout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? imageUrl;


  double responsiveHeight(double height) {
    return MediaQuery.of(context).size.height * (height / 896.0);
  }

  double responsiveWidth(double width) {
    return MediaQuery.of(context).size.width * (width / 414.0);
  }

  @override
  Widget build(BuildContext context) {
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
          'PROFILE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const Profilesetting()
              ));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
    body: SafeArea(
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

    Stack(
    children: [
    Center(
    child: Container(
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
    color: Colors.green,
    width: 3,
    ),
    ),

    child: FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection("Customers")
        .doc(userId)
        .get(),
    builder: (context, snapshot) {
    if (snapshot.hasData && snapshot.data!.exists) {
    final data = snapshot.data!.data() as Map<String, dynamic>?; // Explicit cast to Map<String, dynamic>
    String? imageUrl = data?['profile_photo'] as String?;
    return CircleAvatar(
    backgroundImage: imageUrl != null
    ? Image.network(imageUrl).image
        : const AssetImage('assets/logo.jpg'),
    maxRadius: 60,
    minRadius: 50,
    );
    } else {
    return const CircularProgressIndicator();
    }
    },
    ),

    ),
    ),

    ],
    ),
      Container(

      ),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Customers")
            .doc(userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data?["name"] ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return const Text("Loading...");
          }
        },
      ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
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
                      final timestamp = notification?['timestamp'] as Timestamp? ?? Timestamp(0, 0);

                      return ListTile(
                        title: Text(message),
                        subtitle: Text('Time: ${timestamp.toDate()}'), // Display the timestamp
                      );
                    },
                  );
                },
              ),


                  // Category
                  SizedBox(height: responsiveHeight(20)),


                ],
              ),
            )

        ),
      );


  }
}
