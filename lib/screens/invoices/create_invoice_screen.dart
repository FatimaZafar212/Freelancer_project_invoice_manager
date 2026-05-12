import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final TextEditingController clientController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  List<Map<String, dynamic>> items = [];

  double get total =>
      items.fold(0, (sum, item) => sum + (item['amount'] as double));

  void addItem() {
    if (descController.text.isNotEmpty &&
        amountController.text.isNotEmpty) {
      setState(() {
        items.add({
          'description': descController.text,
          'amount': double.tryParse(amountController.text) ?? 0,
        });

        descController.clear();
        amountController.clear();
      });
    }
  }

  Future<void> saveInvoice() async {
    if (clientController.text.isEmpty ||
        projectController.text.isEmpty ||
        items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      await FirestoreService().addInvoice(
        clientId: clientController.text,
        projectId: projectController.text,
        total: total,
        items: items.map((e) => {
          'description': e['description'],
          'amount': e['amount'],
        }).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invoice Saved Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // CLIENT
            TextField(
              controller: clientController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),

            const SizedBox(height: 10),

            // PROJECT
            TextField(
              controller: projectController,
              decoration: const InputDecoration(labelText: 'Project'),
            ),

            const SizedBox(height: 20),

            // ITEM INPUT
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addItem,
                )
              ],
            ),

            const SizedBox(height: 20),

            // ITEMS LIST
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['description']),
                    trailing: Text(item['amount'].toString()),
                  );
                },
              ),
            ),

            // TOTAL
            Text(
              "Total: $total",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: saveInvoice,
              child: const Text('Generate Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}