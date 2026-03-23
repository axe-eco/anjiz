import 'package:equatable/equatable.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/subtask_model.dart';
import '../../../data/models/project_model.dart';

/// حالات BLoC المهام
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// جارٍ تحميل المهام
class TaskLoading extends TaskState {}

/// تم تحميل المهام
class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final Map<String, List<SubtaskModel>> subtasksMap;
  final ProjectModel? project;

  const TaskLoaded({
    required this.tasks,
    this.subtasksMap = const {},
    this.project,
  });

  @override
  List<Object?> get props => [tasks, subtasksMap, project];
}

/// خطأ في تحميل المهام
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
