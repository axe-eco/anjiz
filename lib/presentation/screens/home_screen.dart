import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../blocs/project/project_bloc.dart';
import '../blocs/project/project_event.dart';
import '../blocs/project/project_state.dart';
import '../widgets/anjiz_logo.dart';
import '../widgets/project_card.dart';
import '../widgets/bottom_nav_bar.dart';

/// الشاشة الرئيسية — قائمة المشاريع مع إحصائيات
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(LoadProjects());
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0: break; // الرئيسية - الحالية
      case 1: break; // مشاريعي - نفس الشاشة
      case 2: context.push('/ideas/all'); break;
      case 3: context.push('/analytics'); break;
      case 4: context.push('/settings'); break;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // شريط العنوان
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const AnjizLogo(size: 32, showText: false),
                  const SizedBox(width: 10),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.neonGrad.createShader(bounds),
                    child: Text(
                      AppStrings.appName,
                      style: AppTextStyles.heading2.copyWith(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  // زر الإشعارات
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.uvMist,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // المحتوى
            Expanded(
              child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.uvCore),
                    );
                  }
                  if (state is ProjectError) {
                    return Center(
                      child: Text(state.message, style: AppTextStyles.bodyMedium),
                    );
                  }
                  if (state is ProjectLoaded) {
                    return _buildContent(state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      // زر إنشاء مشروع
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.brandGrad,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.uvCore.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.push('/create'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildContent(ProjectLoaded state) {
    final projects = state.projects;
    final activeCount = projects.where((p) => !p.isCompleted).length;
    final avgProgress = projects.isEmpty
        ? 0.0
        : projects.map((p) => p.progress).reduce((a, b) => a + b) /
            projects.length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // بطاقات الإحصائيات
        Row(
          children: [
            _StatCard(
              icon: Icons.folder_open_rounded,
              label: AppStrings.activeProjects,
              value: '$activeCount',
              color: AppColors.uvBright,
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: Icons.trending_up_rounded,
              label: AppStrings.avgProgress,
              value: '${(avgProgress * 100).round()}%',
              color: AppColors.mintCore,
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: Icons.local_fire_department_rounded,
              label: AppStrings.streak,
              value: '3',
              color: AppColors.amberCore,
            ),
          ],
        ),
        const SizedBox(height: 24),
        // قائمة المشاريع
        if (projects.isEmpty)
          _buildEmptyState()
        else ...[
          Row(
            children: [
              Text(AppStrings.navProjects, style: AppTextStyles.heading3),
              const Spacer(),
              IconButton(
                onPressed: () => context.push('/search'),
                icon: const Icon(Icons.search_rounded, color: AppColors.uvMist),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...projects.map(
            (p) => ProjectCard(
              project: p,
              onTap: () => context.push('/project/${p.id}'),
            ),
          ),
          const SizedBox(height: 80), // مساحة للـ FAB
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Icon(
              Icons.rocket_launch_rounded,
              size: 64,
              color: AppColors.uvMist.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(AppStrings.noProjects, style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              AppStrings.createFirstProject,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(fontSize: 9),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
