import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'create_invoice_screen.dart';
import 'invoice_preview_screen.dart';
import 'package:intl/intl.dart';
import '../../widgets/empty_state_view.dart';
import '../../theme/theme.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateInvoiceScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('New Invoice'),
      ),
      body: dummyInvoices.isEmpty
          ? const EmptyStateView(
              message: "You haven't generated any invoices yet.",
              icon: Icons.receipt_long_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyInvoices.length,
              itemBuilder: (context, index) {
                final invoice = dummyInvoices[index];
                final client = dummyClients.firstWhere((c) => c.id == invoice.clientId);
                
                final isPaid = invoice.status == 'Paid';
                final statusColor = isPaid ? const Color(0xFF03DAC6) : secondaryColor;
                final dateFormat = DateFormat('MMM dd, yyyy');

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => InvoicePreviewScreen(invoice: invoice)));
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.receipt_long, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(invoice.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${AppConstants.currencySymbol}${invoice.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To: ${client.name}'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Due: ${dateFormat.format(invoice.dueDate)}'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  invoice.status,
                                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}