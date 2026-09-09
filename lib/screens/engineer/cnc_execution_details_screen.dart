import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class CncExecutionDetailsScreen extends StatefulWidget {
  final Part part;
  final UserRole currentRole;

  const CncExecutionDetailsScreen({
    super.key,
    required this.part,
    this.currentRole = UserRole.engineer,
  });

  @override
  State<CncExecutionDetailsScreen> createState() =>
      _CncExecutionDetailsScreenState();
}

class _CncExecutionDetailsScreenState
    extends State<CncExecutionDetailsScreen> {
  bool get _canOperateCnc =>
      widget.currentRole == UserRole.engineer ||
      widget.currentRole == UserRole.manager;

  bool get _canAddNotes =>
      widget.currentRole == UserRole.engineer ||
      widget.currentRole == UserRole.manager;

  void _addNote() {
    if (!_canAddNotes) return;

    final ctrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'إضافة ملاحظة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ctrl,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'اكتب ملاحظتك...',
                    hintTextDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (ctrl.text.trim().isEmpty) return;

                    setState(() {
                      widget.part.notes.insert(
                        0,
                        NoteEntry(
                          author: widget.currentRole.label,
                          text: ctrl.text.trim(),
                          time: DateTime.now(),
                        ),
                      );
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('إضافة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openDriveLink() async {
    final uri = Uri.tryParse(widget.part.driveLink);

    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لا يوجد رابط Drive صالح لهذا الجزء',
            textAlign: TextAlign.right,
          ),
        ),
      );
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر فتح رابط Drive',
            textAlign: TextAlign.right,
          ),
        ),
      );
    }
  }

  void _startCnc() {
    if (!_canOperateCnc ||
        widget.part.designStatus != DesignStatus.completed ||
        widget.part.cncStatus != CncStatus.waiting) {
      return;
    }

    setState(() {
      widget.part.cncStatus = CncStatus.inProgress;

      widget.part.notes.insert(
        0,
        NoteEntry(
          author: widget.currentRole.label,
          text: 'تم بدء تنفيذ CNC',
          time: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم بدء تنفيذ CNC',
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  void _finishCnc() {
    if (!_canOperateCnc ||
        widget.part.cncStatus != CncStatus.inProgress) {
      return;
    }

    setState(() {
      widget.part.cncStatus = CncStatus.completed;

      widget.part.notes.insert(
        0,
        NoteEntry(
          author: widget.currentRole.label,
          text: 'تم إنهاء تنفيذ CNC',
          time: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم إنهاء الـ CNC بنجاح',
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  void _confirmDelivery() {
    if (widget.currentRole != UserRole.manager ||
        widget.part.cncStatus != CncStatus.completed) {
      return;
    }

    setState(() {
      widget.part.cncStatus = CncStatus.delivered;

      widget.part.notes.insert(
        0,
        NoteEntry(
          author: UserRole.manager.label,
          text: 'تم تأكيد تسليم الجزء',
          time: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم تأكيد تسليم الجزء بنجاح',
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final part = widget.part;
    final project = AppData.instance.projectOfPart(part);

    final steps = [
      (CncStatus.waiting, 'انتظار'),
      (CncStatus.inProgress, 'قيد التنفيذ'),
      (CncStatus.completed, 'مكتمل'),
      (CncStatus.delivered, 'تم التسليم'),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            BrandHeader(
              title: 'تفاصيل التنفيذ',
              showBack: true,
              height: 150,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part.name,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.maroon,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              project.projectName,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE7DFD6),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'حالة التصميم:',
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        part.designStatus ==
                                                DesignStatus.completed
                                            ? Icons.check_circle
                                            : Icons.schedule,
                                        color: part.designStatus.color,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        part.designStatus.label,
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          color: part.designStatus.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: OutlinedButton(
                              onPressed: part.driveLink.isEmpty
                                  ? null
                                  : _openDriveLink,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(60),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFE7DFD6),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    color: AppColors.gold,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'ملفات الجزء:',
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          part.driveLink.isEmpty
                                              ? 'لا يوجد رابط'
                                              : 'فتح Drive',
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          style: const TextStyle(
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.bold,
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

                      if (part.missingData.isNotEmpty) ...[
                        const SizedBox(height: 22),

                        const Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'البيانات الناقصة',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.maroon,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        ...part.missingData.map((item) {
                          final dateText =
                              '${item.time.year}/${item.time.month.toString().padLeft(2, '0')}/${item.time.day.toString().padLeft(2, '0')}';

                          final timeText =
                              '${item.time.hour.toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')}';

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.warningBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.gold.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.text,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'أضافها: ${item.author} • $dateText • $timeText',
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: 26),

                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'حالة الـ CNC',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: List.generate(
                            steps.length,
                            (i) {
                              final (status, label) = steps[i];

                              final active =
                                  status == part.cncStatus;

                              final passed =
                                  status.step <= part.cncStatus.step;

                              return Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        if (i <
                                            steps.length - 1)
                                          Expanded(
                                            child: Container(
                                              height: 2,
                                              color: passed
                                                  ? AppColors.gold
                                                  : AppColors.greyBg,
                                            ),
                                          ),

                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: active
                                                ? AppColors.maroon
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: active
                                                  ? AppColors.maroon
                                                  : AppColors.gold,
                                              width: 1.5,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${status.step}',
                                            textDirection:
                                                TextDirection.ltr,
                                            style: TextStyle(
                                              color: active
                                                  ? Colors.white
                                                  : AppColors.gold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        if (i > 0)
                                          Expanded(
                                            child: Container(
                                              height: 2,
                                              color: passed
                                                  ? AppColors.gold
                                                  : AppColors.greyBg,
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 7),

                                    Text(
                                      label,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: active
                                            ? AppColors.maroon
                                            : AppColors.gold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            if (part.notes.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  'لا يوجد سجل بعد',
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),

                            for (int i = 0;
                                i < part.notes.length;
                                i++) ...[
                              _TimelineNote(
                                note: part.notes[i],
                              ),
                              if (i != part.notes.length - 1)
                                const Divider(height: 20),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      OutlinedButton(
                        onPressed: _canAddNotes ? _addNote : null,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(
                            color: AppColors.maroon,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.edit_note,
                              color: AppColors.maroon,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'إضافة ملاحظة',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: AppColors.maroon,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (part.cncStatus == CncStatus.waiting &&
                          _canOperateCnc)
                        ElevatedButton(
                          onPressed: _startCnc,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.precision_manufacturing,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'بدء CNC',
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        )
                      else if (part.cncStatus ==
                              CncStatus.inProgress &&
                          _canOperateCnc)
                        ElevatedButton(
                          onPressed: _finishCnc,
                          child: const Text(
                            'إنهاء CNC',
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      else if (part.cncStatus ==
                              CncStatus.completed &&
                          widget.currentRole == UserRole.manager)
                        ElevatedButton(
                          onPressed: _confirmDelivery,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_shipping_outlined,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'تأكيد التسليم',
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.greyBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            part.cncStatus == CncStatus.waiting
                                ? 'لم يبدأ التنفيذ بعد'
                                : part.cncStatus ==
                                        CncStatus.inProgress
                                    ? 'التنفيذ قيد التقدم'
                                    : 'تم إنهاء تنفيذ هذا الجزء',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      const SizedBox(height: 10),

                      const Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'بيانات التصميم للقراءة فقط',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineNote extends StatelessWidget {
  final NoteEntry note;

  const _TimelineNote({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final d = note.time;

    final dateStr =
        '${d.day} ${_monthName(d.month)} ${d.year}';

    final timeStr =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.maroon,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 16,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  note.text,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'بواسطة ${note.author}',
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '$dateStr • $timeStr',
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return names[m - 1];
  }
}