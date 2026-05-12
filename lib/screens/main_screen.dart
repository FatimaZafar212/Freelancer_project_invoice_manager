import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'clients/client_list_screen.dart';
import 'projects/project_list_screen.dart';
import 'invoices/invoice_list_screen.dart';
import 'meetings/meetings_screen.dart';
import 'profile/profile_screen.dart';
import '../services/meeting_reminder_service.dart';
import 'notifications/freelancer_notifications_screen.dart';
import '../utils/constants.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Timer? _reminderTimer;
  final _svc = MeetingReminderService();
  final List<String> _notifiedIds = [];

  final List<Widget> _screens = const [
    DashboardScreen(),
    ClientListScreen(),
    ProjectListScreen(),
    InvoiceListScreen(),
    MeetingsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Run once immediately, then every 60 seconds
    _svc.checkReminders();
    _reminderTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _svc.checkReminders();
      _showReminderSnackBar();
    });
    // Also listen to reactive changes
    _svc.activeReminders.addListener(_showReminderSnackBar);
  }

  void _showReminderSnackBar() {
    final reminders = _svc.activeReminders.value;
    if (reminders.isEmpty || !mounted) return;
    for (final m in reminders) {
      if (!_notifiedIds.contains(m.id)) {
        _notifiedIds.add(m.id);
        // Show snackbar for newly-triggered reminders
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Text('⏰  ', style: TextStyle(fontSize: 16)),
                Expanded(
                    child: Text('Reminder: ${m.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
              ]),
              backgroundColor: const Color(0xFFFF8C00),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              action: SnackBarAction(
                label: 'View',
                textColor: Colors.white,
                onPressed: () => setState(() => _currentIndex = 4),
              ),
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    _svc.activeReminders.removeListener(_showReminderSnackBar);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = dummyNotifications.where((n) => !n.isRead).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelancer Manager'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '$unreadCount', 
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), 
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FreelancerNotificationsScreen())).then((_) {
                 // Refresh when coming back in case read status changed
                 setState((){});
              });
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Clients',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Invoices',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Meetings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
