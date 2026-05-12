import 'package:flutter/material.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final dynamic invoiceData;

  const InvoicePreviewScreen({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {

    List items = invoiceData['items'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Client: ${invoiceData['clientId']}"),
            Text("Project: ${invoiceData['projectId']}"),
            Text("Status: ${invoiceData['status']}"),

            const SizedBox(height: 20),

            const Text("Items:",
                style: TextStyle(fontWeight: FontWeight.bold)),

            ...items.map((item) => ListTile(
              title: Text(item['description']),
              trailing: Text("Rs ${item['amount']}"),
            )),

            const SizedBox(height: 20),

            Text(
              "Total: Rs ${invoiceData['total']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            if (invoiceData['status'] == 'Paid')
              const Text(
                "PAID",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
          ],
        ),
      ),
    );
  }
}