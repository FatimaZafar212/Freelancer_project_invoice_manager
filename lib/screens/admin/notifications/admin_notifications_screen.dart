import 'package:flutter/material.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'New invoice created', 'subtitle': 'by John Doe', 'icon': Icons.receipt, 'color': Colors.green},
      {'title': 'New project added', 'subtitle': 'Website Update', 'icon': Icons.work, 'color': Colors.blue},
      {'title': 'Payment received', 'subtitle': '\$500 from Acme Corp', 'icon': Icons.monetization_on, 'color': Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: (notif['color'] as Color).withValues(alpha: 0.1),
              child: Icon(notif['icon'] as IconData, color: notif['color'] as Color),
            ),
            title: Text(notif['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notif['subtitle'] as String),
            trailing: const Text('2h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
          );
        },
      ),
    );
  }
}
