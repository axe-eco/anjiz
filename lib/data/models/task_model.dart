import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.g.dart';

/// نموذج المهمة — تحتوي على مهام فرعية ونسبة إنجاز
@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String projectId;

  @HiveField(2)
  String title;

  @HiveField(3)
  double progress; // يُحسب من المهام الفرعية

  @HiveField(4)
  int priority; // 0=critical 1=high 2=medium 3=low

  @HiveField(5)
  String priorityReason; // سبب الأولوية من AI

  @HiveField(6)
  String status; // todo / doing / done

  @HiveField(7)
  int estimatedMinutes;

  @HiveField(8)
  bool aiGenerated;

  @HiveField(9)
  List<String> subtaskIds;

  @HiveField(10)
  int order;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.progress = 0.0,
    this.priority = 3,
    this.priorityReason = '',
    this.status = 'todo',
    this.estimatedMinutes = 0,
    this.aiGenerated = false,
    List<String>? subtaskIds,
    this.order = 0,
  }) : subtaskIds = subtaskIds ?? [];
}
