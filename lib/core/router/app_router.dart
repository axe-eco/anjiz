import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/create_project_screen.dart';
import '../../presentation/screens/ai_processing_screen.dart';
import '../../presentation/screens/project_detail_screen.dart';
import '../../presentation/screens/task_detail_screen.dart';
import '../../presentation/screens/priorities_screen.dart';
import '../../presentation/screens/ideas_screen.dart';
import '../../presentation/screens/analytics_screen.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/settings_screen.dart';

/// مسارات التنقل — GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── البداية ──
    GoRoute(
      path: '/',
      builder: (_, __) => const SplashScreen(),
    ),

    // ── التعريف ──
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),

    // ── الرئيسية ──
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeScreen(),
    ),

    // ── إنشاء مشروع ──
    GoRoute(
      path: '/create',
      builder: (_, __) => const CreateProjectScreen(),
    ),

    // ── معالجة AI ──
    GoRoute(
      path: '/ai-processing',
      builder: (_, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return AIProcessingScreen(projectData: data);
      },
    ),

    // ── تفاصيل مشروع ──
    GoRoute(
      path: '/project/:id',
      builder: (_, state) {
        final projectId = state.pathParameters['id']!;
        return ProjectDetailScreen(projectId: projectId);
      },
    ),

    // ── تفاصيل مهمة ──
    GoRoute(
      path: '/task/:id',
      builder: (_, state) {
        final taskId = state.pathParameters['id']!;
        final projectId = state.extra as String? ?? '';
        return TaskDetailScreen(taskId: taskId, projectId: projectId);
      },
    ),

    // ── الأولويات ──
    GoRoute(
      path: '/priorities/:projectId',
      builder: (_, state) {
        final projectId = state.pathParameters['projectId']!;
        return PrioritiesScreen(projectId: projectId);
      },
    ),

    // ── الأفكار ──
    GoRoute(
      path: '/ideas/:projectId',
      builder: (_, state) {
        final projectId = state.pathParameters['projectId']!;
        return IdeasScreen(projectId: projectId);
      },
    ),

    // ── التحليلات ──
    GoRoute(
      path: '/analytics',
      builder: (_, __) => const AnalyticsScreen(),
    ),

    // ── الإشعارات ──
    GoRoute(
      path: '/notifications',
      builder: (_, __) => const NotificationsScreen(),
    ),

    // ── البحث ──
    GoRoute(
      path: '/search',
      builder: (_, __) => const SearchScreen(),
    ),

    // ── الإعدادات ──
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
  ],
);
