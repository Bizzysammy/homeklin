import 'package:flutter/material.dart';
import '../colors/colors.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.sizeOf(context);

    return MaterialApp(
      title: 'Homeklin',
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
                Divider(
                  height: screenSize.height * 0.05,
                  thickness: screenSize.width * 0.02,
                  color: Colors.white,
                ),
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
                    radius: screenSize.width * 0.3,
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.15,
                      vertical: screenSize.height * 0.03,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.1),
                    ),
                  ),
                  child: Text(
                    'START',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenSize.width * 0.03,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    CircleAvatar(
                      radius: screenSize.width * 0.03,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    CircleAvatar(
                      radius: screenSize.width * 0.03,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
