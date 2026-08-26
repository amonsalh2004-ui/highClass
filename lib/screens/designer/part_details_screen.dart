import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class PartDetailsScreen extends StatefulWidget {
  final Part part;
  const PartDetailsScreen({super.key, required this.part});

  @override
  State<PartDetailsScreen> createState() => _PartDetailsScreenState();
}

class _PartDetailsScreenState extends State<PartDetailsScreen> {
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.part.description);
  }

  void _setStatus(DesignStatus status) {
    setState(() => widget.part.designStatus = status);
  }

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

  @override
  Widget build(BuildContext context) {
    final part = widget.part;
    return Scaffold(
      body: Column(
        children: [
          BrandHeader(title: 'تفاصيل الجزء', showBack: true, height: 150),
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
                          Text(AppData.instance.projectOfPart(part).projectName,
                              style: const TextStyle(color: AppColors.gold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('حالة التصميم',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _StatusOption(
                            label: DesignStatus.completed.label,
                            selected:
                                part.designStatus == DesignStatus.completed,
                            color: AppColors.success,
                            onTap: () => _setStatus(DesignStatus.completed),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatusOption(
                            label: DesignStatus.inProgress.label,
                            selected:
                                part.designStatus == DesignStatus.inProgress,
                            color: AppColors.maroon,
                            onTap: () => _setStatus(DesignStatus.inProgress),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatusOption(
                            label: DesignStatus.notStarted.label,
                            selected:
                                part.designStatus == DesignStatus.notStarted,
                            color: AppColors.grey,
                            onTap: () => _setStatus(DesignStatus.notStarted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('الوصف',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descCtrl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      onChanged: (v) => part.description = v,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('المعلومات الناقصة'),
                                  content: Text(part.missingInfo.isEmpty
                                      ? 'لا يوجد معلومات ناقصة'
                                      : part.missingInfo.join('\n')),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('إغلاق'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline,
                                color: AppColors.maroon),
                            label: const Text('المعلومات الناقصة',
                                style: TextStyle(color: AppColors.maroon)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(color: AppColors.maroon),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.folder_open,
                                color: AppColors.maroon),
                            label: const Text('فتح ملفات الجزء',
                                style: TextStyle(color: AppColors.maroon)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(color: AppColors.maroon),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (part.missingInfo.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('معلومات ناقصة',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.maroon)),
                                SizedBox(width: 6),
                                Icon(Icons.warning_amber_rounded,
                                    color: AppColors.gold, size: 18),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...part.missingInfo.map((m) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(m,
                                          style: const TextStyle(
                                              color: AppColors.textDark)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.circle,
                                          size: 8, color: AppColors.gold),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.chat_bubble_outline,
                            color: AppColors.gold),
                        Text('الملاحظات',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (part.notes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('لا توجد ملاحظات بعد',
                            style: TextStyle(color: AppColors.textMuted)),
                      ),
                    ...part.notes.map((n) => _NoteTile(note: n)),
                    const SizedBox(height: 16),
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
                    if (part.designStatus == DesignStatus.completed) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.settings,
                              color: AppColors.gold,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'حالة CNC: ${part.cncStatus.label}',
                              style: TextStyle(color: part.cncStatus.color),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _StatusOption extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _StatusOption(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color : AppColors.greyBg, width: 1.4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final NoteEntry note;
  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    final d = note.time;
    final dateStr =
        '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text('$timeStr\n$dateStr',
              textAlign: TextAlign.left,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(note.author,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.maroon)),
                const SizedBox(height: 2),
                Text(note.text, textAlign: TextAlign.right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
