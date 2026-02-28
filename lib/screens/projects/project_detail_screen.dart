import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the first dummy project for preview
    final project = dummyProjects[0];
    final client = dummyClients.firstWhere((c) => c.id == project.clientId);
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.work_outline, size: 80, color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          project.status,
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Client Info', context),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(client.avatarUrl)),
                      title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(client.email),
                      trailing: IconButton(icon: const Icon(Icons.message_outlined), onPressed: () {}),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Project Details', context),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(Icons.calendar_today, 'Deadline', dateFormat.format(project.deadline)),
                          const Divider(),
                          _buildDetailRow(Icons.monetization_on_outlined, 'Budget', '${AppConstants.currencySymbol}${project.budget.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Tasks', context),
                  Card(
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('UI Design Phase 1', style: TextStyle(decoration: TextDecoration.lineThrough)),
                          value: true,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (val) {},
                        ),
                        const Divider(height: 1),
                        CheckboxListTile(
                          title: const Text('Frontend Development'),
                          value: false,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (val) {},
                        ),
                        const Divider(height: 1),
                        CheckboxListTile(
                          title: const Text('Backend Integration'),
                          value: false,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Mark as Completed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}