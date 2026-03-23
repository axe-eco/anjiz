import 'package:equatable/equatable.dart';

/// أحداث BLoC المهام
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل مهام مشروع
class LoadTasks extends TaskEvent {
  final String projectId;

  const LoadTasks(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// إضافة مهمة يدوية
class AddTask extends TaskEvent {
  final String projectId;
  final String title;
  final int priority;
  final int estimatedMinutes;

  const AddTask({
    required this.projectId,
    required this.title,
    this.priority = 3,
    this.estimatedMinutes = 0,
  });

  @override
  List<Object?> get props => [projectId, title, priority];
}

/// تحديث مهمة
class UpdateTask extends TaskEvent {
  final String taskId;
  final String? title;
  final int? priority;
  final String? status;

  const UpdateTask({
    required this.taskId,
    this.title,
    this.priority,
    this.status,
  });

  @override
  List<Object?> get props => [taskId, title, priority, status];
}

/// حذف مهمة
class DeleteTask extends TaskEvent {
  final String taskId;
  final String projectId;

  const DeleteTask({required this.taskId, required this.projectId});

  @override
  List<Object?> get props => [taskId, projectId];
}

/// تبديل حالة مهمة فرعية
class ToggleSubtask extends TaskEvent {
  final String subtaskId;
  final String projectId;

  const ToggleSubtask({required this.subtaskId, required this.projectId});

  @override
  List<Object?> get props => [subtaskId, projectId];
}

/// إضافة مهمة فرعية
class AddSubtask extends TaskEvent {
  final String taskId;
  final String projectId;
  final String title;
  final int estimatedMinutes;

  const AddSubtask({
    required this.taskId,
    required this.projectId,
    required this.title,
    this.estimatedMinutes = 0,
  });

  @override
  List<Object?> get props => [taskId, projectId, title];
}

/// حذف مهمة فرعية
class DeleteSubtask extends TaskEvent {
  final String subtaskId;
  final String taskId;
  final String projectId;

  const DeleteSubtask({
    required this.subtaskId,
    required this.taskId,
    required this.projectId,
  });

  @override
  List<Object?> get props => [subtaskId, taskId, projectId];
}
