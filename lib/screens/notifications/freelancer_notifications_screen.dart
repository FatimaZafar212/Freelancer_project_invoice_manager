import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class FreelancerNotificationsScreen extends StatefulWidget {
  const FreelancerNotificationsScreen({super.key});

  @override
  State<FreelancerNotificationsScreen> createState() => _FreelancerNotificationsScreenState();
}

class _FreelancerNotificationsScreenState extends State<FreelancerNotificationsScreen> {
  final dateFormat = DateFormat('MMM dd, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var n in dummyNotifications) {
                  n.isRead = true;
                }
              });
            },
            tooltip: 'Mark all as read',
          )
        ],
      ),
      body: dummyNotifications.isEmpty
          ? const Center(child: Text('No notifications right now.'))
          : ListView.builder(
              itemCount: dummyNotifications.length,
              itemBuilder: (context, index) {
                final notification = dummyNotifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification.isRead ? Colors.grey.shade300 : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.notifications,
                      color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold),
                  ),
                  subtitle: Text(notification.message),
                  trailing: Text(dateFormat.format(notification.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  onTap: () {
                    if (!notification.isRead) {
                      setState(() {
                        notification.isRead = true;
                      });
                    }
                  },
                );
              },
            ),
    );
  }
}
