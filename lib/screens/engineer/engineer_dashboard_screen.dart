import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../shared/projects_list_screen.dart';
import 'cnc_execution_details_screen.dart';
import '../login_screen.dart';

class EngineerDashboardScreen extends StatefulWidget {
  const EngineerDashboardScreen({super.key});

  @override
  State<EngineerDashboardScreen> createState() =>
      _EngineerDashboardScreenState();
}

class _EngineerDashboardScreenState extends State<EngineerDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const _CncHomeTab(),
      const _CncRequestsPlaceholder(),
      const ProjectsListScreen(readOnly: true),
      const _AccountPlaceholder(),
    ];

    return Scaffold(
      body: IndexedStack(index: _navIndex, children: tabs),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined), label: 'طلبات CNC'),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline), label: 'المشاريع'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}

class _CncHomeTab extends StatefulWidget {
  const _CncHomeTab();
  @override
  State<_CncHomeTab> createState() => _CncHomeTabState();
}

class _CncHomeTabState extends State<_CncHomeTab> {
  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    final allParts = data.projects.expand((p) => p.parts).toList();
    final completed =
        allParts.where((p) => p.cncStatus == CncStatus.completed).length;
    final inProgress =
        allParts.where((p) => p.cncStatus == CncStatus.inProgress).length;
    final readyForCnc = allParts
        .where((p) =>
            p.designStatus == DesignStatus.completed &&
            p.cncStatus == CncStatus.waiting)
        .toList();
    final designReady = allParts
        .where((p) => p.designStatus == DesignStatus.completed)
        .length;

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(
            title: 'لوحة الـ CNC',
            height: 210,
            trailing: const RolePill(label: 'المهندس صابر', icon: Icons.engineering),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'مكتمل',
                          value: '$completed',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'قيد التنفيذ',
                          value: '$inProgress',
                          icon: Icons.schedule,
                          color: AppColors.maroon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'جاهز للـ CNC',
                          value: '$designReady',
                          icon: Icons.precision_manufacturing_outlined,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'جاهز للتنفيذ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.filter_list,
                        color: AppColors.maroon,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (readyForCnc.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('لا توجد أجزاء جاهزة للتنفيذ حالياً',
                            style: TextStyle(color: AppColors.textMuted)),
                      ),
                    ),
                  ...readyForCnc.map((part) {
                    final project = data.projectOfPart(part);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _CncReadyCard(
                        part: part,
                        projectName: project.projectName,
                        onStart: () {
                          setState(() => part.cncStatus = CncStatus.inProgress);
                        },
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  CncExecutionDetailsScreen(part: part)));
                          setState(() {});
                        },
                      ),
                    );
                  }),
const SizedBox(height: 6),
const Align(
  alignment: AlignmentDirectional.centerStart,
  child: Text(
    'قيد التنفيذ حالياً',
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                  const SizedBox(height: 12),
                  ...allParts
                      .where((p) => p.cncStatus == CncStatus.inProgress)
                      .map((part) {
                    final project = data.projectOfPart(part);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CncInProgressCard(
                        part: part,
                        projectName: project.projectName,
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  CncExecutionDetailsScreen(part: part)));
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CncReadyCard extends StatelessWidget {
  final Part part;
  final String projectName;
  final VoidCallback onStart;
  final VoidCallback onTap;
  const _CncReadyCard(
      {required this.part,
      required this.projectName,
      required this.onStart,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
            // In RTL the first child is visually on the right.
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.greyBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.chair_outlined,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    part.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    projectName,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  const Divider(height: 1),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'حالة التصميم',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusPill(
                        label: 'مكتمل التصميم',
                        color: AppColors.success,
                        bgColor: AppColors.successBg,
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'حالة الـ CNC',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusPill(
                        label: 'انتظار',
                        color: AppColors.gold,
                        bgColor: AppColors.warningBg,
                        icon: Icons.schedule,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(90, 46),
                padding: EdgeInsets.zero,
              ),
              child: const Text('بدء CNC'),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CncInProgressCard extends StatelessWidget {
  final Part part;
  final String projectName;
  final VoidCallback onTap;
  const _CncInProgressCard(
      {required this.part, required this.projectName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
            const CircleAvatar(
              backgroundColor: AppColors.maroon,
              child:
                  Icon(Icons.precision_manufacturing, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            /*
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    part.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    projectName,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
*/

Expanded(
  child: Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            part.name,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Text(
            projectName,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  ),
),

            StatusPill(
              label: 'قيد التنفيذ',
              color: AppColors.maroon,
              bgColor: AppColors.maroon.withValues(alpha: 0.08),
            ),

            ],
          ),
        ),
      ),
    );
  }
}

class _CncRequestsPlaceholder extends StatelessWidget {
  const _CncRequestsPlaceholder();
  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    final requests = data.projects
        .expand((p) => p.parts)
        .where((p) => p.designStatus == DesignStatus.completed)
        .toList();
    return Scaffold(
      body: Column(
        children: [
          const BrandHeader(title: 'طلبات CNC', height: 170),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final part = requests[i];
                  final project = data.projectOfPart(part);
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(

                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [


                            Text(part.name,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),


                            Text(project.projectName,
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),


                          ],
                        ),
                        const Spacer(),
                        StatusPill(
                          label: part.cncStatus.label,
                          color: part.cncStatus.color,
                          bgColor: part.cncStatus.color.withValues(alpha: 0.1),
                        ),








                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountPlaceholder extends StatelessWidget {
  const _AccountPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BrandHeader(title: 'حسابي', height: 170),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false),
                    icon: const Icon(Icons.logout),
                    label: const Text('تسجيل الخروج'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
