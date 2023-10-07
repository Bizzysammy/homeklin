import 'package:flutter/material.dart';
import 'package:homeklin/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:homeklin/vandriverscreens/vanprovider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Homeklin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
