import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import'login_screen.dart';
import '../colors/colors.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


final TextEditingController _nameController = TextEditingController();
final TextEditingController _locationController = TextEditingController();
final TextEditingController _phoneNumberController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _confirmPasswordController =
TextEditingController();

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold( // Wrap your widget tree with Scaffold
      appBar: AppBar(
        title: const Text('Homeklin'),
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
                Text("Register Now for a waste free Zone",
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
                  //textformfilds for both email and password
                  SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.04,
                    child: TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        hintStyle: const TextStyle(
                          color: AppColors.inactiveColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.inactiveColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.04,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: AppColors.inactiveColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.inactiveColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.04,
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(
                          color: AppColors.inactiveColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.inactiveColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.02),
                  SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.04,
                    child: TextField(
                      controller: _locationController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        hintStyle: const TextStyle(
                          color: AppColors.inactiveColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.inactiveColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.04,
                    child: TextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: AppColors.inactiveColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.inactiveColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.04,
                    child: TextField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                          color: AppColors.inactiveColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.inactiveColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen()));
                        },
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
                          register(context);
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
                          'SIGN UP',
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
            Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: AppColors.inactiveColor,
                ),
                children: [
                  TextSpan(
                    text: 'Log In',
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
                                builder: (context) => LoginScreen()));
                      },
                  ),
                ],
              ),
            ),
          ]),
        ),
    );
  }
}
void register(BuildContext context) async {
  // Get the values from the form fields
  String name = _nameController.text;
  String location = _locationController.text;
  String phoneNumber = _phoneNumberController.text;
  String email = _emailController.text;
  String password = _passwordController.text;
  String confirmPassword = _confirmPasswordController.text;

  // Validate the form fields
  if (name.isEmpty ||
      location.isEmpty ||
      phoneNumber.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty) {
    _showErrorSnackBar(context, 'All fields are required');
    return;
  }

  if (password != confirmPassword) {
    _showErrorSnackBar(context, 'Passwords do not match');
    return;
  }

  try {
    // Create a new user in Firebase Authentication
    UserCredential customerCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Save user data to Firebase Firestore
    await FirebaseFirestore.instance
        .collection('Customers')
        .doc(customerCredential.user!.uid)
        .set({
      'name': name,
      'location': location,
      'phoneNumber': phoneNumber,
      'email': email,
    });

    // Navigate to the login page or any other destination
    // Here, we are assuming there's a `LoginScreen` widget defined
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } catch (e) {
    _showErrorSnackBar(context, 'Registration failed: $e');
  }
}

void _showErrorSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
