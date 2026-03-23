import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

/// شاشة الإشعارات — اليوم / أمس
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotifItem> _notifications = [
    _NotifItem(type: 'ai', title: 'AI أنشأ خطة جديدة', body: 'تم تحليل مشروعك وإنشاء ٦ مهام', time: 'منذ ساعة', isRead: false, isToday: true),
    _NotifItem(type: 'achievement', title: 'إنجاز! 🎉', body: 'أكملت ٥ مهام فرعية اليوم', time: 'منذ ٣ ساعات', isRead: false, isToday: true),
    _NotifItem(type: 'reminder', title: 'تذكير', body: 'لديك ٣ مهام حرجة لم تبدأها بعد', time: 'منذ ٥ ساعات', isRead: true, isToday: true),
    _NotifItem(type: 'warning', title: 'تحذير ⚠️', body: 'موعد تسليم المشروع غداً', time: 'أمس', isRead: true, isToday: false),
    _NotifItem(type: 'ai', title: 'اقتراح من AI', body: 'يمكنك تحسين الأداء بإعادة ترتيب الأولويات', time: 'أمس', isRead: true, isToday: false),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = _notifications.where((n) => n.isToday).toList();
    final yesterday = _notifications.where((n) => !n.isToday).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(AppStrings.markAllRead, style: AppTextStyles.caption),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (today.isNotEmpty) ...[
            Text(AppStrings.today, style: AppTextStyles.label),
            const SizedBox(height: 8),
            ...today.map((n) => _buildNotifCard(n)),
          ],
          if (yesterday.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(AppStrings.yesterday, style: AppTextStyles.label),
            const SizedBox(height: 8),
            ...yesterday.map((n) => _buildNotifCard(n)),
          ],
        ],
      ),
    );
  }

  Widget _buildNotifCard(_NotifItem notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notif.isRead ? AppColors.spaceCard : AppColors.uvCore.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: notif.isRead ? null : Border.all(color: AppColors.uvCore.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _notifIcon(notif.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif.title, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 2),
                Text(notif.body, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(notif.time, style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          ),
          if (!notif.isRead)
            Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.uvCore,
              ),
            ),
        ],
      ),
    );
  }

  Widget _notifIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'ai':
        icon = Icons.auto_awesome;
        color = AppColors.mintCore;
        break;
      case 'achievement':
        icon = Icons.emoji_events_rounded;
        color = AppColors.amberCore;
        break;
      case 'warning':
        icon = Icons.warning_amber_rounded;
        color = AppColors.magCore;
        break;
      default:
        icon = Icons.notifications_outlined;
        color = AppColors.uvBright;
    }
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _NotifItem {
  final String type;
  final String title;
  final String body;
  final String time;
  bool isRead;
  final bool isToday;

  _NotifItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.isToday,
  });
}
