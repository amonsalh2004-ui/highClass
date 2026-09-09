import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class PartDetailsScreen extends StatefulWidget {
  final Part part;
  final UserRole currentRole;

  const PartDetailsScreen({
    super.key,
    required this.part,
    this.currentRole = UserRole.designer,
  });

  @override
  State<PartDetailsScreen> createState() => _PartDetailsScreenState();
}

class _PartDetailsScreenState extends State<PartDetailsScreen> {
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(
      text: widget.part.description,
    );
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _canEditPart =>
      widget.currentRole == UserRole.designer;

  bool get _canAddNotes =>
      widget.currentRole == UserRole.designer ||
      widget.currentRole == UserRole.manager;

  void _setStatus(DesignStatus status) {
    if (!_canEditPart) return;

    setState(() {
      widget.part.designStatus = status;
    });
  }

  // ==========================================================================
  // ADD NOTE
  // ==========================================================================

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
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 3,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'اكتب ملاحظتك...',
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

  // ==========================================================================
  // ADD MISSING DATA
  // ==========================================================================

  void _addMissingData() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'إضافة بيانات ناقصة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'اكتب البيانات الناقصة...',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    setState(() {
                      widget.part.missingData.insert(
                        0,
                        MissingDataItem(
                          author: 'المصمم',
                          text: controller.text.trim(),
                          time: DateTime.now(),
                        ),
                      );
                    });

                    Navigator.of(sheetContext).pop();
                  },
                  child: const Text('حفظ البيانات'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // EDIT DRIVE LINK
  // ==========================================================================

  void _editDriveLink() {
    final controller = TextEditingController(
      text: widget.part.driveLink,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'رابط Google Drive لملفات الجزء',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'https://drive.google.com/...',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final link = controller.text.trim();
                    final uri = Uri.tryParse(link);

                    if (uri == null || !uri.hasScheme) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'أدخل رابط Google Drive صحيحًا يبدأ بـ https://',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      widget.part.driveLink = link;
                    });

                    Navigator.of(sheetContext).pop();
                  },
                  child: const Text('حفظ الرابط'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // OPEN DRIVE LINK
  // ==========================================================================

  Future<void> _openDriveLink() async {
    final uri = Uri.tryParse(widget.part.driveLink);

    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لا يوجد رابط Drive صالح لهذا الجزء',
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
          content: Text('تعذر فتح رابط Drive'),
        ),
      );
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final part = widget.part;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            BrandHeader(
              title: 'تفاصيل الجزء',
              showBack: true,
              height: 150,
            ),

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
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      // ======================================================
                      // PART NAME
                      // ======================================================

                      Center(
                        child: Column(
                          children: [
                            Text(
                              part.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.maroon,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppData.instance
                                  .projectOfPart(part)
                                  .projectName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ======================================================
                      // DESIGN STATUS
                      // ======================================================

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'حالة التصميم',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      IgnorePointer(
                        ignoring: !_canEditPart,
                        child: Opacity(
                          opacity: _canEditPart ? 1 : 0.65,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Expanded(
                                child: _StatusOption(
                                  label: DesignStatus
                                      .completed
                                      .label,
                                  selected: part.designStatus ==
                                      DesignStatus.completed,
                                  color: AppColors.success,
                                  onTap: () => _setStatus(
                                    DesignStatus.completed,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _StatusOption(
                                  label: DesignStatus
                                      .inProgress
                                      .label,
                                  selected: part.designStatus ==
                                      DesignStatus.inProgress,
                                  color: AppColors.maroon,
                                  onTap: () => _setStatus(
                                    DesignStatus.inProgress,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _StatusOption(
                                  label: DesignStatus
                                      .notStarted
                                      .label,
                                  selected: part.designStatus ==
                                      DesignStatus.notStarted,
                                  color: AppColors.grey,
                                  onTap: () => _setStatus(
                                    DesignStatus.notStarted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ======================================================
                      // DESCRIPTION
                      // ======================================================

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الوصف',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _descCtrl,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        readOnly: !_canEditPart,
                        onChanged: _canEditPart
                            ? (v) => part.description = v
                            : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.greyBg,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ======================================================
                      // BUTTONS
                      // ======================================================

                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _canEditPart
                                  ? _addMissingData
                                  : null,
                              icon: const Icon(
                                Icons.info_outline,
                                color: AppColors.maroon,
                              ),
                              label: Text(
                                _canEditPart
                                    ? 'إضافة بيانات'
                                    : 'المعلومات المطلوبة',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.maroon,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size.fromHeight(50),
                                side: const BorderSide(
                                  color: AppColors.maroon,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _canEditPart
                                  ? _editDriveLink
                                  : part.driveLink.isEmpty
                                      ? null
                                      : _openDriveLink,
                              icon: const Icon(
                                Icons.folder_open,
                                color: AppColors.maroon,
                              ),
                              label: Text(
                                _canEditPart
                                    ? (part.driveLink.isEmpty
                                        ? 'إضافة رابط Drive'
                                        : 'تعديل رابط Drive')
                                    : (part.driveLink.isEmpty
                                        ? 'لا يوجد رابط Drive'
                                        : 'فتح ملفات الجزء'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.maroon,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size.fromHeight(50),
                                side: const BorderSide(
                                  color: AppColors.maroon,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ======================================================
                      // MISSING DATA
                      // ======================================================

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'البيانات الناقصة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.maroon,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (part.missingData.isEmpty)
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'لا توجد بيانات ناقصة مضافة بعد',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),

                      ...part.missingData.map(
                        (item) => _MissingDataTile(
                          item: item,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ======================================================
                      // NOTES HEADER
                      // ======================================================

                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: const [
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'الملاحظات',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.chat_bubble_outline,
                                color: AppColors.gold,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      if (part.notes.isEmpty)
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'لا توجد ملاحظات بعد',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),

                      // ======================================================
                      // NOTE CARDS
                      // ======================================================

                      ...part.notes.map(
                        (n) => _NoteTile(
                          note: n,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ======================================================
                      // ADD NOTE
                      // ======================================================

                      OutlinedButton.icon(
                        onPressed:
                            _canAddNotes ? _addNote : null,
                        icon: const Icon(
                          Icons.edit_note,
                          color: AppColors.maroon,
                        ),
                        label: const Text(
                          'إضافة ملاحظة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.maroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(52),
                          side: const BorderSide(
                            color: AppColors.maroon,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      // ======================================================
                      // CNC STATUS
                      // ======================================================

                      if (part.designStatus ==
                          DesignStatus.completed) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(
                                Icons.settings,
                                color: AppColors.gold,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'حالة CNC: ${part.cncStatus.label}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      part.cncStatus.color,
                                ),
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
      ),
    );
  }
}

// ============================================================================
// MISSING DATA TILE
// ============================================================================

class _MissingDataTile extends StatelessWidget {
  final MissingDataItem item;

  const _MissingDataTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final d = item.time;

    final dateText =
        '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

    final timeText =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RIGHT — AUTHOR + CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.author,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.maroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.text,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // LEFT — TIME + DATE
            SizedBox(
              width: 80,
              child: Text(
                '$timeText\n$dateText',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// STATUS OPTION
// ============================================================================

class _StatusOption extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? color
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? color
                : AppColors.greyBg,
            width: 1.4,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected
                ? Colors.white
                : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// NOTE TILE
// ============================================================================

class _NoteTile extends StatelessWidget {
  final NoteEntry note;

  const _NoteTile({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final d = note.time;

    final dateStr =
        '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

    final timeStr =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // RIGHT — AUTHOR + NOTE
            // ================================================================

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      note.author,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.maroon,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      note.text,
                      textAlign: TextAlign.right,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // ================================================================
            // LEFT — TIME + DATE
            // ================================================================

            SizedBox(
              width: 80,
              child: Text(
                '$timeStr\n$dateStr',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}