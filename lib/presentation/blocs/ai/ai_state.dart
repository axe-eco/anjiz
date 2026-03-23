import 'package:equatable/equatable.dart';

/// حالات BLoC الذكاء الاصطناعي
abstract class AIState extends Equatable {
  const AIState();

  @override
  List<Object?> get props => [];
}

/// حالة خمول
class AIIdle extends AIState {}

/// جارٍ التحميل
class AILoading extends AIState {}

/// جارٍ التفكير — مع نص حالة
class AIThinking extends AIState {
  final String thought;

  const AIThinking(this.thought);

  @override
  List<Object?> get props => [thought];
}

/// تم توليد المهام بنجاح
class AIGenerated extends AIState {
  final List<Map<String, dynamic>> tasks;
  final List<String> suggestions;

  const AIGenerated({required this.tasks, required this.suggestions});

  @override
  List<Object?> get props => [tasks, suggestions];
}

/// خطأ
class AIError extends AIState {
  final String message;

  const AIError(this.message);

  @override
  List<Object?> get props => [message];
}
