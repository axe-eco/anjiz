import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/repositories/project_repository.dart';

/// شاشة البحث — بحث فوري في المشاريع والمهام
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _repository = ProjectRepository();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = _repository.getAllProjects()
        .where((p) => _query.isEmpty || p.title.contains(_query) || p.description.contains(_query))
        .toList();
    final tasks = _repository.getAllTasks()
        .where((t) => _query.isNotEmpty && t.title.contains(_query))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: AppStrings.search,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
              icon: const Icon(Icons.close_rounded, color: AppColors.uvMist),
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_rounded, size: 64,
                      color: AppColors.uvMist.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text('ابحث في المشاريع والمهام', style: AppTextStyles.bodySmall),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (projects.isNotEmpty) ...[
                  Text('مشاريع (${projects.length})', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  ...projects.map((p) => ListTile(
                    leading: const Icon(Icons.folder_rounded, color: AppColors.uvBright),
                    title: Text(p.title, style: AppTextStyles.bodyLarge),
                    subtitle: Text('${(p.progress * 100).round()}%', style: AppTextStyles.caption),
                    onTap: () => context.push('/project/${p.id}'),
                    tileColor: AppColors.spaceCard,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  )),
                ],
                if (tasks.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('مهام (${tasks.length})', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  ...tasks.map((t) => ListTile(
                    leading: const Icon(Icons.task_alt_rounded, color: AppColors.mintCore),
                    title: Text(t.title, style: AppTextStyles.bodyLarge),
                    subtitle: Text('${(t.progress * 100).round()}%', style: AppTextStyles.caption),
                    onTap: () => context.push('/task/${t.id}', extra: t.projectId),
                    tileColor: AppColors.spaceCard,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  )),
                ],
                if (projects.isEmpty && tasks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text('لا توجد نتائج لـ "$_query"', style: AppTextStyles.bodySmall),
                    ),
                  ),
              ],
            ),
    );
  }
}
