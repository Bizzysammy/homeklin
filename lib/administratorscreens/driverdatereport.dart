import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'finalreport.dart';

class DateReportsScreen extends StatelessWidget {
  final String vanDriverName;
  final String day;
  DateReportsScreen({
    Key? key,
    required this.vanDriverName, required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports for $vanDriverName'),
      ),
      body: FutureBuilder(
        future: _fetchSubcollections(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reports available for this driver.'));
          } else {
            final datesubcollections = snapshot.data!;

            return ListView.builder(
              itemCount: datesubcollections.length,
              itemBuilder: (context, index) {
                final subcollectionName = datesubcollections[index];

                return ListTile(
                  title: Text(datesubcollections[index]),
                  onTap: () {
                    // Show a dialog to confirm the van driver's name
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => report(
                          vanDriverName: vanDriverName,
                          day: day, date: subcollectionName, // Pass the selected date as the subcollectionName
                        ),
                      ),
                    );

                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _fetchSubcollections() async {
    try {
      final vanDriversCollection = FirebaseFirestore.instance.collection("Van Drivers");

      QuerySnapshot driversSnapshot = await vanDriversCollection
          .where("name", isEqualTo: vanDriverName)
          .get();

      if (driversSnapshot.docs.isNotEmpty) {
        DocumentReference driverDocRef = driversSnapshot.docs[0].reference;

        CollectionReference myReportsSubcollectionRef = driverDocRef.collection("my_reports");

        QuerySnapshot myReportsSubcollectionSnapshot = await myReportsSubcollectionRef.get();

        if (myReportsSubcollectionSnapshot.docs.isNotEmpty) {
          // Find the document with the specified day
          DocumentSnapshot dayDocument = myReportsSubcollectionSnapshot.docs.firstWhere(
                (doc) => doc.id == day,
          );

          CollectionReference reportsSubcollectionRef = dayDocument.reference.collection("reports");

          QuerySnapshot reportsSubcollectionSnapshot = await reportsSubcollectionRef.get();

          List<String> reportNames = reportsSubcollectionSnapshot.docs.map((doc) => doc.id).toList();

          return reportNames;
        }
      }
    } catch (e) {
      print('Error fetching reports: $e');
    }

    return [];
  }


                    // Navigate to the report screen if the name exists


                  }

