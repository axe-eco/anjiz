import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/dark_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/services/gemini_service.dart';
import 'data/repositories/project_repository.dart';
import 'presentation/blocs/project/project_bloc.dart';
import 'presentation/blocs/task/task_bloc.dart';
import 'presentation/blocs/ai/ai_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await HiveService.init();

  runApp(const AnjizApp());
}

/// التطبيق الرئيسي — أنجز
class AnjizApp extends StatelessWidget {
  const AnjizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProjectRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProjectBloc(repository: repository)),
        BlocProvider(create: (_) => TaskBloc(repository: repository)),
          BlocProvider(
            create: (context) => AIBloc(geminiService: GeminiService()),
          ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        routerConfig: appRouter,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
