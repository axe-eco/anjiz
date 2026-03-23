import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/task_model.dart';
import 'priority_badge.dart';

/// بطاقة المهمة — تعرض الأولوية وشريط التقدم
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (task.progress * 100).round();

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed?.call(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: AppColors.magCore.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.magCore),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
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
                  // أيقونة الحالة
                  _statusIcon(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        decoration: task.status == 'done'
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PriorityBadge(priority: task.priority),
                ],
              ),
              const SizedBox(height: 10),
              // شريط التقدم
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: task.progress,
                        backgroundColor: AppColors.spaceLift,
                        valueColor: AlwaysStoppedAnimation(
                          _progressColor(task.progress),
                        ),
                        minHeight: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$percentage%',
                    style: AppTextStyles.caption.copyWith(
                      color: _progressColor(task.progress),
                    ),
                  ),
                ],
              ),
              if (task.aiGenerated) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: AppColors.mintCore),
                    const SizedBox(width: 4),
                    Text(
                      'مولّدة بـ AI',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.mintCore,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusIcon() {
    switch (task.status) {
      case 'done':
        return Container(
          width: 24, height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.mintCore,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      case 'doing':
        return Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.uvBright, width: 2),
          ),
          child: const Icon(Icons.play_arrow, size: 14, color: AppColors.uvBright),
        );
      default:
        return Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.spaceLift, width: 2),
          ),
        );
    }
  }

  Color _progressColor(double progress) {
    if (progress >= 1.0) return AppColors.mintCore;
    if (progress >= 0.5) return AppColors.uvBright;
    return AppColors.uvMist;
  }
}
