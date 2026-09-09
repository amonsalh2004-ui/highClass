import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../designer/part_details_screen.dart';
import '../engineer/cnc_execution_details_screen.dart';
import 'create_project_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  final bool readOnly;
  final UserRole currentRole;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    this.readOnly = false,
    this.currentRole = UserRole.designer,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    final completed = project.parts
        .where((p) => p.designStatus == DesignStatus.completed)
        .length;

    return Scaffold(
      body: Column(
        children: [
          // ================================================================
          // HEADER
          // ================================================================
          BrandHeader(
            title: 'تفاصيل المشروع',
            showBack: true,
            height: 130,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ======================================================
                    // PROJECT INFORMATION CARD
                    // ======================================================
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Project name + home icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              textDirection: TextDirection.rtl,
                              children: [
                                const Icon(
                                  Icons.home_outlined,
                                  color: AppColors.gold,
                                  size: 25,
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    project.projectName,
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // Client
                            Text(
                              'العميل: ${project.clientName}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Created date
                            Text(
                              'أنشئ في ${_fmt(project.createdAt)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Drive button
                            Align(
                              alignment: Alignment.centerRight,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.folder_open,
                                    color: AppColors.gold,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'فتح Drive',
                                    style: TextStyle(
                                      color: AppColors.gold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.gold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ======================================================
                    // PROJECT PROGRESS CARD
                    // ======================================================
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Title - RIGHT
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'تقدم المشروع',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Progress:
                            // RIGHT  = percentage
                            // CENTER = progress bar
                            // LEFT   = completed count
                            Row(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Percentage
                                CircleAvatar(
                                  backgroundColor:
                                      AppColors.gold.withValues(alpha: 0.15),
                                  child: Text(
                                    '${(project.progress * 100).round()}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Progress bar
                                Expanded(
                                  flex: 2,
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

                                // Completed count
                                Expanded(
                                  child: Text(
                                    '$completed من ${project.parts.length} مكتملة',
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ======================================================
                    // PARTS HEADER
                    // ======================================================
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // RIGHT
                        const Text(
                          'الأجزاء',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // LEFT
                        if (!widget.readOnly)
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CreateProjectScreen(existing: project),
                                  ),
                                );

                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.gold,
                              ),
                              label: const Text(
                                'إضافة جزء',
                                style: TextStyle(
                                  color: AppColors.gold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.gold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ======================================================
                    // PART CARDS
                    // ======================================================
                    ...project.parts.map(
                      (part) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PartRow(
                          part: part,
                          readOnly: widget.readOnly,
                          currentRole: widget.currentRole,
                          onReturn: () => setState(() {}),
                        ),
                      ),
                    ),

                    // ======================================================
                    // READ ONLY INFORMATION
                    // ======================================================
                    if (widget.readOnly)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'يمكنك الاطلاع على حالة الـ CNC فقط، ولا يمكن تعديلها.',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ============================================================================
// PART CARD
// ============================================================================

class _PartRow extends StatelessWidget {
  final Part part;
  final bool readOnly;
  final UserRole currentRole;
  final VoidCallback onReturn;

  const _PartRow({
    required this.part,
    required this.onReturn,
    this.readOnly = false,
    this.currentRole = UserRole.designer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      // ====================================================================
      // ORIGINAL NAVIGATION LOGIC — UNCHANGED
      // ====================================================================
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => readOnly
                ? CncExecutionDetailsScreen(
                    part: part,
                    currentRole: UserRole.engineer,
                  )
                : currentRole == UserRole.manager &&
                        part.designStatus == DesignStatus.completed
                    ? CncExecutionDetailsScreen(
                        part: part,
                        currentRole: UserRole.manager,
                      )
                    : PartDetailsScreen(
                        part: part,
                        currentRole: currentRole,
                      ),
          ),
        );

        onReturn();
      },

      // ====================================================================
      // RTL CARD
      // ====================================================================
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ============================================================
              // RIGHT — ICON
              // ============================================================
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: AppColors.greyBg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.chair_outlined,
                  color: AppColors.gold,
                  size: 42,
                ),
              ),

              const SizedBox(width: 14),

              // ============================================================
              // CENTER / RIGHT — PART NAME + DESIGN STATUS
              // ============================================================
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ------------------------------------------------------
                    // PART NAME
                    // ------------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        part.name,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ------------------------------------------------------
                    // DESIGN STATUS
                    //
                    // FittedBox prevents overflow on small screens.
                    // The status remains aligned to the RIGHT.
                    // ------------------------------------------------------
                    Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: StatusPill(
                          label: part.designStatus.label,
                          color: part.designStatus.color,
                          bgColor: part.designStatus.bgColor,
                          icon: part.designStatus ==
                                  DesignStatus.completed
                              ? Icons.check_circle
                              : Icons.schedule,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // ============================================================
              // LEFT — CNC STATUS
              // ============================================================
              SizedBox(
                width: 82,
                child: Text(
                  part.designStatus == DesignStatus.completed
                      ? 'CNC ${part.cncStatus.label}'
                      : '-',
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}