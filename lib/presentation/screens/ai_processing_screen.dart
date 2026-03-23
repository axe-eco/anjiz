import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../blocs/ai/ai_bloc.dart';
import '../blocs/ai/ai_event.dart';
import '../blocs/ai/ai_state.dart';
import '../blocs/project/project_bloc.dart';
import '../blocs/project/project_event.dart';
import '../widgets/ai_thinking_widget.dart';

/// شاشة معالجة AI — تفكير + عرض المهام المكتشفة
class AIProcessingScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;

  const AIProcessingScreen({super.key, required this.projectData});

  @override
  State<AIProcessingScreen> createState() => _AIProcessingScreenState();
}

class _AIProcessingScreenState extends State<AIProcessingScreen> {
  @override
  void initState() {
    super.initState();
    final description = widget.projectData['description'] as String;
    context.read<AIBloc>().add(GenerateTasks(description));
  }

  void _acceptPlan(AIGenerated state) {
    final name = widget.projectData['name'] as String?;
    final description = widget.projectData['description'] as String;
    final deadlineStr = widget.projectData['deadline'] as String?;
    final colorIndex = widget.projectData['colorIndex'] as int? ?? 0;

    context.read<ProjectBloc>().add(AddProjectWithAITasks(
      title: name?.isNotEmpty == true ? name! : _extractTitle(description),
      description: description,
      tasks: state.tasks,
      suggestions: state.suggestions,
      deadline: deadlineStr != null ? DateTime.tryParse(deadlineStr) : null,
      colorIndex: colorIndex,
    ));

    context.read<AIBloc>().add(ResetAI());
    context.go('/home');
  }

  String _extractTitle(String desc) {
    // استخراج أول ١٥ كلمة كعنوان
    final words = desc.split(' ');
    if (words.length <= 5) return desc;
    return '${words.take(5).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل المشروع'),
        leading: IconButton(
          onPressed: () {
            context.read<AIBloc>().add(ResetAI());
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: BlocBuilder<AIBloc, AIState>(
        builder: (context, state) {
          if (state is AIThinking) {
            return Center(
              child: AIThinkingWidget(thought: state.thought),
            );
          }
          if (state is AILoading) {
            return const Center(
              child: AIThinkingWidget(thought: 'جارٍ الاتصال بالذكاء الاصطناعي...'),
            );
          }
          if (state is AIGenerated) {
            return _buildResults(state);
          }
          if (state is AIError) {
            return _buildError(state);
          }
          return const Center(
            child: AIThinkingWidget(thought: 'جارٍ التحليل...'),
          );
        },
      ),
    );
  }

  Widget _buildResults(AIGenerated state) {
    return Column(
      children: [
        // عنوان النتائج
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.mintCore, size: 20),
              const SizedBox(width: 8),
              Text(
                'تم اكتشاف ${state.tasks.length} مهام',
                style: AppTextStyles.heading3.copyWith(color: AppColors.mintNeon),
              ),
            ],
          ),
        ),
        // قائمة المهام
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              final subtasks = task['subtasks'] as List<dynamic>? ?? [];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.spaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.spaceLift.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.uvCore.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.uvBright,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            task['title'] as String? ?? '',
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                        _priorityChip(task['priority'] as String? ?? 'low'),
                      ],
                    ),
                    if (task['priorityReason'] != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        task['priorityReason'] as String,
                        style: AppTextStyles.caption,
                      ),
                    ],
                    const SizedBox(height: 8),
                    // المهام الفرعية
                    ...subtasks.map((s) {
                      final sub = s as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(right: 38, bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.subdirectory_arrow_left_rounded,
                                size: 14, color: AppColors.spaceLift),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                sub['title'] as String? ?? '',
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                            Text(
                              '${sub['estimatedMinutes'] ?? 0}د',
                              style: AppTextStyles.caption.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        // أزرار القبول/إعادة التوليد
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final desc = widget.projectData['description'] as String;
                    context.read<AIBloc>().add(RegeneratePlan(desc));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.uvMist),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(AppStrings.regenerate, style: AppTextStyles.bodyMedium),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGrad,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _acceptPlan(state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(0, 48),
                    ),
                    child: Text(AppStrings.acceptPlan, style: AppTextStyles.button),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priorityChip(String priority) {
    Color color;
    String label;
    switch (priority) {
      case 'critical':
        color = AppColors.magCore;
        label = AppStrings.critical;
        break;
      case 'high':
        color = AppColors.magLight;
        label = AppStrings.high;
        break;
      case 'medium':
        color = AppColors.amberLit;
        label = AppStrings.medium;
        break;
      default:
        color = AppColors.mintCore;
        label = AppStrings.low;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontSize: 10),
      ),
    );
  }

  Widget _buildError(AIError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: AppColors.magCore),
            const SizedBox(height: 16),
            Text('حدث خطأ', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final desc = widget.projectData['description'] as String;
                context.read<AIBloc>().add(GenerateTasks(desc));
              },
              child: const Text('حاول مرة أخرى'),
            ),
          ],
        ),
      ),
    );
  }
}
