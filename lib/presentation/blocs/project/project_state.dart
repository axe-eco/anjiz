import 'package:equatable/equatable.dart';
import '../../../data/models/project_model.dart';

/// حالات BLoC المشاريع
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

/// جارٍ تحميل المشاريع
class ProjectLoading extends ProjectState {}

/// تم تحميل المشاريع
class ProjectLoaded extends ProjectState {
  final List<ProjectModel> projects;

  const ProjectLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

/// خطأ في تحميل المشاريع
class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}
