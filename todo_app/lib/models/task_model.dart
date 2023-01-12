import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String ad;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isCompleted;

  Task(
      {required this.id,
      required this.ad,
      required this.createdAt,
      required this.isCompleted});

  factory Task.create({required String ad, required DateTime createdAt}) {
    return Task(
        id: const Uuid().v1(),
        ad: ad,
        createdAt: createdAt,
        isCompleted: false);
  }

  @override
  String toString() {
    return '$ad - $createdAt - $isCompleted';
  }
}
