import 'package:equatable/equatable.dart';

/// أحداث BLoC الذكاء الاصطناعي
abstract class AIEvent extends Equatable {
  const AIEvent();

  @override
  List<Object?> get props => [];
}

/// توليد مهام من وصف المشروع
class GenerateTasks extends AIEvent {
  final String description;

  const GenerateTasks(this.description);

  @override
  List<Object?> get props => [description];
}

/// قبول الخطة المولّدة
class AcceptPlan extends AIEvent {}

/// إعادة التوليد
class RegeneratePlan extends AIEvent {
  final String description;

  const RegeneratePlan(this.description);

  @override
  List<Object?> get props => [description];
}

/// مسح الحالة
class ResetAI extends AIEvent {}
