import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../shared/projects_list_screen.dart';
import 'part_details_screen.dart';
import '../login_screen.dart';

class DesignerDashboardScreen extends StatefulWidget {
  const DesignerDashboardScreen({super.key});

  @override
  State<DesignerDashboardScreen> createState() =>
      _DesignerDashboardScreenState();
}

class _DesignerDashboardScreenState extends State<DesignerDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const _DesignerHomeTab(),
      const ProjectsListScreen(),
      const _NotificationsPlaceholder(),
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
              icon: Icon(Icons.folder_outlined), label: 'المشاريع'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined), label: 'التنبيهات'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}

class _DesignerHomeTab extends StatefulWidget {
  const _DesignerHomeTab();

  @override
  State<_DesignerHomeTab> createState() => _DesignerHomeTabState();
}

class _DesignerHomeTabState extends State<_DesignerHomeTab> {
  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    final allParts = data.projects.expand((p) => p.parts).toList();
    final completed =
        allParts.where((p) => p.designStatus == DesignStatus.completed).length;
    final inProgress =
        allParts.where((p) => p.designStatus == DesignStatus.inProgress).length;
    final readyForCnc = allParts
        .where((p) =>
            p.designStatus == DesignStatus.completed &&
            p.cncStatus == CncStatus.waiting)
        .length;

    // "My current parts" — show in-progress + recently completed first.
    final myParts = [...allParts]
      ..sort((a, b) {
        int rank(Part p) => p.designStatus == DesignStatus.inProgress
            ? 0
            : p.designStatus == DesignStatus.completed
                ? 1
                : 2;
        return rank(a).compareTo(rank(b));
      });

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(
            title: 'لوحة التحكم',
            height: 190,
            
            leading: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(Icons.notifications_none, color: AppColors.gold),
            ),
            trailing: const RolePill(label: 'مصمم', icon: Icons.edit),
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
                          label: 'مكتمل التصميم',
                          value: '$completed',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'قيد التصميم',
                          value: '$inProgress',
                          icon: Icons.design_services_outlined,
                          color: AppColors.maroon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.gold.withValues(alpha: 0.25),
                          child: const Icon(Icons.precision_manufacturing,
                              color: AppColors.gold),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('جاهز للـ CNC',
                                style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600)),
                            Text('$readyForCnc',
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('أجزائي الحالية',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('عرض الكل',
                          style: TextStyle(color: AppColors.gold)),
                      
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...myParts.map((part) {
                    final project = data.projectOfPart(part);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DesignerPartCard(
                        part: part,
                        projectName: project.projectName,
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PartDetailsScreen(part: part)));
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

class _DesignerPartCard extends StatelessWidget {
  final Part part;
  final String projectName;
  final VoidCallback onTap;
  const _DesignerPartCard(
      {required this.part, required this.projectName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = part.designStatus == DesignStatus.completed
        ? 1.0
        : part.designStatus == DesignStatus.inProgress
            ? 0.7
            : 0.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة تكون في الجهة اليمنى.
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.greyBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.chair_outlined,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: StatusPill(
                        label: part.designStatus.label,
                        color: part.designStatus.color,
                        bgColor: part.designStatus.bgColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        part.name,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 220),
                            child: Text(
                              projectName,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), 
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'التقدم',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),                    
                    
                    const SizedBox(height: 4),

                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${(progress * 100).round()}%',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: AppColors.greyBg,
                              color: part.designStatus.color,
                            ),
                          ),
                        ),
                      ],
                    ),


                   



                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsPlaceholder extends StatelessWidget {
  const _NotificationsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BrandHeader(
            title: 'التنبيهات',
            height: 170,
            showTitle: false,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: const Center(
                child: Text('لا توجد تنبيهات جديدة',
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
          const BrandHeader(
            title: 'حسابي',
            height: 170,
            showTitle: false,
          ),
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