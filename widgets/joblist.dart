import 'package:flutter/material.dart';

class JobListWidget extends StatelessWidget {
  final String name;
  final String transactionLocation;
  final bool isPaid;

  const JobListWidget({
    super.key,
    required this.name,
    required this.transactionLocation,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPaid ? Colors.green : Colors.red,
        ),
        child: Center(
          child: Text(
            name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      title: Text(name),
      subtitle: Text(transactionLocation),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isPaid ? 'Paid' : 'Pending',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPaid ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isPaid ? Icons.check_circle : Icons.pending_actions,
            color: isPaid ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
