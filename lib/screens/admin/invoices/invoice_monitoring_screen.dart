import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class InvoiceMonitoringScreen extends StatelessWidget {
  const InvoiceMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Invoices (Admin)')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyInvoices.length,
        itemBuilder: (context, index) {
          final invoice = dummyInvoices[index];
          final client = dummyClients.firstWhere((c) => c.id == invoice.clientId);
          final freelancer = dummyUsers.firstWhere((u) => u.role == 'Freelancer');
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: invoice.status == 'Paid' ? Colors.green.withValues(alpha: 0.2) : Colors.redAccent.withValues(alpha: 0.2),
                child: Icon(Icons.receipt, color: invoice.status == 'Paid' ? Colors.green : Colors.redAccent),
              ),
              title: Text('Invoice #${invoice.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Client: ${client.name}'),
                  Text('Freelancer: ${freelancer.name}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${AppConstants.currencySymbol}${invoice.totalAmount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(invoice.status, style: TextStyle(color: invoice.status == 'Paid' ? Colors.green : Colors.redAccent)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
