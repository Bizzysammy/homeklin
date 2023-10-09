import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeklin/vandriverscreens/vandrivershomescreen.dart';


class addreports extends StatefulWidget {
  @override
  State<addreports> createState() => _addreportsState();
}

class _addreportsState extends State<addreports> {
  TextEditingController name = TextEditingController();

  TextEditingController day = TextEditingController();

  TextEditingController date = TextEditingController();

  TextEditingController numberofcompletedorders = TextEditingController();

  TextEditingController numberofrejectedorders = TextEditingController();

  TextEditingController numberofpendingorders = TextEditingController();

  TextEditingController totalcashcollection = TextEditingController();

  TextEditingController totalvisacollection = TextEditingController();

  TextEditingController totalmobilemoneycollection = TextEditingController();

  TextEditingController totalcollection = TextEditingController();


  final CollectionReference driversRef =
  FirebaseFirestore.instance.collection('Van Drivers');

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        actions: [
          MaterialButton(
            onPressed: () {
              _saveReportData();
            },
            child: Text(
              "save",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 251, 251, 251),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Vandrivershomescreen()));
            },
            child: Text(
              "Back",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 251, 251, 251),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: day,
                decoration: InputDecoration(
                  hintText: 'Day',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: date,
                decoration: InputDecoration(
                  hintText: 'Date',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: numberofpendingorders,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Number of Pending Orders',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: numberofrejectedorders,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Number of Rejected Orders',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: numberofcompletedorders,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Number of Completed Orders',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: totalcashcollection,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Total Cash Collection',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: totalvisacollection,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Total Visa Collection',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: totalmobilemoneycollection,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Total MobileMoney Collection',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: totalcollection,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Total Collection',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveReportData() async {
    final driverName = name.text;
    final driverDay = day.text;
    final reportDate = date.text.replaceAll('/', ''); // Remove separators

    // Check if the customer exists in the 'Customers' collection
    final driverQuery = await driversRef.where('name', isEqualTo: driverName)
        .get();

    if (driverQuery.docs.isEmpty) {
      // Customer doesn't exist, handle this case (e.g., show an error message)
      return;
    }

    final driverId = driverQuery.docs[0].id;

    // Create a reference to the 'my_reports' collection
    final myReportsCollection = driversRef.doc(driverId).collection(
        'my_reports');

    // Create a reference to the driver's day document
    final driverDayDoc = myReportsCollection.doc(driverDay);

    // Check if the driver's day document already exists
    final driverDayDocSnapshot = await driverDayDoc.get();

    if (!driverDayDocSnapshot.exists) {
      // If the driver's day document doesn't exist, create it
      await driverDayDoc.set({});

      // Create a reference to the 'reports' collection inside the driver's day document
      final reportsCollection = driverDayDoc.collection('reports');

      // Then, create a collection under it with the reportDate as its name
      final reportDateCollection = reportsCollection.doc(reportDate);

      // Save the report data in the reportDate document
      await reportDateCollection.set({
        'name': name.text,
        'day': day.text,
        'date': reportDate, // Save the date as-is
        'numberofcompletedorder': numberofcompletedorders.text,
        'numberofrejectedorder': numberofrejectedorders.text,
        'numberofpendingorders': numberofpendingorders.text,
        'totalcashcollection': totalcashcollection.text,
        'totalvisacollection': totalvisacollection.text,
        'totalmobilemoneycollection': totalmobilemoneycollection.text,
        'totalcollection': totalcollection.text,
      });
    } else {
      // If the driver's day document already exists, update the data directly in it
      await driverDayDoc.update({
        'name': name.text,
        'day': day.text,
        'date': date.text, // Save the date as-is
        'numberofcompletedorder': numberofcompletedorders.text,
        'numberofrejectedorder': numberofrejectedorders.text,
        'numberofpendingorders': numberofpendingorders.text,
        'totalcashcollection': totalcashcollection.text,
        'totalvisacollection': totalvisacollection.text,
        'totalmobilemoneycollection': totalmobilemoneycollection.text,
        'totalcollection': totalcollection.text,
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Vandrivershomescreen()),
    );
  }
}