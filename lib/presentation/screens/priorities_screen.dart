import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/priority_sorter.dart';
import '../../data/repositories/project_repository.dart';
import '../../data/models/task_model.dart';
import '../widgets/priority_badge.dart';

/// شاشة الأولويات — ترتيب ذكي حسب AI
class PrioritiesScreen extends StatefulWidget {
  final String projectId;

  const PrioritiesScreen({super.key, required this.projectId});

  @override
  State<PrioritiesScreen> createState() => _PrioritiesScreenState();
}

class _PrioritiesScreenState extends State<PrioritiesScreen> {
  final _repository = ProjectRepository();
  late List<TaskModel> _tasks;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = PrioritySorter.sort(_repository.getProjectTasks(widget.projectId));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final grouped = PrioritySorter.groupByPriority(_tasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأولويات'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // شارة AI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.mintCore.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: AppColors.mintCore),
                const SizedBox(width: 6),
                Text(AppStrings.sortedByAI, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mintCore)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // مجموعات الأولوية
          for (final priority in [0, 1, 2, 3])
            if (grouped.containsKey(priority)) ...[
              _PrioritySection(
                priority: priority,
                tasks: grouped[priority]!,
                onTaskTap: (task) => context.push('/task/${task.id}', extra: widget.projectId),
              ),
              const SizedBox(height: 16),
            ],
        ],
      ),
    );
  }
}

class _PrioritySection extends StatelessWidget {
  final int priority;
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onTaskTap;

  const _PrioritySection({
    required this.priority,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PriorityBadge(priority: priority),
            const SizedBox(width: 8),
            Text(
              '(${tasks.length})',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...tasks.map((task) {
          return GestureDetector(
            onTap: () => onTaskTap(task),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.spaceCard,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: AppTextStyles.bodyLarge),
                  if (task.priorityReason.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(task.priorityReason, style: AppTextStyles.caption),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
