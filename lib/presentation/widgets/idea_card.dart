import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// بطاقة الفكرة — عنوان + وصف + تقييم
class IdeaCard extends StatelessWidget {
  final String title;
  final String? description;
  final int rating; // 1-5
  final String? category;
  final VoidCallback? onAddToProject;
  final VoidCallback? onSave;
  final VoidCallback? onDismiss;

  const IdeaCard({
    super.key,
    required this.title,
    this.description,
    this.rating = 3,
    this.category,
    this.onAddToProject,
    this.onSave,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.spaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.amberCore.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // التصنيف والتقييم
          Row(
            children: [
              if (category != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.spaceLift,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category!,
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
                ),
              const Spacer(),
              // نجوم التقييم
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: i < rating ? AppColors.amberCore : AppColors.spaceLift,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // العنوان
          Text(title, style: AppTextStyles.bodyLarge),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: AppTextStyles.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          // الأزرار
          Row(
            children: [
              _ActionButton(
                icon: Icons.add_circle_outline,
                label: 'أضف للمشروع',
                color: AppColors.mintCore,
                onTap: onAddToProject,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.bookmark_outline,
                label: 'احفظ',
                color: AppColors.uvBright,
                onTap: onSave,
              ),
              const Spacer(),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.uvMist,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
