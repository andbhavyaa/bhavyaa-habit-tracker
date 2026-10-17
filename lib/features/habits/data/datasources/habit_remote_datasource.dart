import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit.dart';

class HabitRemoteDataSource {
  final FirebaseFirestore db;
  HabitRemoteDataSource(this.db);
  CollectionReference<Map<String, dynamic>> get _c => db.collection('habits');

  Stream<List<Habit>> watch() => _c.orderBy('createdAt').snapshots().map((s) => s.docs.map((d) {
        final m = d.data();
        return Habit(id: d.id, name: m['name'] ?? '', description: m['description'] ?? '', points: (m['points'] ?? 0) as int,
            completedDates: List<String>.from(m['completedDates'] ?? const []));
      }).toList());

  Future<void> add(String n, String d, int p) =>
      _c.add({'name': n, 'description': d, 'points': p, 'completedDates': [], 'createdAt': FieldValue.serverTimestamp()});

  Future<void> setDone(String id, String key, bool done) =>
      _c.doc(id).update({'completedDates': done ? FieldValue.arrayUnion([key]) : FieldValue.arrayRemove([key])});
}
