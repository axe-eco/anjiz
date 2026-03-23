import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/gemini_service.dart';
import 'ai_event.dart';
import 'ai_state.dart';

/// BLoC الذكاء الاصطناعي — توليد المهام من وصف المشروع
class AIBloc extends Bloc<AIEvent, AIState> {
  final GeminiService _geminiService;

  AIBloc({GeminiService? geminiService})
      : _geminiService = geminiService ?? GeminiService(),
        super(AIIdle()) {
    on<GenerateTasks>(_onGenerateTasks);
    on<RegeneratePlan>(_onRegeneratePlan);
    on<AcceptPlan>(_onAcceptPlan);
    on<ResetAI>(_onResetAI);
  }

  Future<void> _onGenerateTasks(
    GenerateTasks event,
    Emitter<AIState> emit,
  ) async {
    emit(const AIThinking('جارٍ تحليل وصف المشروع...'));
    await Future.delayed(const Duration(milliseconds: 800));

    emit(const AIThinking('اكتشاف المهام الرئيسية...'));
    await Future.delayed(const Duration(milliseconds: 600));

    emit(const AIThinking('تحديد الأولويات الذكية...'));

    try {
      final result = await _geminiService.generateTasks(event.description);
      final tasks = (result['tasks'] as List<dynamic>?)
              ?.map((t) => t as Map<String, dynamic>)
              .toList() ??
          [];
      final suggestions = (result['suggestions'] as List<dynamic>?)
              ?.map((s) => s.toString())
              .toList() ??
          [];

      emit(AIGenerated(tasks: tasks, suggestions: suggestions));
    } catch (e) {
      emit(AIError(e.toString()));
    }
  }

  Future<void> _onRegeneratePlan(
    RegeneratePlan event,
    Emitter<AIState> emit,
  ) async {
    // إعادة التوليد بنفس الوصف
    add(GenerateTasks(event.description));
  }

  Future<void> _onAcceptPlan(
    AcceptPlan event,
    Emitter<AIState> emit,
  ) async {
    // ستتم المعالجة في الشاشة
    emit(AIIdle());
  }

  Future<void> _onResetAI(
    ResetAI event,
    Emitter<AIState> emit,
  ) async {
    emit(AIIdle());
  }
}
