
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

// --- APP CONSTANTS ---

class AppConstants {
  static const String currencySymbol = '\$';
}
