import '../../data/models/task_model.dart';

/// ترتيب المهام حسب الأولوية
class PrioritySorter {
  PrioritySorter._();

  /// ترتيب المهام: حرج ← عالي ← متوسط ← منخفض
  static List<TaskModel> sort(List<TaskModel> tasks) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) => a.priority.compareTo(b.priority));
    return sorted;
  }

  /// تجميع المهام حسب الأولوية
  static Map<int, List<TaskModel>> groupByPriority(List<TaskModel> tasks) {
    final map = <int, List<TaskModel>>{};
    for (final task in tasks) {
      map.putIfAbsent(task.priority, () => []).add(task);
    }
    return map;
  }

  /// اسم الأولوية بالعربي
  static String priorityLabel(int priority) {
    switch (priority) {
      case 0: return 'حرج';
      case 1: return 'عالي';
      case 2: return 'متوسط';
      case 3: return 'منخفض';
      default: return 'غير محدد';
    }
  }
}
