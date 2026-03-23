import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/gemini_service.dart';

/// شاشة الإعدادات — ملف شخصي + AI + إشعارات
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSuggestions = true;
  bool _smartPriorities = true;
  bool _notifications = true;
  bool _quietMode = false;
  final _geminiService = GeminiService();
  String? _apiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    _apiKey = await _geminiService.getApiKey();
    setState(() {});
  }

  void _showApiKeyDialog() {
    final controller = TextEditingController(text: _apiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.spaceCard,
        title: Text(AppStrings.apiKey, style: AppTextStyles.heading3),
        content: TextField(
          controller: controller,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(hintText: AppStrings.enterApiKey),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await _geminiService.saveApiKey(controller.text.trim());
              setState(() => _apiKey = controller.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ مفتاح API')),
                );
              }
            },
            child: Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة الملف الشخصي
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.spaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGrad,
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مستخدم أنجز', style: AppTextStyles.heading3),
                      const SizedBox(height: 2),
                      Text('النسخة المجانية', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.amberCore.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Pro', style: AppTextStyles.label.copyWith(
                    color: AppColors.amberCore, fontSize: 12,
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // قسم AI
          Text('الذكاء الاصطناعي', style: AppTextStyles.label),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.key_rounded,
            title: AppStrings.apiKey,
            subtitle: _apiKey?.isNotEmpty == true ? '••••••${_apiKey!.substring(_apiKey!.length > 6 ? _apiKey!.length - 4 : 0)}' : 'غير مضاف',
            trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.uvMist),
            onTap: _showApiKeyDialog,
          ),
          _SettingsTile(
            icon: Icons.psychology_rounded,
            title: AppStrings.aiModel,
            subtitle: 'Gemini 1.5 Flash',
            trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.uvMist),
          ),
          _SwitchTile(
            icon: Icons.auto_awesome,
            title: AppStrings.autoSuggestions,
            value: _autoSuggestions,
            onChanged: (v) => setState(() => _autoSuggestions = v),
          ),
          _SwitchTile(
            icon: Icons.sort_rounded,
            title: AppStrings.smartPriorities,
            value: _smartPriorities,
            onChanged: (v) => setState(() => _smartPriorities = v),
          ),
          const SizedBox(height: 24),

          // قسم الإشعارات
          Text(AppStrings.notifications, style: AppTextStyles.label),
          const SizedBox(height: 8),
          _SwitchTile(
            icon: Icons.notifications_rounded,
            title: 'إشعارات ذكية',
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          _SwitchTile(
            icon: Icons.do_not_disturb_on_rounded,
            title: AppStrings.quietMode,
            value: _quietMode,
            onChanged: (v) => setState(() => _quietMode = v),
          ),
          const SizedBox(height: 32),

          // تسجيل الخروج
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.magCore.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.magCore.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: AppColors.magCore, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.logout,
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.magCore),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.spaceCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.uvBright),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.spaceCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.uvBright),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.mintCore,
            activeThumbColor: AppColors.mintCore,
          ),
        ],
      ),
    );
  }
}
