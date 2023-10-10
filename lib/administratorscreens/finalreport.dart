import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class report extends StatefulWidget {
  final String vanDriverName;

  final String day;
  final String date;
  report({required this.vanDriverName,  required this.day, required this.date});

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  final pdf = pw.Document();
  String? name;
  String? days;
  String? dates;
  String? numberofcompletedorder;
  String? numberofpendingorders;
  String? numberofrejectedorder;
  String? totalcashcollection;
  String? totalvisacollection;
  String? totalmobilemoneycollection;
  String? totalcollection;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      final reportsCollection = FirebaseFirestore.instance.collection("Van Drivers");

      final driverQuerySnapshot = await reportsCollection
          .where("name", isEqualTo: widget.vanDriverName)
          .get();

      if (driverQuerySnapshot.docs.isNotEmpty) {
        final driverDocRef = driverQuerySnapshot.docs[0].reference;
        final myReportsDocRef = driverDocRef.collection("my_reports").doc(widget.day);
        final myReportsSnapshot = await myReportsDocRef.collection("reports").where("date", isEqualTo: widget.date).get();

        if (myReportsSnapshot.docs.isNotEmpty) {
          // Get the reference to the document inside 'reports'
          DocumentSnapshot reportDocSnapshot = myReportsSnapshot.docs[0];

          // Access the data and set the state
          Map<String, dynamic> reportData = reportDocSnapshot.data() as Map<String, dynamic>;

          setState(() {
            name = reportData['name'] as String?;
            days = reportData['day'] as String?;
            dates = reportData['date'] as String?;
            numberofcompletedorder = reportData['numberofcompletedorder'] as String?;
            numberofpendingorders = reportData['numberofpendingorders'] as String?;
            numberofrejectedorder = reportData['numberofrejectedorder'] as String?;
            totalcashcollection = reportData['totalcashcollection'] as String?;
            totalvisacollection = reportData['totalvisacollection'] as String?;
            totalmobilemoneycollection = reportData['totalmobilemoneycollection'] as String?;
            totalcollection = reportData['totalcollection'] as String?;
          });
        } else {
          // The document with the specified ID does not exist in 'reports'
          print('Document does not exist in reports.');
        }
      } else {
        // The document with the specified 'name' does not exist in 'Van Drivers'
        print('Van Driver document does not exist.');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching data: $e');
    }
  }



  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final ByteData imageData = await rootBundle.load('assets/logo.jpg');
    final Uint8List bytes = imageData.buffer.asUint8List();
    final pw.MemoryImage image = pw.MemoryImage(Uint8List.fromList(bytes));

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  child: pw.Image(image),
                  width: 300,
                  height: 120,
                ),
                pw.Center(
                  child: pw.Text(
                    'Daily Bin Collection Report',
                    style: pw.TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                pw.SizedBox(
                  height: 20,
                ),
                pw.Divider(),
                _buildDataRow('Date', dates),
                _buildDataRow('Day', days),
                _buildDataRow('Name', name),
                _buildDataRow('Number of Completed Orders', numberofcompletedorder?.toString() ?? 'N/A'),
                _buildDataRow('Number of Rejected Orders', numberofrejectedorder?.toString() ?? 'N/A'),
                _buildDataRow('Number of Pending Orders', numberofpendingorders?.toString() ?? 'N/A'),
                _buildDataRow('Total Cash Collection', totalcashcollection?.toString() ?? 'N/A'),
                _buildDataRow('Total Visa Collection', totalvisacollection?.toString() ?? 'N/A'),
                _buildDataRow('Total MobileMoney Collection', totalmobilemoneycollection?.toString() ?? 'N/A'),
                pw.Divider(),
                _buildDataRow('Total Collection', totalcollection?.toString() ?? 'N/A'),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Container _buildDataRow(String label, String? value) {
    return pw.Container(
      margin: pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(
              fontSize: 30,
            ),
          ),
          pw.Text(
            value ?? 'N/A',
            style: pw.TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) => generateDocument(format),
    );
  }
}
