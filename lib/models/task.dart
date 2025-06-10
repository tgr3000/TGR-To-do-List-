import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date':
          date, // 🔁 simpan langsung sebagai Timestamp (Firestore akan otomatis handle)
      'isDone': isDone,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(), // 🔁 baca sebagai Timestamp
      isDone: map['isDone'] ?? false,
    );
  }
}
