import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import 'project_details_screen.dart';
import 'create_project_screen.dart';

class ProjectsListScreen extends StatefulWidget {
  final bool readOnly;
  const ProjectsListScreen({super.key, this.readOnly = false});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  String _query = '';
  String _filter = 'الكل';
  final _filters = const ['الكل', 'لم يبدأ', 'قيد التصميم', 'مكتمل'];

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    var projects = data.projects.where((p) {
      final matchesQuery = _query.isEmpty ||
          p.projectName.contains(_query) ||
          p.clientName.contains(_query);
      final matchesFilter =
          _filter == 'الكل' || p.overallStatusLabel == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(title: 'مشاريعي', height: 210, leading: _bell()),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    textAlign: TextAlign.right,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن مشروع أو عميل',
                      suffixIcon: Icon(Icons.search, color: AppColors.maroon),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final f = _filters[i];
                        final selected = f == _filter;
                        return ChoiceChip(
                          label: Text(f),
                          selected: selected,
                          onSelected: (_) => setState(() => _filter = f),
                          selectedColor: AppColors.gold,
                          backgroundColor: AppColors.cardBackground,
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.maroonDark
                                : AppColors.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide.none,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.separated(
                      itemCount: projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, i) => _ProjectCard(
                        project: projects[i],
                        readOnly: widget.readOnly,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.readOnly
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GoldFab(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const CreateProjectScreen()));
                    setState(() {});
                  },
                ),
                const SizedBox(height: 6),
                const Text('مشروع جديد',
                    style: TextStyle(
                        color: AppColors.maroon, fontWeight: FontWeight.bold)),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _bell() => const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Icon(Icons.notifications_outlined, color: AppColors.gold),
      );
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final bool readOnly;
  const _ProjectCard({required this.project, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    final completed =
        project.parts.where((p) => p.designStatus == DesignStatus.completed).length;
    final inDesign = project.parts
        .where((p) => p.designStatus == DesignStatus.inProgress)
        .length;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              ProjectDetailsScreen(project: project, readOnly: readOnly))),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: const Border(
              right: BorderSide(color: AppColors.gold, width: 5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.greyBg,
              child: Icon(Icons.home_outlined, color: AppColors.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(project.projectName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${project.clientName} • ${project.parts.length} أجزاء',
                      style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  if (project.parts.length > 1)
                    Text('$completed مكتمل • $inDesign قيد التصميم',
                        style: const TextStyle(
                            color: AppColors.gold, fontWeight: FontWeight.w600))
                  else
                    Align(
                      alignment: Alignment.centerRight,
                      child: StatusPill(
                        label: project.overallStatusLabel,
                        color: project.overallStatusLabel == 'مكتمل'
                            ? AppColors.success
                            : AppColors.maroon,
                        bgColor: project.overallStatusLabel == 'مكتمل'
                            ? AppColors.successBg
                            : AppColors.maroon.withValues(alpha: 0.08),
                      ),
                    ),
                  if (project.parts.length > 1) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: project.progress,
                        minHeight: 6,
                        backgroundColor: AppColors.greyBg,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.maroon),
          ],
        ),
      ),
    );
  }
}
