import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  String? selectedClientId;
  String? selectedProjectId;
  List<InvoiceItem> items = [];
  final descController = TextEditingController();
  final amountController = TextEditingController();

  double get total => items.fold(0, (sum, i) => sum + i.amount);

  void addItem() {
    if (descController.text.isNotEmpty && amountController.text.isNotEmpty) {
      setState(() {
        items.add(InvoiceItem(
          description: descController.text,
          amount: double.tryParse(amountController.text) ?? 0,
        ));
        descController.clear();
        amountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Client',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              initialValue: selectedClientId,
              items: dummyClients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => selectedClientId = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Project',
                prefixIcon: const Icon(Icons.work),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              initialValue: selectedProjectId,
              items: dummyProjects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.title))).toList(),
              onChanged: (val) => setState(() => selectedProjectId = val),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: descController,
                    decoration: InputDecoration(labelText: 'Item Description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount', prefixText: AppConstants.currencySymbol, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 32),
                  onPressed: addItem,
                )
              ],
            ),
            const SizedBox(height: 16),
            if (items.isNotEmpty) ...[
              const Text('Invoice Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ...items.map((e) => ListTile(
                title: Text(e.description),
                trailing: Text('${AppConstants.currencySymbol}${e.amount.toStringAsFixed(2)}'),
              )),
              const Divider(),
              ListTile(
                title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('${AppConstants.currencySymbol}${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Generate Invoice'),
            )
          ],
        ),
      ),
    );
  }
}