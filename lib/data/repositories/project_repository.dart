import 'package:uuid/uuid.dart';
import '../../core/services/hive_service.dart';
import '../../core/utils/progress_calculator.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/subtask_model.dart';

/// مستودع المشاريع — الطبقة الوسطى بين BLoC و Hive
class ProjectRepository {
  final _uuid = const Uuid();

  // ══ المشاريع ══

  /// جلب كل المشاريع
  List<ProjectModel> getAllProjects() {
    return HiveService.getAllProjects();
  }

  /// جلب مشروع بالمعرّف
  ProjectModel? getProject(String id) {
    return HiveService.getProject(id);
  }

  /// إنشاء مشروع جديد
  Future<ProjectModel> createProject({
    required String title,
    required String description,
    DateTime? deadline,
    int colorIndex = 0,
  }) async {
    final project = ProjectModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      deadline: deadline,
      colorIndex: colorIndex,
    );
    await HiveService.saveProject(project);
    return project;
  }

  /// إنشاء مشروع مع مهام من AI
  Future<ProjectModel> createProjectWithAITasks({
    required String title,
    required String description,
    required List<Map<String, dynamic>> aiTasks,
    required List<String> suggestions,
    DateTime? deadline,
    int colorIndex = 0,
  }) async {
    final projectId = _uuid.v4();
    final taskIds = <String>[];

    // إنشاء المهام والمهام الفرعية
    for (int i = 0; i < aiTasks.length; i++) {
      final aiTask = aiTasks[i];
      final taskId = _uuid.v4();
      final subtaskIds = <String>[];

      // إنشاء المهام الفرعية
      final aiSubtasks = aiTask['subtasks'] as List<dynamic>? ?? [];
      for (int j = 0; j < aiSubtasks.length; j++) {
        final aiSubtask = aiSubtasks[j] as Map<String, dynamic>;
        final subtaskId = _uuid.v4();
        final subtask = SubtaskModel(
          id: subtaskId,
          taskId: taskId,
          title: aiSubtask['title'] as String? ?? '',
          estimatedMinutes: (aiSubtask['estimatedMinutes'] as num?)?.toInt() ?? 0,
          order: j,
        );
        await HiveService.saveSubtask(subtask);
        subtaskIds.add(subtaskId);
      }

      // تحويل الأولوية من نص إلى رقم
      final priorityStr = aiTask['priority'] as String? ?? 'low';
      final priority = _priorityFromString(priorityStr);

      final task = TaskModel(
        id: taskId,
        projectId: projectId,
        title: aiTask['title'] as String? ?? '',
        priority: priority,
        priorityReason: aiTask['priorityReason'] as String? ?? '',
        estimatedMinutes: (aiTask['estimatedMinutes'] as num?)?.toInt() ?? 0,
        aiGenerated: true,
        subtaskIds: subtaskIds,
        order: i,
      );
      await HiveService.saveTask(task);
      taskIds.add(taskId);
    }

    // إنشاء المشروع
    final project = ProjectModel(
      id: projectId,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      deadline: deadline,
      taskIds: taskIds,
      colorIndex: colorIndex,
    );
    await HiveService.saveProject(project);
    return project;
  }

  /// تحديث مشروع
  Future<void> updateProject(ProjectModel project) async {
    await HiveService.saveProject(project);
  }

  /// حذف مشروع
  Future<void> deleteProject(String id) async {
    await HiveService.deleteProject(id);
  }

  // ══ المهام ══

  /// جلب مهام مشروع
  List<TaskModel> getProjectTasks(String projectId) {
    return HiveService.getProjectTasks(projectId);
  }

  /// جلب مهمة بالمعرّف
  TaskModel? getTask(String id) {
    return HiveService.getTask(id);
  }

  /// إضافة مهمة يدوية
  Future<TaskModel> addTask({
    required String projectId,
    required String title,
    int priority = 3,
    int estimatedMinutes = 0,
  }) async {
    final project = getProject(projectId);
    if (project == null) throw Exception('المشروع غير موجود');

    final task = TaskModel(
      id: _uuid.v4(),
      projectId: projectId,
      title: title,
      priority: priority,
      estimatedMinutes: estimatedMinutes,
      order: project.taskIds.length,
    );
    await HiveService.saveTask(task);

    // تحديث قائمة المهام في المشروع
    project.taskIds.add(task.id);
    await _recalculateProjectProgress(projectId);

    return task;
  }

  /// تحديث مهمة
  Future<void> updateTask(TaskModel task) async {
    await HiveService.saveTask(task);
  }

  /// حذف مهمة
  Future<void> deleteTask(String taskId, String projectId) async {
    final project = getProject(projectId);
    if (project != null) {
      project.taskIds.remove(taskId);
      await HiveService.saveProject(project);
    }
    await HiveService.deleteTask(taskId);
    await _recalculateProjectProgress(projectId);
  }

  // ══ المهام الفرعية ══

  /// جلب المهام الفرعية
  List<SubtaskModel> getTaskSubtasks(String taskId) {
    return HiveService.getTaskSubtasks(taskId);
  }

  /// إضافة مهمة فرعية
  Future<SubtaskModel> addSubtask({
    required String taskId,
    required String title,
    int estimatedMinutes = 0,
  }) async {
    final task = getTask(taskId);
    if (task == null) throw Exception('المهمة غير موجودة');

    final subtask = SubtaskModel(
      id: _uuid.v4(),
      taskId: taskId,
      title: title,
      estimatedMinutes: estimatedMinutes,
      order: task.subtaskIds.length,
    );
    await HiveService.saveSubtask(subtask);

    task.subtaskIds.add(subtask.id);
    await HiveService.saveTask(task);

    // إعادة حساب التقدم
    await _recalculateTaskProgress(taskId);

    return subtask;
  }

  /// تبديل حالة المهمة الفرعية
  Future<void> toggleSubtask(String subtaskId) async {
    final subtask = HiveService.getSubtask(subtaskId);
    if (subtask == null) return;

    subtask.isCompleted = !subtask.isCompleted;
    subtask.completedAt = subtask.isCompleted ? DateTime.now() : null;
    await HiveService.saveSubtask(subtask);

    // إعادة حساب تقدم المهمة ثم المشروع
    await _recalculateTaskProgress(subtask.taskId);
  }

  /// حذف مهمة فرعية
  Future<void> deleteSubtask(String subtaskId, String taskId) async {
    final task = getTask(taskId);
    if (task != null) {
      task.subtaskIds.remove(subtaskId);
      await HiveService.saveTask(task);
    }
    await HiveService.deleteSubtask(subtaskId);
    await _recalculateTaskProgress(taskId);
  }

  // ══ حساب التقدم ══

  /// إعادة حساب تقدم المهمة
  Future<void> _recalculateTaskProgress(String taskId) async {
    final task = HiveService.getTask(taskId);
    if (task == null) return;

    final subtasks = HiveService.getTaskSubtasks(taskId);
    task.progress = ProgressCalculator.taskProgress(subtasks);

    // تحديث الحالة تلقائياً
    if (task.progress >= 1.0) {
      task.status = 'done';
    } else if (task.progress > 0) {
      task.status = 'doing';
    } else {
      task.status = 'todo';
    }

    await HiveService.saveTask(task);
    await _recalculateProjectProgress(task.projectId);
  }

  /// إعادة حساب تقدم المشروع
  Future<void> _recalculateProjectProgress(String projectId) async {
    final project = HiveService.getProject(projectId);
    if (project == null) return;

    final tasks = HiveService.getProjectTasks(projectId);
    project.progress = ProgressCalculator.projectProgress(tasks);
    project.isCompleted = project.progress >= 1.0;

    await HiveService.saveProject(project);
  }

  // ══ مساعدات ══

  /// تحويل نص الأولوية إلى رقم
  int _priorityFromString(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical': return 0;
      case 'high': return 1;
      case 'medium': return 2;
      case 'low': return 3;
      default: return 3;
    }
  }

  /// جلب كل المهام (لجميع المشاريع)
  List<TaskModel> getAllTasks() {
    return HiveService.tasks.values.toList();
  }

  /// جلب كل المهام الفرعية المكتملة
  List<SubtaskModel> getCompletedSubtasks() {
    return HiveService.subtasks.values
        .where((s) => s.isCompleted)
        .toList();
  }
}
