
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homeklin/widgets/custom_bottomnav.dart';
import 'package:homeklin/screens/paymentscreen.dart';

import 'logout.dart';
class BinCollection extends StatefulWidget {
  const BinCollection({Key? key}) : super(key: key);
  static const String id = 'bin_collection';

  @override
  State<BinCollection> createState() => _BinCollectionState();
}

class _BinCollectionState extends State<BinCollection> {

  List<String> paymentmethod = ['VISA CARD', 'CASH', 'MOBILE MONEY'];
  String? payment;


  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String googleapikey = "AIzaSyCk0zu5LUecfoOpBQlfcqv1h5OIWIL1of0";

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final String location = '${position.latitude}, ${position.longitude}';
    _locationController.text = location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        leading:IconButton(
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
          'BIN COLLECTION',
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
      bottomNavigationBar: const CustomBottomNavigator(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _phonenumberController,
                decoration: const InputDecoration(
                  labelText: 'PhoneNumber',
                  prefixIcon: Icon(Icons.phone, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'Place',
                  prefixIcon: Icon(Icons.location_city_rounded, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.place, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  _getCurrentLocation();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child:  DropdownButtonFormField<String>(
                items: paymentmethod.map((String payments) {
                  return DropdownMenuItem<String>(
                    value: payments,
                    child: Text(payments),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    payment = value;
                  });
                },
                value: payment,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  prefixIcon: Icon(Icons.money, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.date_range, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      _dateController.text = selectedDate.toString();
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  prefixIcon: Icon(
                    Icons.access_time,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((selectedTime) {
                    if (selectedTime != null) {
                      _timeController.text = selectedTime.format(context);
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF213C54),
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () async {
                  final String name = _nameController.text;
                  final String phone = _phonenumberController.text;
                  final String place = _placeController.text;
                  final String location = _locationController.text;
                  final String time = _timeController.text;
                  final String date = _dateController.text;

                  if (place.isEmpty ||
                      location.isEmpty ||
                      phone.isEmpty ||
                      time.isEmpty ||
                      date.isEmpty ||
                      name.isEmpty ||
                      payment == null) {
                    // Handle fields validation here (e.g., show an error message)
                    return;
                  }

                  final userQuery = _firestore
                      .collection('Customers')
                      .where('name', isEqualTo: name)
                      .limit(1);

                  final userQuerySnapshot = await userQuery.get();

                  if (userQuerySnapshot.docs.isEmpty) {
                    // Handle case where user does not exist (e.g., show an error message)
                    return;
                  }

                  final userDocRef = userQuerySnapshot.docs[0].reference;

                  final userData = userQuerySnapshot.docs[0].data();
                  final int currentOrderCount = userData['orderCount'] ?? 0;
                  final int nextOrderCount = currentOrderCount + 1;

                  // Construct the order data to be saved in Firestore
                  final orderData = {
                    'phonenumber': phone,
                    'name': name,
                    'place': place,
                    'location': location,
                    'paymentmethod': payment,
                    'time': time,
                    'date': date,
                  };

                  userDocRef
                      .collection('myorders')
                      .doc('my order $nextOrderCount')
                      .set(orderData)
                      .then((_) {
                    // Clear text controllers after successfully updating data
                    _nameController.clear();
                    _phonenumberController.clear();
                    _placeController.clear();
                    _locationController.clear();
                    _timeController.clear();
                    _dateController.clear();
                    payment = null; // Clear the payment method selection

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order saved successfully')),
                    );
                    userDocRef.update({'orderCount': nextOrderCount});
                  }).catchError((e) {
                    print('Error making order: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to save order')),
                    );
                  });
                },
                child: const Text('Book Now'),
              ),

            ),
          ],
        ),
      ),
    );
  }

Future<bool> _handleLocationPermission() async {
  // Check the platform before using web-specific code
  if (!kIsWeb) {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
  }
  return true;
}
}
