import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// شارة الأولوية — حرج / عالي / متوسط / منخفض
class PriorityBadge extends StatelessWidget {
  final int priority; // 0=critical 1=high 2=medium 3=low

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption.copyWith(
          color: _color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }

  Color get _color {
    switch (priority) {
      case 0: return AppColors.magCore;    // حرج
      case 1: return AppColors.magLight;   // عالي
      case 2: return AppColors.amberLit;   // متوسط
      case 3: return AppColors.mintCore;   // منخفض
      default: return AppColors.uvMist;
    }
  }

  String get _label {
    switch (priority) {
      case 0: return 'حرج';
      case 1: return 'عالي';
      case 2: return 'متوسط';
      case 3: return 'منخفض';
      default: return '—';
    }
  }
}
