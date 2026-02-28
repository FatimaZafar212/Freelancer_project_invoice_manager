import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {
    'name': 'John Doe',
    'email': 'john@freelancer.com',
    'phone': '+1 234 567 8900',
    'avatarUrl': 'https://i.pravatar.cc/150?u=u1',
    'skills': 'Flutter, Dart, Firebase',
  };

  void _navigateToEditProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(initialData: userData)),
    );

    if (updatedData != null) {
      setState(() {
        userData = updatedData as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(userData['avatarUrl']),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userData['name'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const Text(
                          'Senior Freelancer',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('Personal Information', context),
                  Card(
                    child: Column(
                      children: [
                        _buildProfileItem(Icons.email_outlined, 'Email', userData['email'], context),
                        const Divider(height: 1),
                        _buildProfileItem(Icons.phone_outlined, 'Phone', userData['phone'], context),
                        const Divider(height: 1),
                        _buildProfileItem(Icons.star_outline, 'Skills', userData['skills'], context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Settings', context),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Notifications'),
                          subtitle: const Text('Receive alerts for new messages'),
                          value: true,
                          activeThumbColor: colorScheme.primary,
                          onChanged: (val) {},
                          secondary: const Icon(Icons.notifications_active_outlined),
                        ),
                        const Divider(height: 1),
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: themeNotifier,
                          builder: (context, currentMode, child) {
                            return SwitchListTile(
                              title: const Text('Dark Mode'),
                              subtitle: const Text('Toggle dark theme'),
                              value: currentMode == ThemeMode.dark,
                              activeThumbColor: colorScheme.primary,
                              onChanged: (val) {
                                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                              },
                              secondary: const Icon(Icons.dark_mode_outlined),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _navigateToEditProfile,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value, BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}