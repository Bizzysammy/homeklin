

import 'package:flutter/material.dart';
import 'package:uganda_mobile_money/uganda_mobile_money.dart';
import '../colors/colors.dart';


class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  static const String id = 'PaymentsScreen';

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}
final nameController = TextEditingController();
final phonenumberController = TextEditingController();
final amountController = TextEditingController();
final referenceController = TextEditingController();
final emailController = TextEditingController();
final networkController = TextEditingController();

const secretKey = "FLWSECK_TEST-21436eb34770d6d936869491e5607a07-X"; // Replace with your actual Flutterwave secret key
UgandaMobileMoney _mobileMoney = UgandaMobileMoney(secretKey: secretKey);

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold( // Wrap your widget tree with Scaffold
      appBar: AppBar(
        title: const Text('Homeklin Payments Screen'),
      ),
      body: SingleChildScrollView(
        child: Column (mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: double.infinity,
            height: screenSize.height * 0.2,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(children: [
              SizedBox(height: screenSize.height * 0.03),
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
              SizedBox(height: screenSize.height * 0.03),
              Text("Mobile Money Payments",
                  style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ]),
          ),
          //textformfield for Full name, genter, phone number Email, location password confirm pass word
          SizedBox(height: screenSize.height * 0.04),
          Container(
            width: double.infinity,
            height: screenSize.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.05),
                SizedBox(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.04,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'enter your name',
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field missing';
                      }
                      return null; // Return null if the input is valid
                    },

                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                SizedBox(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.04,
                  child: TextFormField(
                    controller: phonenumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'enter your phone number',
                      prefixIcon: Icon(Icons.phone, color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field missing';
                      }
                      return null; // Return null if the input is valid
                    },

                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),

                SizedBox(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.04,
                  child: TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: 'enter the amount',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field missing';
                      }
                      return null; // Return null if the input is valid
                    },

                    ),
                  ),
                SizedBox(height: screenSize.height * 0.02),
                SizedBox(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.04,
                  child: TextFormField(
                    controller: networkController,
                    decoration: const InputDecoration(
                      labelText: 'Network',
                      hintText: 'MTN OR AIRTEL',
                      prefixIcon: Icon(Icons.network_cell, color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field missing';
                      }
                      return null; // Return null if the input is valid
                    },

                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                SizedBox(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.04,
                  child: TextFormField(
                    controller: referenceController,
                    decoration: const InputDecoration(
                      labelText: 'Reference',
                      hintText: 'enter the reference',
                      prefixIcon: Icon(Icons.message, color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field missing';
                      }
                      return null; // Return null if the input is valid
                    },

                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                SizedBox(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.04,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'enter your Email',
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field missing';
                      }
                      return null; // Return null if the input is valid
                    },

                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.01,
                          vertical: screenSize.height * 0.01,
                        ),
                        minimumSize: Size(
                          screenSize.width * 0.3,
                          screenSize.height * 0.02,
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.01),
                    Text(
                      'OR',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.03,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inactiveColor,
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.01),
                    ElevatedButton(
                      onPressed: () {
                        final String name = nameController.text;
                        final String phoneNumber = phonenumberController.text;
                        final String amount = amountController.text;
                        final String reference = referenceController.text;
                        final String email = emailController.text;

                        // Add validation logic here if needed

                        // Call the modified chargeClient function with client's input data
                        chargeClient(
                          reference: reference, // Generate a unique transaction reference
                          amount: amount,
                          email: email,
                          phoneNumber: phoneNumber,
                          name: name,
                          voucher: "128373", // Voucher information
                          network: UgandaNetwork.mtn, // Network selection
                          onSuccess: () {
                            // Show success dialog when payment is successful
                            showSuccessDialog(context);
                          },
                          onFailure: () {
                            // Show failure dialog when payment fails
                            showFailureDialog(context);
                          },
                        );
                            chargeClient(
                            reference: reference, // Generate a unique transaction reference
                            amount: amount,
                            email: email,
                            phoneNumber: phoneNumber,
                            name: name,
                            voucher: "128373", // Voucher information
                            network: UgandaNetwork.airtel,
                              onSuccess: () {
                                // Show success dialog when payment is successful
                                showSuccessDialog(context);
                              },
                              onFailure: () {
                                // Show failure dialog when payment fails
                                showFailureDialog(context);
                              },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.01,
                          vertical: screenSize.height * 0.01,
                        ),
                        minimumSize: Size(
                          screenSize.width * 0.3,
                          screenSize.height * 0.02,
                        ),
                      ),
                      child: Text(
                        'pay',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.03,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ]),
      ),
    );
  }
}
Future<void> chargeClient({
  required String reference,
  required String amount,
  required String email,
  required String phoneNumber,
  required String name,
  required String voucher,
  required UgandaNetwork network,
  void Function()? onSuccess,
  void Function()? onFailure,
}) async {
  MomoPayResponse response = await _mobileMoney.chargeClient(
    MomoPayRequest(
      txRef: reference,
      amount: amount,
      email: email,
      phoneNumber: phoneNumber,
      fullname: name,
      voucher: voucher,
      network: network,
      redirectUrl: '',
    ),
  );
  if (response.status == 'success' && onSuccess != null) {
    // Call the success callback if provided
    onSuccess();
  } else if (response.status != 'success' && onFailure != null) {
    // Call the failure callback if provided
    onFailure();
  }

  print(response.message);
}
void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your payment was successful.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showFailureDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text('Your payment failed. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
