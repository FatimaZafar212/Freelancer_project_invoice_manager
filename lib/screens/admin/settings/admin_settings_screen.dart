import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool newSignupsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Allow New Signups'),
            subtitle: const Text('Enable or disable new freelancer registrations'),
            value: newSignupsEnabled,
            onChanged: (val) => setState(() => newSignupsEnabled = val),
          ),
          const Divider(),
          ListTile(
            title: const Text('Default Platform Currency'),
            subtitle: const Text('USD (\$)'),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
          const Divider(),
          const ListTile(
            title: Text('Data Backup'),
            subtitle: Text('Last backup: Today at 2:00 AM'),
            trailing: Icon(Icons.backup),
          ),
        ],
      ),
    );
  }
}
