import 'package:hive_flutter/hive_flutter.dart';

part 'subtask_model.g.dart';

/// نموذج المهمة الفرعية — عنصر قابل للتأشير
@HiveType(typeId: 2)
class SubtaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String title;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  int estimatedMinutes;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  int order;

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
    this.estimatedMinutes = 0,
    this.completedAt,
    this.order = 0,
  });
}
