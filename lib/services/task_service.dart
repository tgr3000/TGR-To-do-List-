import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class TaskService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String get _uid => _auth.currentUser!.uid;

  static CollectionReference get _taskCollection =>
      _firestore.collection('users').doc(_uid).collection('tasks');

  static Future<void> addTask(Task task) {
    return _taskCollection.add(task.toMap());
  }

  static Stream<List<Task>> getTasksStreamByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return _taskCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  static Future<void> updateTask(Task task) {
    return _taskCollection.doc(task.id).update(task.toMap());
  }

  static Future<void> deleteTask(String id) {
    return _taskCollection.doc(id).delete();
  }
}
