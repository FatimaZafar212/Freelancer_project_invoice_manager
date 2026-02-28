import 'package:flutter/material.dart';

class ClientDetailScreen extends StatelessWidget {
  const ClientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Client Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Client Name: John Doe", style: TextStyle(fontSize: 18)),
            Text("Email: john@example.com"),
            Text("Phone: +123456789"),
            SizedBox(height: 20),
            Text("Projects", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(title: Text("Project 1")),
            ListTile(title: Text("Project 2")),
          ],
        ),
      ),
    );
  }
}