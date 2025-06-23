import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_log.dart';

class MoodService {
  final _db = FirebaseFirestore.instance;
  final String collection = 'mood_logs';

  Future<void> addMood(MoodLog log) async {
    await _db.collection(collection).doc(log.id).set(log.toMap());
  }

  Stream<List<MoodLog>> getMoods(String userId) {
    return _db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodLog.fromMap(doc.data()))
            .toList());
  }

  Future<void> deleteMood(String id) async {
    await _db.collection(collection).doc(id).delete();
  }
} 