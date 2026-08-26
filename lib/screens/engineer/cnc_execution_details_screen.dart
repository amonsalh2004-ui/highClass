import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class CncExecutionDetailsScreen extends StatefulWidget {
  final Part part;
  const CncExecutionDetailsScreen({super.key, required this.part});

  @override
  State<CncExecutionDetailsScreen> createState() =>
      _CncExecutionDetailsScreenState();
}

class _CncExecutionDetailsScreenState
    extends State<CncExecutionDetailsScreen> {
  void _addNote() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('إضافة ملاحظة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                textAlign: TextAlign.right,
                maxLines: 3,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'اكتب ملاحظتك...'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (ctrl.text.trim().isEmpty) return;
                  setState(() {
                    widget.part.notes.insert(
                      0,
                      NoteEntry(
                          author: 'أنت',
                          text: ctrl.text.trim(),
                          time: DateTime.now()),
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
    );
  }

  void _finishCnc() {
    setState(() {
      widget.part.cncStatus = CncStatus.completed;
      widget.part.notes.insert(
        0,
        NoteEntry(
            author: 'أنت', text: 'تم إنهاء تنفيذ CNC', time: DateTime.now()),
      );
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم إنهاء الـ CNC بنجاح')));
  }

  @override
  Widget build(BuildContext context) {
    final part = widget.part;
    final project = AppData.instance.projectOfPart(part);
    final steps = [
      (CncStatus.delivered, 'تم التسليم'),
      (CncStatus.completed, 'مكتمل'),
      (CncStatus.inProgress, 'قيد التنفيذ'),
      (CncStatus.waiting, 'انتظار'),
    ];

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(title: 'تفاصيل التنفيذ', showBack: true, height: 150),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(part.name,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.maroon)),
                          const SizedBox(height: 4),
                          Text(project.projectName,
                              style: const TextStyle(color: AppColors.gold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.folder_open,
                                color: AppColors.gold),
                            label: const Column(
                              children: [
                                Text('ملفات التصميم:',
                                    style: TextStyle(fontSize: 11)),
                                Text('فتح Drive',
                                    style: TextStyle(
                                        color: AppColors.gold,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60),
                              side: const BorderSide(color: Color(0xFFE7DFD6)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE7DFD6)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('حالة التصميم:',
                                    style: TextStyle(fontSize: 11)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      part.designStatus ==
                                              DesignStatus.completed
                                          ? Icons.check_circle
                                          : Icons.schedule,
                                      color: part.designStatus.color,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(part.designStatus.label,
                                        style: TextStyle(
                                            color: part.designStatus.color,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const Center(
                      child: Text('حالة الـ CNC',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(steps.length, (i) {
                        final (status, label) = steps[i];
                        final active = status == part.cncStatus;
                        final passed = status.step <= part.cncStatus.step;
                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (i != 0)
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        color: passed
                                            ? AppColors.gold
                                            : AppColors.greyBg,
                                      ),
                                    ),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: active
                                        ? AppColors.maroon
                                        : Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: active
                                              ? AppColors.maroon
                                              : AppColors.gold,
                                        ),
                                        color: active
                                            ? AppColors.maroon
                                            : Colors.transparent,
                                      ),
                                      width: 34,
                                      height: 34,
                                      alignment: Alignment.center,
                                      child: Text('${status.step}',
                                          style: TextStyle(
                                              color: active
                                                  ? Colors.white
                                                  : AppColors.gold,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  if (i != steps.length - 1)
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
                              const SizedBox(height: 6),
                              Text(label,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: active
                                          ? AppColors.maroon
                                          : AppColors.gold)),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 26),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.greyBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (part.notes.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('لا يوجد سجل بعد',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textMuted)),
                            ),
                          for (int i = 0; i < part.notes.length; i++) ...[
                            _TimelineNote(note: part.notes[i]),
                            if (i != part.notes.length - 1)
                              const Divider(height: 20),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: _addNote,
                      icon: const Icon(Icons.edit_note, color: AppColors.maroon),
                      label: const Text('إضافة ملاحظة',
                          style: TextStyle(
                              color: AppColors.maroon,
                              fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: AppColors.maroon),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (part.cncStatus == CncStatus.inProgress)
                      ElevatedButton(
                        onPressed: _finishCnc,
                        child: const Text('إنهاء CNC'),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.greyBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          part.cncStatus == CncStatus.waiting
                              ? 'لم يبدأ التنفيذ بعد'
                              : 'تم إنهاء تنفيذ هذا الجزء',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 14, color: AppColors.textMuted),
                        SizedBox(width: 6),
                        Text('بيانات التصميم للقراءة فقط',
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
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
}

class _TimelineNote extends StatelessWidget {
  final NoteEntry note;
  const _TimelineNote({required this.note});

  @override
  Widget build(BuildContext context) {
    final d = note.time;
    final dateStr = '${d.day} ${_monthName(d.month)} ${d.year}';
    final timeStr =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.maroon,
          child: Icon(Icons.person, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${note.author} — ${note.text}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('$dateStr  •  $timeStr',
                  style: const TextStyle(color: AppColors.gold, fontSize: 12)),
            ],
          ),
        ),
      ],
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
      'ديسمبر'
    ];
    return names[m - 1];
  }
}
