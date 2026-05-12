
// --- MODELS ---

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
  });
}

class Project {
  final String id;
  final String title;
  final String clientId;
  final double budget;
  final DateTime deadline;
  final String status; // Pending, In Progress, Completed

  Project({
    required this.id,
    required this.title,
    required this.clientId,
    required this.budget,
    required this.deadline,
    required this.status,
  });
}

class InvoiceItem {
  final String description;
  final double amount;

  InvoiceItem({required this.description, required this.amount});
}

class Invoice {
  final String id;
  final String projectId;
  final String clientId;
  final List<InvoiceItem> items;
  final DateTime issueDate;
  final DateTime dueDate;
  final String status; // Paid, Unpaid

  Invoice({
    required this.id,
    required this.projectId,
    required this.clientId,
    required this.items,
    required this.issueDate,
    required this.dueDate,
    required this.status,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.amount);
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // Freelancer, Admin
  final bool isActive;
  final String avatarUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
    required this.avatarUrl,
  });
}

// --- NEW DATA MODELS ---

class ProjectTask {
  final String id;
  final String projectId;
  String title;
  String description;
  String status; // 'To Do', 'In Progress', 'Done'

  ProjectTask({
    required this.id,
    required this.projectId,
    required this.title,
    this.description = '',
    this.status = 'To Do',
  });
}

class TimeEntry {
  final String id;
  final String projectId;
  final Duration duration;
  final DateTime date;
  final String note;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.duration,
    required this.date,
    this.note = '',
  });
}

class ProjectFile {
  final String id;
  final String projectId;
  final String name;
  final String url;
  final double sizeMb;

  ProjectFile({
    required this.id,
    required this.projectId,
    required this.name,
    required this.url,
    required this.sizeMb,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });
}

// --- REMINDER OPTION ENUM ---

enum ReminderOption {
  thirtyMin('30 minutes before', Duration(minutes: 30)),
  oneHour('1 hour before', Duration(hours: 1)),
  threeHours('3 hours before', Duration(hours: 3)),
  oneDay('1 day before', Duration(days: 1));

  const ReminderOption(this.label, this.duration);
  final String label;
  final Duration duration;
}

// --- MEETING MODEL ---

class Meeting {
  final String id;
  String title;
  String description;
  String? projectId;
  String? clientId;
  DateTime scheduledAt;
  ReminderOption reminder;
  bool isDone;

  Meeting({
    required this.id,
    required this.title,
    this.description = '',
    this.projectId,
    this.clientId,
    required this.scheduledAt,
    this.reminder = ReminderOption.oneHour,
    this.isDone = false,
  });

  DateTime get reminderTime => scheduledAt.subtract(reminder.duration);

  bool get isReminderDue {
    final now = DateTime.now();
    return !isDone && now.isAfter(reminderTime) && now.isBefore(scheduledAt.add(const Duration(minutes: 5)));
  }

  bool get isUpcoming => !isDone && scheduledAt.isAfter(DateTime.now());
  bool get isPast => scheduledAt.isBefore(DateTime.now());
}

// --- DUMMY DATA ---

final List<Client> dummyClients = [
  Client(id: 'c1', name: 'Acme Corp', email: 'contact@acme.com', phone: '+1 234 567 890', avatarUrl: 'https://i.pravatar.cc/150?u=c1'),
  Client(id: 'c2', name: 'Globex Inc', email: 'info@globex.com', phone: '+1 987 654 321', avatarUrl: 'https://i.pravatar.cc/150?u=c2'),
  Client(id: 'c3', name: 'Soylent Corp', email: 'hello@soylent.com', phone: '+1 555 123 456', avatarUrl: 'https://i.pravatar.cc/150?u=c3'),
  Client(id: 'c4', name: 'Initech', email: 'billing@initech.com', phone: '+1 444 999 888', avatarUrl: 'https://i.pravatar.cc/150?u=c4'),
];

final List<Project> dummyProjects = [
  Project(id: 'p1', title: 'Website Redesign', clientId: 'c1', budget: 5000.0, deadline: DateTime.now().add(const Duration(days: 15)), status: 'In Progress'),
  Project(id: 'p2', title: 'Mobile App MVP', clientId: 'c2', budget: 12000.0, deadline: DateTime.now().add(const Duration(days: 45)), status: 'Pending'),
  Project(id: 'p3', title: 'SEO Optimization', clientId: 'c1', budget: 1500.0, deadline: DateTime.now().subtract(const Duration(days: 5)), status: 'Completed'),
  Project(id: 'p4', title: 'E-commerce Platform', clientId: 'c4', budget: 25000.0, deadline: DateTime.now().add(const Duration(days: 60)), status: 'In Progress'),
];

final List<Invoice> dummyInvoices = [
  Invoice(
    id: 'INV-001',
    projectId: 'p3',
    clientId: 'c1',
    items: [
      InvoiceItem(description: 'Initial SEO Audit', amount: 500),
      InvoiceItem(description: 'Keyword Research & Implementation', amount: 1000),
    ],
    issueDate: DateTime.now().subtract(const Duration(days: 10)),
    dueDate: DateTime.now().add(const Duration(days: 5)),
    status: 'Paid',
  ),
  Invoice(
    id: 'INV-002',
    projectId: 'p1',
    clientId: 'c1',
    items: [
      InvoiceItem(description: 'UI/UX Design Phase 1', amount: 2500),
    ],
    issueDate: DateTime.now().subtract(const Duration(days: 2)),
    dueDate: DateTime.now().add(const Duration(days: 12)),
    status: 'Unpaid',
  ),
  Invoice(
    id: 'INV-003',
    projectId: 'p4',
    clientId: 'c4',
    items: [
      InvoiceItem(description: 'Frontend Setup', amount: 5000),
      InvoiceItem(description: 'Database design', amount: 3000),
    ],
    issueDate: DateTime.now().subtract(const Duration(days: 1)),
    dueDate: DateTime.now().add(const Duration(days: 14)),
    status: 'Unpaid',
  ),
];

final List<AppUser> dummyUsers = [
  AppUser(id: 'u1', name: 'John Doe', email: 'john@freelancer.com', role: 'Freelancer', avatarUrl: 'https://i.pravatar.cc/150?u=u1'),
  AppUser(id: 'u2', name: 'Jane Smith', email: 'jane@freelancer.com', role: 'Freelancer', isActive: false, avatarUrl: 'https://i.pravatar.cc/150?u=u2'),
  AppUser(id: 'u3', name: 'Admin Master', email: 'admin@system.com', role: 'Admin', avatarUrl: 'https://i.pravatar.cc/150?u=u3'),
  AppUser(id: 'u4', name: 'Mike Ross', email: 'mike@freelancer.com', role: 'Freelancer', avatarUrl: 'https://i.pravatar.cc/150?u=u4'),
];

// --- NEW DUMMY DATA ---

final List<ProjectTask> dummyTasks = [
  ProjectTask(id: 't1', projectId: 'p1', title: 'UI Design Phase 1', status: 'Done', description: 'Design core screens'),
  ProjectTask(id: 't2', projectId: 'p1', title: 'Frontend Development', status: 'In Progress', description: 'Implement design in Flutter'),
  ProjectTask(id: 't3', projectId: 'p1', title: 'Backend Integration', status: 'To Do', description: 'Integrate with APIs'),
  ProjectTask(id: 't4', projectId: 'p1', title: 'QA Testing', status: 'To Do'),
];

final List<TimeEntry> dummyTimeEntries = [
  TimeEntry(id: 'te1', projectId: 'p1', duration: const Duration(hours: 2, minutes: 30), date: DateTime.now().subtract(const Duration(days: 2)), note: 'UI Design'),
  TimeEntry(id: 'te2', projectId: 'p1', duration: const Duration(hours: 4), date: DateTime.now().subtract(const Duration(days: 1)), note: 'Frontend Setup'),
];

final List<ProjectFile> dummyFiles = [
  ProjectFile(id: 'f1', projectId: 'p1', name: 'Design_Assets.zip', url: 'https://example.com/assets.zip', sizeMb: 24.5),
  ProjectFile(id: 'f2', projectId: 'p1', name: 'Requirements.pdf', url: 'https://example.com/req.pdf', sizeMb: 1.2),
];

final List<AppNotification> dummyNotifications = [
  AppNotification(id: 'n1', title: 'New Project Assigned', message: 'You have been assigned to Web Redesign.', date: DateTime.now().subtract(const Duration(hours: 2))),
  AppNotification(id: 'n2', title: 'Invoice Paid', message: 'Globex Inc paid INV-002.', date: DateTime.now().subtract(const Duration(days: 1)), isRead: true),
  AppNotification(id: 'n3', title: 'Meeting Reminder', message: 'Team sync in 30 mins.', date: DateTime.now().subtract(const Duration(minutes: 5))),
];

// Meetings — seeded relative to now so reminders are demo-ready
final List<Meeting> dummyMeetings = [
  Meeting(
    id: 'm1',
    title: 'Acme Corp Kickoff Call',
    description: 'Discuss project requirements and timeline with the Acme team.',
    clientId: 'c1',
    projectId: 'p1',
    // Scheduled 25 min from now — reminder (30 min before) fires immediately on launch
    scheduledAt: DateTime.now().add(const Duration(minutes: 25)),
    reminder: ReminderOption.thirtyMin,
  ),
  Meeting(
    id: 'm2',
    title: 'Mobile App MVP Review',
    description: 'Review MVP deliverables with Globex Inc.',
    clientId: 'c2',
    projectId: 'p2',
    scheduledAt: DateTime.now().add(const Duration(hours: 3)),
    reminder: ReminderOption.oneHour,
  ),
  Meeting(
    id: 'm3',
    title: 'Weekly Status Sync',
    description: 'Weekly sync to discuss blockers and progress.',
    clientId: 'c4',
    projectId: 'p4',
    scheduledAt: DateTime.now().add(const Duration(days: 1)),
    reminder: ReminderOption.oneDay,
  ),
  Meeting(
    id: 'm4',
    title: 'SEO Campaign Wrap-up',
    description: 'Post-project retrospective and invoice handover.',
    clientId: 'c1',
    projectId: 'p3',
    scheduledAt: DateTime.now().subtract(const Duration(days: 2)),
    reminder: ReminderOption.oneHour,
    isDone: true,
  ),
];

// --- APP CONSTANTS ---

class AppConstants {
  static const String currencySymbol = '\$';
}
