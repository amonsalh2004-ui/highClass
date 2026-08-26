import '../models/models.dart';

/// Simple in-memory "database" (singleton) so all screens share state
/// without needing a backend. Seeded to resemble the provided mockups.
class AppData {
  AppData._internal() {
    _seed();
  }
  static final AppData instance = AppData._internal();

  final List<Project> projects = [];

  void _seed() {
    final naser = Project(
      id: 'p1',
      clientName: 'ناصر عرار',
      projectName: 'بيت ناصر عرار',
      description: 'فيلا سكنية - مطبخ وغرفة نوم رئيسية',
      driveLink: 'https://drive.google.com/folder/naser',
      createdAt: DateTime(2026, 8, 25),
      parts: [
        Part(
          id: 'pt1',
          name: 'مطبخ',
          description: 'مطبخ داخلي مع خزائن علوية وسفلية',
          designStatus: DesignStatus.inProgress,
          cncStatus: CncStatus.waiting,
          missingInfo: ['قياسات الجدار', 'نقاط الكهرباء'],
          notes: [
            NoteEntry(
                author: 'أحمد',
                text: 'بدأ التصميم',
                time: DateTime(2025, 5, 20, 10, 30)),
            NoteEntry(
                author: 'أحمد',
                text: 'العميل طلب لوناً مختلفاً',
                time: DateTime(2025, 5, 20, 14, 45)),
          ],
        ),
        Part(
          id: 'pt2',
          name: 'غرفة ماستر',
          description: 'غرفة نوم رئيسية مع خزانة ملابس',
          designStatus: DesignStatus.completed,
          cncStatus: CncStatus.inProgress,
          notes: [
            NoteEntry(
                author: 'خالد',
                text: 'بدأ CNC',
                time: DateTime(2025, 5, 14, 10, 15)),
            NoteEntry(
                author: 'خالد',
                text: 'تمت مراجعة المخطط والتأكد من المقاسات',
                time: DateTime(2025, 5, 14, 9, 30)),
          ],
        ),
        Part(
          id: 'pt3',
          name: 'TV Unit',
          description: '',
          designStatus: DesignStatus.inProgress,
          cncStatus: CncStatus.waiting,
        ),
        Part(
          id: 'pt4',
          name: 'خزائن',
          description: '',
          designStatus: DesignStatus.notStarted,
          cncStatus: CncStatus.waiting,
        ),
      ],
    );

    final ahmadKitchen = Project(
      id: 'p2',
      clientName: 'أحمد محمد',
      projectName: 'مطبخ أحمد',
      parts: [
        Part(
          id: 'pt5',
          name: 'خزائن',
          designStatus: DesignStatus.completed,
          cncStatus: CncStatus.completed,
        ),
      ],
    );

    final newHouse = Project(
      id: 'p3',
      clientName: 'محمد بركات',
      projectName: 'بيت جديد',
      parts: [
        Part(
            id: 'pt6',
            name: 'TV Unit',
            designStatus: DesignStatus.notStarted,
            missingInfo: ['قياسات الجدار']),
        Part(id: 'pt7', name: 'مطبخ', designStatus: DesignStatus.inProgress),
        Part(id: 'pt8', name: 'غرفة نوم', designStatus: DesignStatus.notStarted),
        Part(id: 'pt9', name: 'مدخل', designStatus: DesignStatus.notStarted),
        Part(id: 'pt10', name: 'مكتبة', designStatus: DesignStatus.notStarted),
      ],
    );

    projects.addAll([naser, ahmadKitchen, newHouse]);
  }

  // ---- Aggregate stats (used by Manager dashboard) ----
  int get totalProjects => projects.length;

  int get notStartedCount => projects
      .expand((p) => p.parts)
      .where((pt) => pt.designStatus == DesignStatus.notStarted)
      .length;

  int get inDesignCount => projects
      .expand((p) => p.parts)
      .where((pt) => pt.designStatus == DesignStatus.inProgress)
      .length;

  int get deliveredCount => projects
      .expand((p) => p.parts)
      .where((pt) => pt.cncStatus == CncStatus.delivered)
      .length;

  int get inCncCount => projects
      .expand((p) => p.parts)
      .where((pt) => pt.cncStatus == CncStatus.inProgress)
      .length;

  int get cncReadyCount => projects
      .expand((p) => p.parts)
      .where((pt) =>
          pt.designStatus == DesignStatus.completed &&
          pt.cncStatus == CncStatus.waiting)
      .length;

  int get cncCompletedCount => projects
      .expand((p) => p.parts)
      .where((pt) => pt.cncStatus == CncStatus.completed)
      .length;

  List<Part> get partsNeedingAttention => projects
      .expand((p) => p.parts)
      .where((pt) => pt.missingInfo.isNotEmpty)
      .toList();

  Project projectOfPart(Part part) =>
      projects.firstWhere((p) => p.parts.contains(part));
}
