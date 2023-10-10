
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'driverdatereport.dart';

class VanDriverDayReportsList extends StatefulWidget {
  final String vanDriverName;

  VanDriverDayReportsList({required this.vanDriverName});

  @override
  _VanDriverDayReportsListState createState() =>
      _VanDriverDayReportsListState();
}

class _VanDriverDayReportsListState extends State<VanDriverDayReportsList> {
  List<String> subcollectionNames = [];

  @override
  void initState() {
    super.initState();
    _fetchSubcollections();
  }

  Future<void> _fetchSubcollections() async {
    try {
      // Reference to the "Van Drivers" collection
      CollectionReference vanDriversCollection =
      FirebaseFirestore.instance.collection("Van Drivers");

      QuerySnapshot subcollectionsSnapshot = await vanDriversCollection
          .where("name", isEqualTo: widget.vanDriverName)
          .get();

      if (subcollectionsSnapshot.docs.isNotEmpty) {
        // Reference to the specific document where name equals vanDriverName
        DocumentReference driverDocRef =
            subcollectionsSnapshot.docs[0].reference;

        // Reference to the "my_reports" subcollection
        CollectionReference myReportsSubcollectionRef =
        driverDocRef.collection("my_reports");

        QuerySnapshot myReportsSubcollectionSnapshot =
        await myReportsSubcollectionRef.get();

        List<String> subcollectionNamesForDriver =
        myReportsSubcollectionSnapshot.docs.map((doc) => doc.id).toList();

        setState(() {
          subcollectionNames = subcollectionNamesForDriver;
        });
      }
    } catch (e) {
      print("Error fetching subcollections: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day Reports for ${widget.vanDriverName}'),
      ),
      body: subcollectionNames.isNotEmpty
          ? ListView.builder(
        itemCount: subcollectionNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subcollectionNames[index]),
            onTap: () {
              // Add your navigation logic here if needed
              // Navigate to the DateReportsScreen with the selected subcollection name
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>DateReportsScreen(
                    vanDriverName: widget.vanDriverName, day: subcollectionNames[index],
                  ),
                ),
              );
            },
          );
        },
      )
          : Center(
        child: Text(
            'No subcollections available for ${widget.vanDriverName}'),
      ),
    );
  }
}
