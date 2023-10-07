import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'dart:async';

void main() {
  MpesaFlutterPlugin.setConsumerKey("Your Consumer Key from the safaricom portal, its random eg.'8joAntLHTIT28Pup....'");
  MpesaFlutterPlugin.setConsumerSecret("Your Consumer Secret from the safaricom portal, its random eg. 'kjiUWoPT4...'");
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
      transactionInitialization = await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: "174379",
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: double.parse(amountController.text),
        partyA: phoneNumberController.text,
        partyB: "174379",
        callBackURL: Uri(
          scheme: "https",
          host: "mpesa-requestbin.herokuapp.com",
          path: "/1hhy6391",
        ),
        accountReference: accountReferenceController.text,
        phoneNumber: phoneNumberController.text,
        baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
        transactionDesc: "purchase",
        passKey: "Get Your Pass Key from Test Credentials its random eg..'c893059b1788uihh'...",
      );
      // This passkey has been generated from Test Credentials from Safaricom Portal
      print("TRANSACTION RESULT: " + transactionInitialization.toString());
      // Let's print the transaction results to the console at this step
      return transactionInitialization;
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
