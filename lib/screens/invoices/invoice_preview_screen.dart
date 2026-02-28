import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoicePreviewScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final client = dummyClients.firstWhere((c) => c.id == invoice.clientId);
    final project = dummyProjects.firstWhere((p) => p.id == invoice.projectId);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${invoice.id}'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.print), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('INVOICE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('No: ${invoice.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Date: ${dateFormat.format(invoice.issueDate)}'),
                      Text('Due: ${dateFormat.format(invoice.dueDate)}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Billed To:', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(client.email),
                      Text(client.phone),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Project:', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(thickness: 2),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(thickness: 2),
              ...invoice.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.description),
                    Text('${AppConstants.currencySymbol}${item.amount.toStringAsFixed(2)}'),
                  ],
                ),
              )),
              const Divider(thickness: 2),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Total Due: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${AppConstants.currencySymbol}${invoice.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
              const SizedBox(height: 48),
              if (invoice.status == 'Paid')
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('PAID', style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}