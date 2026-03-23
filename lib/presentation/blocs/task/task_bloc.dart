import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/models/subtask_model.dart';
import 'task_event.dart';
import 'task_state.dart';

/// BLoC المهام — إدارة المهام والمهام الفرعية مع حساب التقدم
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ProjectRepository _repository;

  TaskBloc({ProjectRepository? repository})
      : _repository = repository ?? ProjectRepository(),
        super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleSubtask>(_onToggleSubtask);
    on<AddSubtask>(_onAddSubtask);
    on<DeleteSubtask>(_onDeleteSubtask);
  }

  String? _currentProjectId;

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    _currentProjectId = event.projectId;
    emit(TaskLoading());
    try {
      final tasks = _repository.getProjectTasks(event.projectId);
      final subtasksMap = <String, List<SubtaskModel>>{};
      for (final task in tasks) {
        subtasksMap[task.id] = _repository.getTaskSubtasks(task.id);
      }
      final project = _repository.getProject(event.projectId);
      emit(TaskLoaded(tasks: tasks, subtasksMap: subtasksMap, project: project));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.addTask(
        projectId: event.projectId,
        title: event.title,
        priority: event.priority,
        estimatedMinutes: event.estimatedMinutes,
      );
      add(LoadTasks(event.projectId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = _repository.getTask(event.taskId);
      if (task != null) {
        if (event.title != null) task.title = event.title!;
        if (event.priority != null) task.priority = event.priority!;
        if (event.status != null) task.status = event.status!;
        await _repository.updateTask(task);
        if (_currentProjectId != null) {
          add(LoadTasks(_currentProjectId!));
        }
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.deleteTask(event.taskId, event.projectId);
      add(LoadTasks(event.projectId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleSubtask(
    ToggleSubtask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.toggleSubtask(event.subtaskId);
      if (_currentProjectId != null) {
        add(LoadTasks(_currentProjectId!));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddSubtask(
    AddSubtask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.addSubtask(
        taskId: event.taskId,
        title: event.title,
        estimatedMinutes: event.estimatedMinutes,
      );
      add(LoadTasks(event.projectId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteSubtask(
    DeleteSubtask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.deleteSubtask(event.subtaskId, event.taskId);
      add(LoadTasks(event.projectId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
