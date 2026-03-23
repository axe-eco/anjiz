import '../../data/models/subtask_model.dart';
import '../../data/models/task_model.dart';

/// حساب التقدم — يُحسب تلقائياً عند تغيير المهام الفرعية
class ProgressCalculator {
  ProgressCalculator._();

  /// حساب نسبة تقدم المهمة من المهام الفرعية
  static double taskProgress(List<SubtaskModel> subtasks) {
    if (subtasks.isEmpty) return 0.0;
    final done = subtasks.where((s) => s.isCompleted).length;
    return done / subtasks.length;
  }

  /// حساب نسبة تقدم المشروع من المهام
  static double projectProgress(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0.0;
    final total = tasks.map((t) => t.progress).reduce((a, b) => a + b);
    return total / tasks.length;
  }
}
