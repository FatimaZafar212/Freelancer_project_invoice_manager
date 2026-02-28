import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class ProjectMonitoringScreen extends StatefulWidget {
  const ProjectMonitoringScreen({super.key});

  @override
  State<ProjectMonitoringScreen> createState() => _ProjectMonitoringScreenState();
}

class _ProjectMonitoringScreenState extends State<ProjectMonitoringScreen> {
  String searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    final filteredProjects = dummyProjects.where((p) => p.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('All Projects (Admin)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                final project = filteredProjects[index];
                final client = dummyClients.firstWhere((c) => c.id == project.clientId);
                final freelancer = dummyUsers.firstWhere((u) => u.role == 'Freelancer');
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Client: ${client.name}'),
                        Text('Freelancer: ${freelancer.name}', style: const TextStyle(color: Colors.grey)),
                        Text('Budget: ${AppConstants.currencySymbol}${project.budget}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(project.status, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: project.status == 'Completed' ? Colors.green : (project.status == 'Pending' ? Colors.redAccent : Colors.orange),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
