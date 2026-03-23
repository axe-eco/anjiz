import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/idea_card.dart';

/// شاشة الأفكار — عرض اقتراحات AI
class IdeasScreen extends StatefulWidget {
  final String projectId;

  const IdeasScreen({super.key, required this.projectId});

  @override
  State<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  String _filter = 'الكل';
  final _filters = ['الكل', 'ميزات', 'تقنية', 'تسويق'];

  // أفكار تجريبية
  final _ideas = [
    {'title': 'إضافة وضع داكن/فاتح', 'desc': 'دعم تبديل السمة لراحة المستخدم', 'category': 'ميزات', 'rating': 4},
    {'title': 'تكامل مع التقويم', 'desc': 'ربط المواعيد النهائية مع تقويم الهاتف', 'category': 'ميزات', 'rating': 5},
    {'title': 'تحسين أداء التطبيق', 'desc': 'استخدام التحميل الكسول وتقنيات التخزين المؤقت', 'category': 'تقنية', 'rating': 3},
    {'title': 'مشاركة التقدم عبر وسائل التواصل', 'desc': 'السماح للمستخدمين بمشاركة إنجازاتهم', 'category': 'تسويق', 'rating': 4},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredIdeas = _filter == 'الكل'
        ? _ideas
        : _ideas.where((i) => i['category'] == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('أفكار'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          // فلاتر
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _filters.map((f) {
                final isActive = f == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.uvCore : AppColors.spaceCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      f,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isActive ? Colors.white : AppColors.uvMist,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // قائمة الأفكار
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredIdeas.length,
              itemBuilder: (_, i) {
                final idea = filteredIdeas[i];
                return IdeaCard(
                  title: idea['title'] as String,
                  description: idea['desc'] as String,
                  category: idea['category'] as String,
                  rating: idea['rating'] as int,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
