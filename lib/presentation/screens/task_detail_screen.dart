import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';
import '../blocs/project/project_bloc.dart';
import '../blocs/project/project_event.dart';
import '../widgets/subtask_item.dart';
import '../widgets/priority_badge.dart';

/// شاشة تفاصيل المهمة — مهام فرعية مع Checkbox
class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  final String projectId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.projectId,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks(widget.projectId));
  }

  void _addSubtask() {
    final controller = TextEditingController();
    final minutesController = TextEditingController(text: '15');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          16, 16, 16,
          MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('إضافة مهمة فرعية', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              style: AppTextStyles.bodyMedium,
              decoration: const InputDecoration(hintText: 'عنوان المهمة الفرعية...'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: AppStrings.minutesEst,
                suffixText: 'دقيقة',
                suffixStyle: AppTextStyles.caption,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<TaskBloc>().add(AddSubtask(
                    taskId: widget.taskId,
                    projectId: widget.projectId,
                    title: controller.text.trim(),
                    estimatedMinutes: int.tryParse(minutesController.text) ?? 0,
                  ));
                  context.read<ProjectBloc>().add(RefreshProjects());
                  Navigator.pop(ctx);
                }
              },
              child: Text(AppStrings.add, style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<ProjectBloc>().add(RefreshProjects());
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.uvCore),
            );
          }
          if (state is TaskLoaded) {
            final task = state.tasks.where((t) => t.id == widget.taskId).firstOrNull;
            if (task == null) {
              return const Center(child: Text('المهمة غير موجودة'));
            }
            final subtasks = state.subtasksMap[task.id] ?? [];
            final percentage = (task.progress * 100).round();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // نسبة التقدم الكبيرة
                Center(
                  child: Text(
                    '$percentage%',
                    style: AppTextStyles.number.copyWith(fontSize: 48),
                  ),
                ),
                Center(
                  child: Text(AppStrings.done, style: AppTextStyles.bodySmall),
                ),
                const SizedBox(height: 8),
                // شريط التقدم
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: task.progress,
                    backgroundColor: AppColors.spaceLift,
                    valueColor: const AlwaysStoppedAnimation(AppColors.uvBright),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 20),
                // اسم المهمة
                Text(task.title, style: AppTextStyles.heading2),
                const SizedBox(height: 8),
                // شارات
                Row(
                  children: [
                    PriorityBadge(priority: task.priority),
                    const SizedBox(width: 8),
                    if (task.aiGenerated)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.mintCore.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome, size: 12, color: AppColors.mintCore),
                            const SizedBox(width: 4),
                            Text(
                              AppStrings.aiGenerated,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.mintCore,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (task.estimatedMinutes > 0) ...[
                      const Spacer(),
                      Icon(Icons.schedule, size: 14, color: AppColors.uvMist),
                      const SizedBox(width: 4),
                      Text(
                        '${task.estimatedMinutes} دقيقة',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ],
                ),
                if (task.priorityReason.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.spaceHover,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: AppColors.uvMist),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.priorityReason,
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                // المهام الفرعية
                Row(
                  children: [
                    Text(
                      'المهام الفرعية (${subtasks.length})',
                      style: AppTextStyles.heading3,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...subtasks.map(
                  (subtask) => SubtaskItem(
                    subtask: subtask,
                    onChanged: (_) {
                      context.read<TaskBloc>().add(ToggleSubtask(
                        subtaskId: subtask.id,
                        projectId: widget.projectId,
                      ));
                    },
                    onDelete: () {
                      context.read<TaskBloc>().add(DeleteSubtask(
                        subtaskId: subtask.id,
                        taskId: widget.taskId,
                        projectId: widget.projectId,
                      ));
                    },
                  ),
                ),
                const SizedBox(height: 80),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _addSubtask,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
