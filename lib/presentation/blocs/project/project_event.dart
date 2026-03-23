import 'package:equatable/equatable.dart';

/// أحداث BLoC المشاريع
abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل كل المشاريع
class LoadProjects extends ProjectEvent {}

/// إضافة مشروع جديد
class AddProject extends ProjectEvent {
  final String title;
  final String description;
  final DateTime? deadline;
  final int colorIndex;

  const AddProject({
    required this.title,
    required this.description,
    this.deadline,
    this.colorIndex = 0,
  });

  @override
  List<Object?> get props => [title, description, deadline, colorIndex];
}

/// إضافة مشروع بمهام AI
class AddProjectWithAITasks extends ProjectEvent {
  final String title;
  final String description;
  final List<Map<String, dynamic>> tasks;
  final List<String> suggestions;
  final DateTime? deadline;
  final int colorIndex;

  const AddProjectWithAITasks({
    required this.title,
    required this.description,
    required this.tasks,
    required this.suggestions,
    this.deadline,
    this.colorIndex = 0,
  });

  @override
  List<Object?> get props => [title, description, tasks, suggestions];
}

/// تحديث مشروع
class UpdateProject extends ProjectEvent {
  final String projectId;
  final String? title;
  final String? description;

  const UpdateProject({
    required this.projectId,
    this.title,
    this.description,
  });

  @override
  List<Object?> get props => [projectId, title, description];
}

/// حذف مشروع
class DeleteProject extends ProjectEvent {
  final String projectId;

  const DeleteProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// تحديث تقدم المشاريع (بعد تغيير مهمة)
class RefreshProjects extends ProjectEvent {}
