import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

/// Used both for "مشروع جديد" (new project) and, when [existing] is passed,
/// for adding parts to an existing project ("إضافة جزء").
class CreateProjectScreen extends StatefulWidget {
  final Project? existing;
  const CreateProjectScreen({super.key, this.existing});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late final TextEditingController _clientCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _driveCtrl;
  late List<String> _partNames;

  bool get _isEditingExisting => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _clientCtrl = TextEditingController(text: e?.clientName ?? '');
    _nameCtrl = TextEditingController(text: e?.projectName ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _driveCtrl = TextEditingController(text: e?.driveLink ?? '');
    _partNames = e != null ? e.parts.map((p) => p.name).toList() : ['مطبخ'];
  }

  void _addPartField() {
    setState(() => _partNames.add(''));
  }

  void _removePart(int i) {
    setState(() => _partNames.removeAt(i));
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _clientCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم العميل واسم المشروع')),
      );
      return;
    }

    final data = AppData.instance;

    if (_isEditingExisting) {
      final project = widget.existing!;
      project.clientName = _clientCtrl.text.trim();
      project.projectName = _nameCtrl.text.trim();
      project.description = _descCtrl.text.trim();
      project.driveLink = _driveCtrl.text.trim();

      // Sync parts: keep existing ones matching by index/name, add new ones.
      final existingNames = project.parts.map((p) => p.name).toList();
      for (int i = 0; i < _partNames.length; i++) {
        final name = _partNames[i].trim();
        if (name.isEmpty) continue;
        if (i >= existingNames.length || existingNames[i] != name) {
          if (i >= project.parts.length) {
            project.parts.add(Part(
              id: 'pt_${DateTime.now().microsecondsSinceEpoch}_$i',
              name: name,
            ));
          }
        }
      }
    } else {
      final project = Project(
        id: 'p_${DateTime.now().microsecondsSinceEpoch}',
        clientName: _clientCtrl.text.trim(),
        projectName: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        driveLink: _driveCtrl.text.trim(),
        parts: _partNames
            .where((n) => n.trim().isNotEmpty)
            .toList()
            .asMap()
            .entries
            .map((e) => Part(
                  id: 'pt_${DateTime.now().microsecondsSinceEpoch}_${e.key}',
                  name: e.value.trim(),
                ))
            .toList(),
      );
      data.projects.insert(0, project);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BrandHeader(
            title: _isEditingExisting ? 'إضافة جزء' : 'مشروع جديد',
            showBack: true,
            height: 190,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('أدخل بيانات المشروع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 16)),
                  const SizedBox(height: 24),
                  _fieldLabel('اسم العميل', required: true),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _clientCtrl,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      suffixIcon:
                          Icon(Icons.person_outline, color: AppColors.maroon),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('اسم المشروع', required: true),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameCtrl,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.folder_open_outlined,
                          color: AppColors.maroon),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('وصف المشروع'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descCtrl,
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'اكتب وصف المشروع...',
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('رابط Google Drive'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _driveCtrl,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'أدخل رابط Google Drive هنا...',
                      suffixIcon: Icon(Icons.link, color: AppColors.maroon),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('الأجزاء',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_partNames.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _removePart(i),
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.danger),
                          ),
                          const Icon(Icons.drag_indicator,
                              color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller:
                                  TextEditingController(text: _partNames[i])
                                    ..selection = TextSelection.collapsed(
                                        offset: _partNames[i].length),
                              textAlign: TextAlign.right,
                              onChanged: (v) => _partNames[i] = v,
                              decoration: InputDecoration(
                                hintText: 'اسم الجزء',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  OutlinedButton.icon(
                    onPressed: _addPartField,
                    icon: const Icon(Icons.add, color: AppColors.gold),
                    label: const Text('إضافة جزء',
                        style: TextStyle(
                            color: AppColors.gold, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      side: const BorderSide(color: AppColors.gold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                        _isEditingExisting ? 'حفظ التعديلات' : 'إنشاء المشروع'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          children: [
            if (required)
              const TextSpan(
                  text: '* ',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.bold)),
            TextSpan(
                text: text,
                style: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
