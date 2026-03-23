import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/repositories/project_repository.dart';

/// شاشة التحليلات — رسوم بيانية وإحصائيات
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ProjectRepository();
    final projects = repo.getAllProjects();
    final allTasks = repo.getAllTasks();

    final active = projects.where((p) => !p.isCompleted).length;
    final completed = projects.where((p) => p.isCompleted).length;
    final avgProgress = projects.isEmpty
        ? 0.0
        : projects.map((p) => p.progress).reduce((a, b) => a + b) / projects.length;
    final doneTasks = allTasks.where((t) => t.status == 'done').length;

    // بطاقة أفضل مشروع
    final bestProject = projects.isEmpty
        ? null
        : (projects.toList()..sort((a, b) => b.progress.compareTo(a.progress))).first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // إحصائيات سريعة (٢ صفوف × ٣)
          Row(
            children: [
              _AnalyticCard(label: AppStrings.active, value: '$active', color: AppColors.uvBright),
              const SizedBox(width: 8),
              _AnalyticCard(label: AppStrings.completed, value: '$completed', color: AppColors.mintCore),
              const SizedBox(width: 8),
              _AnalyticCard(label: AppStrings.overdue, value: '0', color: AppColors.magCore),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _AnalyticCard(label: 'مهام منجزة', value: '$doneTasks', color: AppColors.mintNeon),
              const SizedBox(width: 8),
              _AnalyticCard(label: AppStrings.avgProgress, value: '${(avgProgress * 100).round()}%', color: AppColors.uvBright),
              const SizedBox(width: 8),
              _AnalyticCard(label: AppStrings.streak, value: '3🔥', color: AppColors.amberCore),
            ],
          ),
          const SizedBox(height: 24),

          // رسم بياني — مهام هذا الأسبوع
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.spaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.tasksThisWeek, style: AppTextStyles.heading3),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 10,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['سبت', 'أحد', 'اثن', 'ثلا', 'أرب', 'خمي', 'جمع'];
                              return Text(
                                days[value.toInt()],
                                style: AppTextStyles.caption.copyWith(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(7, (i) {
                        final val = [3.0, 5.0, 2.0, 7.0, 4.0, 6.0, 1.0][i];
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: val,
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [AppColors.uvCore, AppColors.mintCore],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // بطاقة Streak
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.fireGrad,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3 أيام متتالية!',
                      style: AppTextStyles.heading3.copyWith(color: Colors.white),
                    ),
                    Text(
                      'استمر في الإنجاز كل يوم',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // أفضل مشروع
          if (bestProject != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.spaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.mintCore.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.amberCore, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أفضل مشروع تقدماً', style: AppTextStyles.caption),
                        Text(bestProject.title, style: AppTextStyles.bodyLarge),
                      ],
                    ),
                  ),
                  Text(
                    '${(bestProject.progress * 100).round()}%',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.mintCore),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AnalyticCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AnalyticCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.spaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10),
              textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
