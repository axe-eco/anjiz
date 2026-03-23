import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

/// شاشة إنشاء مشروع — وصف + قوالب جاهزة
class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _descController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime? _deadline;
  int _colorIndex = 0;

  final _templates = const [
    _Template(icon: Icons.phone_android, label: AppStrings.templateApp,
        desc: 'أريد بناء تطبيق موبايل متكامل بواجهة مستخدم حديثة وقاعدة بيانات سحابية'),
    _Template(icon: Icons.storefront, label: AppStrings.templateStore,
        desc: 'أريد إنشاء متجر إلكتروني لبيع المنتجات مع بوابة دفع وسلة مشتريات'),
    _Template(icon: Icons.campaign, label: AppStrings.templateMarketing,
        desc: 'أريد تخطيط حملة تسويقية رقمية شاملة عبر وسائل التواصل الاجتماعي'),
    _Template(icon: Icons.school, label: AppStrings.templateCourse,
        desc: 'أريد إنشاء كورس تعليمي أونلاين مع فيديوهات واختبارات وشهادات'),
  ];

  @override
  void dispose() {
    _descController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _useTemplate(_Template template) {
    _descController.text = template.desc;
    if (_nameController.text.isEmpty) {
      _nameController.text = template.label;
    }
  }

  void _generate() {
    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة وصف المشروع')),
      );
      return;
    }
    context.push('/ai-processing', extra: {
      'description': _descController.text.trim(),
      'name': _nameController.text.trim(),
      'deadline': _deadline?.toIso8601String(),
      'colorIndex': _colorIndex,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.createProject),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // حقل الوصف
          Text('وصف المشروع', style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLines: 5,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: AppStrings.projectDescription,
            ),
          ),
          const SizedBox(height: 20),

          // حقل الاسم
          Text(AppStrings.projectName, style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: AppTextStyles.bodyMedium,
            decoration: const InputDecoration(
              hintText: 'اسم المشروع...',
            ),
          ),
          const SizedBox(height: 20),

          // الموعد النهائي
          Text(AppStrings.deadline, style: AppTextStyles.label),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _deadline = date);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.spaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.spaceLift.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 18, color: AppColors.uvMist),
                  const SizedBox(width: 10),
                  Text(
                    _deadline != null
                        ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                        : 'اختر تاريخ...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _deadline != null
                          ? AppColors.uvPearl
                          : AppColors.uvMist,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // اختيار اللون
          Text(AppStrings.selectColor, style: AppTextStyles.label),
          const SizedBox(height: 8),
          Row(
            children: List.generate(AppColors.projectColors.length, (i) {
              final isSelected = i == _colorIndex;
              return GestureDetector(
                onTap: () => setState(() => _colorIndex = i),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: AppColors.projectColors[i],
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                    boxShadow: isSelected
                        ? [BoxShadow(
                            color: AppColors.projectColors[i].withValues(alpha: 0.5),
                            blurRadius: 8,
                          )]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 28),

          // قوالب جاهزة
          Text(AppStrings.templates, style: AppTextStyles.label),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _templates.map((t) {
              return GestureDetector(
                onTap: () => _useTemplate(t),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.spaceCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.spaceLift),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(t.icon, size: 16, color: AppColors.uvBright),
                      const SizedBox(width: 6),
                      Text(t.label, style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.uvPearl,
                      )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // زر التوليد
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.brandGrad,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.uvCore.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _generate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(AppStrings.generateWithAI, style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Template {
  final IconData icon;
  final String label;
  final String desc;

  const _Template({required this.icon, required this.label, required this.desc});
}
