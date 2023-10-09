import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'vanregister.dart';
import'vandrivershomescreen.dart';
import '../colors/colors.dart';

class VanLoginScreen extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   VanLoginScreen({super.key});

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      // Show circular progress indicator while logging in
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Van Drivers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Remove the progress indicator
        Navigator.pop(context);

        _showErrorSnackBar(context, 'User not found, only customers can login here');
        return;
      }
      // Sign in the user with Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Remove the progress indicator
      Navigator.pop(context);

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Vandrivershomescreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Remove the progress indicator
      Navigator.pop(context);

      // Show error message to the user
      if (e.code == 'user-not-found') {
        _showErrorSnackBar(context, 'User not found');
      } else if (e.code == 'wrong-password') {
        _showErrorSnackBar(context, 'Wrong password');
      } else {
        _showErrorSnackBar(
            context, 'An error occurred. Please try again later.');
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return MaterialApp(
      title: 'Homekline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenSize.height * 0.05),
                Text(
                  'HOMEKLIN (U) LTD',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  height: screenSize.height * 0.05,
                  thickness: screenSize.width * 0.02,
                  color: Colors.white,
                ),
                SizedBox(height: screenSize.height * 0.05),
                Center(
                  child: CircleAvatar(
                    radius: screenSize.width * 0.2,
                    backgroundImage: const AssetImage('assets/logo.jpg'),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Text(
                  '"A Clean Environment awaits"',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Text(
                  'Van Driver login',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Container(
                    width: double.infinity,
                    height: screenSize.height * 0.6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenSize.height * 0.02),
                        //textformfilds for both email and password
                        SizedBox(
                          width: screenSize.width * 0.8,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: AppColors.inactiveColor,
                              ),
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.accentColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        SizedBox(
                          width: screenSize.width * 0.8,
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: AppColors.inactiveColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.accentColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),


                        ElevatedButton(
                          onPressed: () {
                            login(context, _emailController.text, _passwordController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            shape: const RoundedRectangleBorder(),
                            minimumSize: Size(
                              screenSize.width * 0.3,
                              screenSize.height * 0.02,
                            ),
                          ),
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Text.rich(
                          TextSpan(
                            text: 'New to HOMEKLIN? ',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inactiveColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const VanRegisterScreen()));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
