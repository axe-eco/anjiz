import 'package:hive_flutter/hive_flutter.dart';

part 'project_model.g.dart';

/// نموذج المشروع — يحتوي على قائمة مهام ونسبة إنجاز
@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  double progress; // 0.0 - 1.0 يُحسب تلقائياً

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? deadline;

  @HiveField(6)
  List<String> taskIds;

  @HiveField(7)
  int colorIndex; // 0-4 لألوان مختلفة

  @HiveField(8)
  bool isCompleted;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.progress = 0.0,
    required this.createdAt,
    this.deadline,
    List<String>? taskIds,
    this.colorIndex = 0,
    this.isCompleted = false,
  }) : taskIds = taskIds ?? [];
}
