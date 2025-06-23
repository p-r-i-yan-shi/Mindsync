import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal_entry.dart';

class JournalService {
  final _db = FirebaseFirestore.instance;
  final String collection = 'journal_entries';

  Future<void> addEntry(JournalEntry entry) async {
    await _db.collection(collection).doc(entry.id).set(entry.toMap());
  }

  Stream<List<JournalEntry>> getEntries(String userId) {
    return _db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromMap(doc.data()))
            .toList());
  }

  Future<void> deleteEntry(String id) async {
    await _db.collection(collection).doc(id).delete();
  }
} 