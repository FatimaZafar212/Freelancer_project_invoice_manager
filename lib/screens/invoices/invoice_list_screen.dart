import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'create_invoice_screen.dart';
import 'invoice_preview_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateInvoiceScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getInvoices(),
        builder: (context, snapshot) {

          // ✅ FIX 1: loading safe
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ FIX 2: null safety
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data found"));
          }

          final invoices = snapshot.data!.docs;

          // ✅ FIX 3: empty check
          if (invoices.isEmpty) {
            return const Center(child: Text("No invoices yet"));
          }

          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Invoice ${index + 1}"),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Client: ${invoice['clientId'] ?? 'N/A'}"),
                      Text("Status: ${invoice['status'] ?? 'Pending'}"),
                    ],
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rs ${invoice['total'] ?? 0}"),

                      const SizedBox(height: 5),

                      GestureDetector(
                        onTap: () async {
                          await invoices[index].reference.update({
                            'status': 'Paid'
                          });
                        },
                        child: const Text(
                          "Mark Paid",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),

                  // ❌ DELETE
                  onLongPress: () async {
                    await invoices[index].reference.delete();
                  },

                  // 👉 OPEN PREVIEW
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvoicePreviewScreen(
                          invoiceData: invoice,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}