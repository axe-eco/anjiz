import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/project_repository.dart';
import 'project_event.dart';
import 'project_state.dart';

/// BLoC المشاريع — إدارة حالة المشاريع
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _repository;

  ProjectBloc({ProjectRepository? repository})
      : _repository = repository ?? ProjectRepository(),
        super(ProjectLoading()) {
    on<LoadProjects>(_onLoadProjects);
    on<AddProject>(_onAddProject);
    on<AddProjectWithAITasks>(_onAddProjectWithAITasks);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<RefreshProjects>(_onRefreshProjects);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final projects = _repository.getAllProjects();
      // ترتيب حسب التاريخ (الأحدث أولاً)
      projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onAddProject(
    AddProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _repository.createProject(
        title: event.title,
        description: event.description,
        deadline: event.deadline,
        colorIndex: event.colorIndex,
      );
      add(LoadProjects());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onAddProjectWithAITasks(
    AddProjectWithAITasks event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _repository.createProjectWithAITasks(
        title: event.title,
        description: event.description,
        aiTasks: event.tasks,
        suggestions: event.suggestions,
        deadline: event.deadline,
        colorIndex: event.colorIndex,
      );
      add(LoadProjects());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onUpdateProject(
    UpdateProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      final project = _repository.getProject(event.projectId);
      if (project != null) {
        if (event.title != null) project.title = event.title!;
        if (event.description != null) project.description = event.description!;
        await _repository.updateProject(project);
        add(LoadProjects());
      }
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _repository.deleteProject(event.projectId);
      add(LoadProjects());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onRefreshProjects(
    RefreshProjects event,
    Emitter<ProjectState> emit,
  ) async {
    add(LoadProjects());
  }
}
