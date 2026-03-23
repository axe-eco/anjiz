import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/project_model.dart';

/// بطاقة المشروع — تعرض النسبة وشريط التقدم
class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.projectColors[
        project.colorIndex % AppColors.projectColors.length];
    final percentage = (project.progress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.spaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            right: BorderSide(color: color, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي: اسم + نسبة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: AppTextStyles.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$percentage%',
                      style: AppTextStyles.label.copyWith(color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // الوصف
              Text(
                project.description,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // شريط التقدم
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.progress,
                  backgroundColor: AppColors.spaceLift,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 8),
              // معلومات إضافية
              Row(
                children: [
                  Icon(Icons.list_alt_rounded, size: 14, color: AppColors.uvMist),
                  const SizedBox(width: 4),
                  Text(
                    '${project.taskIds.length} مهام',
                    style: AppTextStyles.caption,
                  ),
                  const Spacer(),
                  if (project.deadline != null) ...[
                    Icon(Icons.schedule_rounded, size: 14, color: AppColors.uvMist),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(project.deadline!),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
