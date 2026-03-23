import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// شعار أنجز — أيقونة متدرجة مع نص
class AnjizLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showEn;

  const AnjizLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.showEn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الأيقونة
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.22),
            gradient: const LinearGradient(
              colors: [AppColors.uvDeep, AppColors.uvCore, AppColors.mintDeep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.uvCore.withValues(alpha: 0.4),
                blurRadius: size * 0.4,
                spreadRadius: size * 0.05,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          // النص العربي بتدرج
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.uvPearl, AppColors.mintNeon],
            ).createShader(bounds),
            child: Text(
              'أنجز',
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: size * 0.45,
              ),
            ),
          ),
          if (showEn)
            Text(
              'ANJIZ',
              style: AppTextStyles.caption.copyWith(
                letterSpacing: 4,
                fontSize: size * 0.18,
                color: AppColors.uvMist,
              ),
            ),
        ],
      ],
    );
  }
}
