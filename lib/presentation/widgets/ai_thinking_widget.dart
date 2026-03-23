import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// ويدجت تفكير AI — أيقونة متحركة مع نص حالة
class AIThinkingWidget extends StatefulWidget {
  final String thought;

  const AIThinkingWidget({super.key, required this.thought});

  @override
  State<AIThinkingWidget> createState() => _AIThinkingWidgetState();
}

class _AIThinkingWidgetState extends State<AIThinkingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // أيقونة AI متحركة
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.uvCore, AppColors.mintCore],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mintCore.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // نص الحالة
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            widget.thought,
            key: ValueKey(widget.thought),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mintNeon),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // مؤشر التحميل
        SizedBox(
          width: 120,
          child: LinearProgressIndicator(
            backgroundColor: AppColors.spaceLift,
            valueColor: const AlwaysStoppedAnimation(AppColors.mintCore),
            minHeight: 2,
          ),
        ),
      ],
    );
  }
}
