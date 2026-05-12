import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  // We'll use the first project for demo
  late Project project;
  late Client client;
  final dateFormat = DateFormat('MMMM dd, yyyy');

  // Timers state
  bool _isTimerRunning = false;
  DateTime? _timerStartTime;

  @override
  void initState() {
    super.initState();
    project = dummyProjects[0];
    client = dummyClients.firstWhere((c) => c.id == project.clientId);
  }

  List<ProjectTask> get projectTasks => dummyTasks.where((t) => t.projectId == project.id).toList();
  List<TimeEntry> get projectTimeEntries => dummyTimeEntries.where((t) => t.projectId == project.id).toList();
  List<ProjectFile> get projectFiles => dummyFiles.where((f) => f.projectId == project.id).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
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
                bottom: const TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Tasks'),
                    Tab(text: 'Time'),
                    Tab(text: 'Files'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildOverviewTab(),
              _buildTasksTab(),
              _buildTimeTab(),
              _buildFilesTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
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
          _buildSectionTitle('Client Info'),
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(client.avatarUrl)),
              title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(client.email),
              trailing: IconButton(icon: const Icon(Icons.message_outlined), onPressed: () {}),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Project Details'),
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark as Completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kanban tasks
  Widget _buildTasksTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Task Kanban', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(onPressed: _showAddTaskDialog, icon: const Icon(Icons.add_task)),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'To Do'),
                    Tab(text: 'In Progress'),
                    Tab(text: 'Done'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTaskList('To Do'),
                      _buildTaskList('In Progress'),
                      _buildTaskList('Done'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList(String statusFilter) {
    final filteredTasks = projectTasks.where((t) => t.status == statusFilter).toList();
    if (filteredTasks.isEmpty) {
      return Center(child: Text('No tasks in $statusFilter', style: const TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          elevation: 2,
          child: ListTile(
            title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: task.description.isNotEmpty ? Text(task.description) : null,
            trailing: PopupMenuButton<String>(
              onSelected: (newStatus) {
                setState(() {
                  task.status = newStatus;
                });
              },
              itemBuilder: (context) => ['To Do', 'In Progress', 'Done']
                  .map((s) => PopupMenuItem(value: s, child: Text('Move to $s')))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog() {
    final ctr = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: ctr,
          decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (ctr.text.isNotEmpty) {
                setState(() {
                  dummyTasks.add(ProjectTask(id: DateTime.now().millisecondsSinceEpoch.toString(), projectId: project.id, title: ctr.text));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  // Time Tracking
  Widget _buildTimeTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          child: Column(
            children: [
              Text(
                _isTimerRunning ? 'Timer is running...' : 'Ready to work?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (_isTimerRunning) {
                      // Stop timer and record
                      final duration = DateTime.now().difference(_timerStartTime!);
                      dummyTimeEntries.insert(0, TimeEntry(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        projectId: project.id,
                        duration: duration,
                        date: DateTime.now(),
                        note: 'Recorded Session',
                      ));
                      _isTimerRunning = false;
                      _timerStartTime = null;
                    } else {
                      _isTimerRunning = true;
                      _timerStartTime = DateTime.now();
                    }
                  });
                },
                icon: Icon(_isTimerRunning ? Icons.stop : Icons.play_arrow),
                label: Text(_isTimerRunning ? 'Stop Timer' : 'Start Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTimerRunning ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: projectTimeEntries.isEmpty
              ? const Center(child: Text('No time recorded yet.'))
              : ListView.builder(
                  itemCount: projectTimeEntries.length,
                  itemBuilder: (context, index) {
                    final entry = projectTimeEntries[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.timer, color: Colors.white),
                      ),
                      title: Text('${entry.duration.inHours}h ${entry.duration.inMinutes.remainder(60)}m', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${dateFormat.format(entry.date)} • ${entry.note}'),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // File Upload
  Widget _buildFilesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Mock upload
                setState(() {
                  dummyFiles.add(ProjectFile(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    projectId: project.id,
                    name: 'New_Upload_${DateTime.now().second}.png',
                    url: 'https://example.com/new',
                    sizeMb: 2.5,
                  ));
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File Uploaded!')));
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
        ),
        Expanded(
          child: projectFiles.isEmpty
              ? const Center(child: Text('No files attached.'))
              : ListView.builder(
                  itemCount: projectFiles.length,
                  itemBuilder: (context, index) {
                    final file = projectFiles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file, color: Colors.blue, size: 32),
                        title: Text(file.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${file.sizeMb} MB'),
                        trailing: IconButton(icon: const Icon(Icons.download), onPressed: () {}),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
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