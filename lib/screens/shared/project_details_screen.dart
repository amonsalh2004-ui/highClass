import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../designer/part_details_screen.dart';
import '../engineer/cnc_execution_details_screen.dart';
import 'create_project_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  final bool readOnly; // engineers can view but not edit parts list
  const ProjectDetailsScreen(
      {super.key, required this.project, this.readOnly = false});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final completed =
        project.parts.where((p) => p.designStatus == DesignStatus.completed).length;

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(
            title: 'تفاصيل المشروع',
            showBack: true,
            height: 130,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.greyBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.home_outlined,
                              color: AppColors.gold, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(project.projectName,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text('العميل: ${project.clientName}',
                                  style:
                                      const TextStyle(color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              Text(
                                'أنشئ في ${_fmt(project.createdAt)}',
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.folder_open,
                                    color: AppColors.gold, size: 18),
                                label: const Text('فتح Drive',
                                    style: TextStyle(color: AppColors.gold)),
                                style: OutlinedButton.styleFrom(
                                  side:
                                      const BorderSide(color: AppColors.gold),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('تقدم المشروع',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                              child: Text(
                                '${(project.progress * 100).round()}%',
                                style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: project.progress,
                                  minHeight: 10,
                                  backgroundColor: AppColors.greyBg,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('$completed من ${project.parts.length} مكتملة',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الأجزاء',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      if (!widget.readOnly)
                        OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    CreateProjectScreen(existing: project)));
                            setState(() {});
                          },
                          icon: const Icon(Icons.add, color: AppColors.gold),
                          label: const Text('إضافة جزء',
                              style: TextStyle(color: AppColors.gold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.gold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...project.parts.map((part) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PartRow(
                          part: part,
                          readOnly: widget.readOnly,
                          onReturn: () => setState(() {}),
                        ),
                      )),
                  if (widget.readOnly)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.greyBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.textMuted, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'يمكنك الاطلاع على حالة الـ CNC فقط، ولا يمكن تعديلها.',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _PartRow extends StatelessWidget {
  final Part part;
  final bool readOnly;
  final VoidCallback onReturn;
  const _PartRow(
      {required this.part, required this.onReturn, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => readOnly
                ? CncExecutionDetailsScreen(part: part)
                : PartDetailsScreen(part: part)));
        onReturn();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.greyBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chair_outlined, color: AppColors.gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(part.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  StatusPill(
                    label: part.designStatus.label,
                    color: part.designStatus.color,
                    bgColor: part.designStatus.bgColor,
                    icon: part.designStatus == DesignStatus.completed
                        ? Icons.check_circle
                        : Icons.schedule,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              part.designStatus == DesignStatus.completed
                  ? 'CNC ${part.cncStatus.label}'
                  : '-',
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
