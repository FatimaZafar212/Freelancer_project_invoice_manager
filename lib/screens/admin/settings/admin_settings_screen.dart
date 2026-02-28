import 'package:flutter/material.dart';
import '../../../main.dart';
import '../users/user_management_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
            child: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle system-wide dark theme'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: currentMode == ThemeMode.dark,
                  activeThumbColor: Colors.red[800],
                  onChanged: (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notifications'),
                  subtitle: const Text('Enable or disable system alerts'),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  value: notificationsEnabled,
                  activeThumbColor: Colors.red[800],
                  onChanged: (val) => setState(() => notificationsEnabled = val),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('App Language'),
                  subtitle: const Text('English (US)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Default Currency'),
                  subtitle: const Text('USD (\$)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Manage Freelancers'),
              subtitle: const Text('View and edit active users'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
