import 'package:flutter/material.dart';
import 'package:homeklin/screens/completedorders.dart';
import 'package:homeklin/screens/pendingorders.dart';
import 'package:homeklin/screens/rejectedorders.dart';
import '../widgets/custom_bottomnav.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);
  static const String id = 'my_orders';

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'MY ORDERS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF213C54),
                Color(0xFF0059A5),
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF213C54),
                  Color(0xFF0059A5),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          // List view of orders
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Buttons for different order statuses

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PendingOrdersScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Pending'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CompletedOrdersScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Completed'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RejectedOrdersScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Rejected'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
