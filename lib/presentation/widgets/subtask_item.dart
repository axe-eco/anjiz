import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/subtask_model.dart';

/// عنصر المهمة الفرعية — مع Checkbox
class SubtaskItem extends StatelessWidget {
  final SubtaskModel subtask;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onDelete;

  const SubtaskItem({
    super.key,
    required this.subtask,
    this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: subtask.isCompleted
            ? AppColors.mintCore.withValues(alpha: 0.05)
            : AppColors.spaceHover,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // مربع التأشير
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: subtask.isCompleted,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // العنوان
          Expanded(
            child: Text(
              subtask.title,
              style: AppTextStyles.bodyMedium.copyWith(
                decoration: subtask.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: subtask.isCompleted
                    ? AppColors.uvMist.withValues(alpha: 0.6)
                    : AppColors.uvPearl,
              ),
            ),
          ),
          // الوقت المقدّر
          if (subtask.estimatedMinutes > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.spaceLift,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${subtask.estimatedMinutes}د',
                style: AppTextStyles.caption.copyWith(fontSize: 10),
              ),
            ),
          // زر الحذف
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.uvMist,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
