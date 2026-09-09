import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Role of the logged-in user, matches the 3 login tabs in the mockups.
enum UserRole { manager, engineer, designer }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.manager:
        return 'مدير';
      case UserRole.engineer:
        return 'مهندس';
      case UserRole.designer:
        return 'مصمم';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.manager:
        return Icons.business_center_outlined;
      case UserRole.engineer:
        return Icons.engineering_outlined;
      case UserRole.designer:
        return Icons.edit_outlined;
    }
  }
}

/// Design stage of a part: لم يبدأ -> قيد التصميم -> مكتمل
enum DesignStatus { notStarted, inProgress, completed }

extension DesignStatusX on DesignStatus {
  String get label {
    switch (this) {
      case DesignStatus.notStarted:
        return 'لم يبدأ';
      case DesignStatus.inProgress:
        return 'قيد التصميم';
      case DesignStatus.completed:
        return 'مكتمل';
    }
  }

  Color get color {
    switch (this) {
      case DesignStatus.notStarted:
        return AppColors.grey;
      case DesignStatus.inProgress:
        return AppColors.maroon;
      case DesignStatus.completed:
        return AppColors.success;
    }
  }

  Color get bgColor {
    switch (this) {
      case DesignStatus.notStarted:
        return AppColors.greyBg;
      case DesignStatus.inProgress:
        return AppColors.maroon.withValues(alpha: 0.08);
      case DesignStatus.completed:
        return AppColors.successBg;
    }
  }
}

/// CNC execution stage of a part.
enum CncStatus { waiting, inProgress, completed, delivered }

extension CncStatusX on CncStatus {
  String get label {
    switch (this) {
      case CncStatus.waiting:
        return 'انتظار';
      case CncStatus.inProgress:
        return 'قيد التنفيذ';
      case CncStatus.completed:
        return 'مكتمل';
      case CncStatus.delivered:
        return 'تم التسليم';
    }
  }

  Color get color {
    switch (this) {
      case CncStatus.waiting:
        return AppColors.warning;
      case CncStatus.inProgress:
        return AppColors.maroon;
      case CncStatus.completed:
        return AppColors.gold;
      case CncStatus.delivered:
        return AppColors.success;
    }
  }

  int get step {
    switch (this) {
      case CncStatus.waiting:
        return 1;
      case CncStatus.inProgress:
        return 2;
      case CncStatus.completed:
        return 3;
      case CncStatus.delivered:
        return 4;
    }
  }
}

class NoteEntry {
  final String author;
  final String text;
  final DateTime time;
  NoteEntry({required this.author, required this.text, required this.time});
}

class MissingDataItem {
  final String author;
  final String text;
  final DateTime time;

  MissingDataItem({
    required this.author,
    required this.text,
    required this.time,
  });
}

class Part {
  String id;
  String name;
  String description;
  DesignStatus designStatus;
  CncStatus cncStatus;
  String driveLink;
  List<MissingDataItem> missingData;
  List<NoteEntry> notes;

  Part({
    required this.id,
    required this.name,
    this.description = '',
    this.designStatus = DesignStatus.notStarted,
    this.cncStatus = CncStatus.waiting,
    this.driveLink = '',
    List<MissingDataItem>? missingData,
    List<NoteEntry>? notes,
  })  : missingData = missingData ?? [],
        notes = notes ?? [];
}

class Project {
  String id;
  String clientName;
  String projectName;
  String description;
  String driveLink;
  DateTime createdAt;
  List<Part> parts;

  Project({
    required this.id,
    required this.clientName,
    required this.projectName,
    this.description = '',
    this.driveLink = '',
    DateTime? createdAt,
    List<Part>? parts,
  })  : createdAt = createdAt ?? DateTime.now(),
        parts = parts ?? [];

  int get completedCount =>
      parts.where((p) => p.designStatus == DesignStatus.completed).length;

  double get progress => parts.isEmpty ? 0 : completedCount / parts.length;

  /// Overall status label shown on project cards (لم يبدأ / قيد التصميم / مكتمل)
  String get overallStatusLabel {
    if (parts.isEmpty) return 'لم يبدأ';
    if (parts.every((p) => p.designStatus == DesignStatus.completed)) {
      return 'مكتمل';
    }
    if (parts.any((p) => p.designStatus == DesignStatus.inProgress)) {
      return 'قيد التصميم';
    }
    return 'لم يبدأ';
  }
}
