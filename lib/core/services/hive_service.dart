import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/project_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/subtask_model.dart';

/// خدمة Hive — إدارة قاعدة البيانات المحلية
class HiveService {
  static const projectsBox = 'projects';
  static const tasksBox = 'tasks';
  static const subtasksBox = 'subtasks';

  /// تهيئة Hive وتسجيل المحولات
  static Future<void> init() async {
    await Hive.initFlutter();

    // تسجيل المحولات
    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(SubtaskModelAdapter());

    // فتح الصناديق
    await Hive.openBox<ProjectModel>(projectsBox);
    await Hive.openBox<TaskModel>(tasksBox);
    await Hive.openBox<SubtaskModel>(subtasksBox);
  }

  // ── المشاريع ──

  static Box<ProjectModel> get projects => Hive.box<ProjectModel>(projectsBox);
  static Box<TaskModel> get tasks => Hive.box<TaskModel>(tasksBox);
  static Box<SubtaskModel> get subtasks => Hive.box<SubtaskModel>(subtasksBox);

  /// جلب كل المشاريع
  static List<ProjectModel> getAllProjects() {
    return projects.values.toList();
  }

  /// جلب مشروع بالمعرّف
  static ProjectModel? getProject(String id) {
    return projects.get(id);
  }

  /// حفظ مشروع
  static Future<void> saveProject(ProjectModel project) async {
    await projects.put(project.id, project);
  }

  /// حذف مشروع وكل مهامه
  static Future<void> deleteProject(String id) async {
    final project = getProject(id);
    if (project != null) {
      // حذف المهام الفرعية ثم المهام
      for (final taskId in project.taskIds) {
        await deleteTask(taskId);
      }
      await projects.delete(id);
    }
  }

  // ── المهام ──

  /// جلب مهام المشروع
  static List<TaskModel> getProjectTasks(String projectId) {
    return tasks.values
        .where((t) => t.projectId == projectId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// جلب مهمة بالمعرّف
  static TaskModel? getTask(String id) {
    return tasks.get(id);
  }

  /// حفظ مهمة
  static Future<void> saveTask(TaskModel task) async {
    await tasks.put(task.id, task);
  }

  /// حذف مهمة وكل مهامها الفرعية
  static Future<void> deleteTask(String id) async {
    final task = getTask(id);
    if (task != null) {
      for (final subtaskId in task.subtaskIds) {
        await subtasks.delete(subtaskId);
      }
      await tasks.delete(id);
    }
  }

  // ── المهام الفرعية ──

  /// جلب المهام الفرعية لمهمة
  static List<SubtaskModel> getTaskSubtasks(String taskId) {
    return subtasks.values
        .where((s) => s.taskId == taskId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// جلب مهمة فرعية بالمعرّف
  static SubtaskModel? getSubtask(String id) {
    return subtasks.get(id);
  }

  /// حفظ مهمة فرعية
  static Future<void> saveSubtask(SubtaskModel subtask) async {
    await subtasks.put(subtask.id, subtask);
  }

  /// حذف مهمة فرعية
  static Future<void> deleteSubtask(String id) async {
    await subtasks.delete(id);
  }
}
