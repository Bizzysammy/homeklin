import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'dart:async';

void main() {
  MpesaFlutterPlugin.setConsumerKey("JGIPya64PLzj5Z6Obvph9WINTDboXgyn");
  MpesaFlutterPlugin.setConsumerSecret("AS7lMS0ap8P6ibGy");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController accountReferenceController = TextEditingController();

  Future<void> lipaNaMpesa() async {
    dynamic transactionInitialization;
    try {
      String phoneNumber = phoneNumberController.text;

      // Check if the phone number already starts with '+'
      if (!phoneNumber.startsWith('+')) {
        // If not, add the country code (e.g., for Uganda)
        phoneNumber = '+256' + phoneNumber;
      }

      transactionInitialization = await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: "174379",
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: double.parse(amountController.text),
        partyA: phoneNumber,
        partyB: "174379",
        callBackURL: Uri(
            scheme: "https",
            host: "sandbox.safaricom.co.ke"),
        accountReference: accountReferenceController.text,
        phoneNumber: phoneNumber,
        baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
        transactionDesc: "purchase",
        passKey: "Jbud9cXh6pUUogIf0Xb4uiONIQ7kOYnIGzMmqHT6G64datz/t+CPhiJIxmJCsrod2MSBakFMPlwJFKKLwcBGlB+6o8IqvEjKZm69B0ebh/okXEgZp8lA2ZZweRJc1bsv0wxPGWq0v7nWP2oJVCZBhhkEFfQkOFgTUnKczU52d+2RXq7ZwvUJFx0XA21wdznHkTGFShYTiUMppDACOG+aYP9BT08re/nfRfOn381104m77cbo3qeYbSAjcmuVyRftugWQSm8NPiqAFSCgt0LHJpbFfLyZ52qO8MZOXhSwhRAlD/INPtW0E3tllh574MYTeCJz0AYghfSSA8twnHZQUA==",
      );

      print("TRANSACTION RESULT: " + transactionInitialization.toString());
    } catch (e) {
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF481E4D)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mpesa Payment Demo'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: accountReferenceController,
                  decoration: const InputDecoration(
                    labelText: 'Account Reference',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(

                  onPressed: () {
                    lipaNaMpesa();
                  },
                  child: const Text(
                    "Lipa na Mpesa",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
