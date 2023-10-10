import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeklin/colors/colors.dart';

class Vanforgettingpassword extends StatefulWidget {
  const Vanforgettingpassword({Key? key}) : super(key: key);

  @override
  State<Vanforgettingpassword> createState() => _VanforgettingpasswordState();
}

class _VanforgettingpasswordState extends State<Vanforgettingpassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _newPassword;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateProfile() async {
    try {
      final user = _auth.currentUser; // Get the currently signed-in user
      if (user != null) {
        if (_newPassword != null) {
          await user.updatePassword(_newPassword!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update password')),
      );
    }
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
            child: Builder(
              builder: (BuildContext scaffoldContext) {
                // Use a Builder widget to get a Scaffold ancestor
                return Column(
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
                          // TextFormField for email
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                            onChanged: (value) {
                              setState(() {
                              });
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'New Password',
                              hintText: 'Enter a new password',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _newPassword = value;
                              });
                            },
                            obscureText: true,
                          ),

                          SizedBox(height: screenSize.height * 0.02),
                          ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              shape: const RoundedRectangleBorder(),
                              minimumSize: Size(
                                screenSize.width * 0.3,
                                screenSize.height * 0.02,
                              ),
                            ),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
