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
import '../widgets/progress_ring.dart';
import '../widgets/task_card.dart';

/// شاشة تفاصيل المشروع — تقدم + قائمة المهام
class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks(widget.projectId));
  }

  void _addTask() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          16, 16, 16,
          MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('إضافة مهمة', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              style: AppTextStyles.bodyMedium,
              decoration: const InputDecoration(hintText: 'عنوان المهمة...'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<TaskBloc>().add(AddTask(
                    projectId: widget.projectId,
                    title: controller.text.trim(),
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
        actions: [
          IconButton(
            onPressed: () => context.push('/priorities/${widget.projectId}'),
            icon: const Icon(Icons.sort_rounded, color: AppColors.mintCore),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.uvCore),
            );
          }
          if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          if (state is TaskLoaded) {
            return _buildContent(state);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildContent(TaskLoaded state) {
    final project = state.project;
    if (project == null) return const Center(child: Text('المشروع غير موجود'));

    final tasks = state.tasks;
    final doneTasks = tasks.where((t) => t.status == 'done').length;
    final doingTasks = tasks.where((t) => t.status == 'doing').length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // دائرة التقدم
        Center(
          child: ProgressRing(
            progress: project.progress,
            size: 140,
            strokeWidth: 10,
          ),
        ),
        const SizedBox(height: 16),
        // اسم المشروع
        Text(
          project.title,
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // إحصائيات سريعة
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MiniStat(label: AppStrings.done, value: '$doneTasks', color: AppColors.mintCore),
            const SizedBox(width: 24),
            _MiniStat(label: AppStrings.doing, value: '$doingTasks', color: AppColors.uvBright),
            const SizedBox(width: 24),
            _MiniStat(label: AppStrings.todo, value: '${tasks.length - doneTasks - doingTasks}', color: AppColors.uvMist),
          ],
        ),
        const SizedBox(height: 24),
        // قائمة المهام
        Row(
          children: [
            Text('المهام (${tasks.length})', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 10),
        ...tasks.map(
          (task) => TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}', extra: widget.projectId),
            onDismissed: () {
              context.read<TaskBloc>().add(DeleteTask(
                taskId: task.id,
                projectId: widget.projectId,
              ));
              context.read<ProjectBloc>().add(RefreshProjects());
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
