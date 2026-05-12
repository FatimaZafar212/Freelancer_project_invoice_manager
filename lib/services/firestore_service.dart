import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  // ✅ ADD INVOICE
  Future<void> addInvoice({
    required String clientId,
    required String projectId,
    required double total,
    required List<Map<String, dynamic>> items,
  }) async {
    await _db.collection('invoices').add({
      'userId': uid, // 🔥 IMPORTANT
      'clientId': clientId,
      'projectId': projectId,
      'total': total,
      'items': items,
      'status': 'Pending',
      'createdAt': DateTime.now(),
    });
  }

  // ✅ GET INVOICES (NO FILTER FOR NOW → BUG FIX)
  Stream<QuerySnapshot> getInvoices() {
    return _db
        .collection('invoices')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}