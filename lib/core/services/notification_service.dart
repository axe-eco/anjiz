/// خدمة الإشعارات — تذكيرات المهام والإنجازات
/// ملاحظة: تتطلب إعدادات إضافية للمنصة (Android/iOS)
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  /// تهيئة الإشعارات
  Future<void> init() async {
    // سيتم إعداد flutter_local_notifications لاحقاً
    // حسب متطلبات المنصة
  }

  /// إرسال إشعار إنجاز
  Future<void> showAchievement(String title, String body) async {
    // يتم تفعيله عند إكمال مهمة أو مشروع
  }

  /// إرسال تذكير
  Future<void> showReminder(String title, String body) async {
    // تذكير بمهمة قادمة
  }

  /// إرسال إشعار AI
  Future<void> showAINotification(String title, String body) async {
    // إشعار عند اكتمال تحليل AI
  }
}
