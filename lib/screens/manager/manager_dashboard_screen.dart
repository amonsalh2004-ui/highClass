import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../widgets/common_widgets.dart';
import '../shared/projects_list_screen.dart';
import '../designer/part_details_screen.dart';
import '../login_screen.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() =>
      _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  int _navIndex = 0;

  final _tabs = [
    const _OverviewTab(),
    const ProjectsListScreen(),
    const _ReportsPlaceholder(),
    const _AccountPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _navIndex, children: _tabs),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline), label: 'المشاريع'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'التقارير'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    final totalParts = data.projects.expand((p) => p.parts).length;
    final notStarted = data.notStartedCount;
    final inDesign = data.inDesignCount;
    final delivered = data.deliveredCount;
    final inCnc = data.inCncCount;
    final needsAttention = data.partsNeedingAttention;

    double pct(int v) => totalParts == 0 ? 0 : v / totalParts;

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(
            title: 'نظرة عامة',
            height: 190,
            leading: const RolePill(label: 'مدير'),
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                          child: const Icon(Icons.apartment,
                              color: AppColors.gold, size: 26),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('إجمالي المشاريع',
                                style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w600)),
                            Text('${data.totalProjects}',
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.maroon)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'لم يبدأ',
                          value: '$notStarted',
                          icon: Icons.schedule,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'قيد التصميم',
                          value: '$inDesign',
                          icon: Icons.edit_outlined,
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
                          label: 'تم التسليم',
                          value: '$delivered',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'قيد الـ CNC',
                          value: '$inCnc',
                          icon: Icons.precision_manufacturing_outlined,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('تقدم المراحل',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        LabeledProgressBar(
                          label: 'قيد التصميم',
                          percent: pct(inDesign),
                          color: AppColors.maroon,
                          icon: Icons.edit_outlined,
                        ),
                        LabeledProgressBar(
                          label: 'قيد الـ CNC',
                          percent: pct(inCnc),
                          color: AppColors.gold,
                          icon: Icons.precision_manufacturing_outlined,
                        ),
                        LabeledProgressBar(
                          label: 'تم التسليم',
                          percent: pct(delivered),
                          color: AppColors.success,
                          icon: Icons.check_circle_outline,
                        ),
                        LabeledProgressBar(
                          label: 'لم يبدأ',
                          percent: pct(notStarted),
                          color: AppColors.grey,
                          icon: Icons.schedule,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('يحتاج متابعة',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        if (needsAttention.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('لا يوجد عناصر تحتاج متابعة حالياً',
                                style: TextStyle(color: AppColors.textMuted)),
                          ),
                        ...needsAttention.map((part) {
                          final project = data.projectOfPart(part);
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        PartDetailsScreen(part: part))),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.warningBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: AppColors.maroon,
                                    child: Icon(Icons.warning_amber_rounded,
                                        color: Colors.white, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(project.projectName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '${part.name} • ${part.missingInfo.join('، ')}',
                                            style: const TextStyle(
                                                color: AppColors.gold)),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_left,
                                      color: AppColors.textMuted),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.bar_chart,
                              color: AppColors.gold),
                          label: const Text('عرض التقارير',
                              style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            side: const BorderSide(color: AppColors.gold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
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
}

class _ReportsPlaceholder extends StatelessWidget {
  const _ReportsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BrandHeader(title: 'التقارير', height: 170),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: const Center(
                child: Text('لا توجد تقارير بعد',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
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
