import 'package:flutter/material.dart';
import 'package:homeklin/administratorscreens/adminhome/vancollection.dart';
import 'adminfindroutes.dart';
import 'adminsendnotification.dart';
import 'adminviewsentnotifications.dart';


class AdminCustomBottomNavigator extends StatefulWidget {
  const AdminCustomBottomNavigator({super.key});

  @override
  State<AdminCustomBottomNavigator> createState() => AdminCustomBottomNavigatorState();
}

class AdminCustomBottomNavigatorState extends State<AdminCustomBottomNavigator> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _navigateToScreen(index);
    });
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VanCollection(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminSendNotifications(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Adminfindroutes(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminsentNotificationScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Send Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Notification',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.indigo,
      onTap: _onItemTapped,
    );
  }
}
