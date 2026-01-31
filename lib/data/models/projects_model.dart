import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class Project {
  final int id;
  final String name;
  final String description;
  final int createdBy;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    // DateTime parsing with null safety
    DateTime parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) {
        return DateTime.now();
      }
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        print('Error parsing date $dateString: $e');
        return DateTime.now();
      }
    }

    return Project(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdBy: json['created_by'] as int? ?? 0,
      startDate: parseDate(json['start_date'] as String?),
      endDate: parseDate(json['end_date'] as String?),
      status: json['status'] as String? ?? 'planning',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: parseDate(json['created_at'] as String?),
      updatedAt: parseDate(json['updated_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_by': createdBy,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Request body for create/update
  Map<String, dynamic> toRequestJson() {
    return {
      'name': name,
      'description': description,
      'start_date':
          startDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'end_date': endDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
    };
  }

  // Copy with method
  Project copyWith({
    int? id,
    String? name,
    String? description,
    int? createdBy,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Empty project
  static Project empty() {
    final now = DateTime.now();
    return Project(
      id: 0,
      name: '',
      description: '',
      createdBy: 0,
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      status: 'planning',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Helper getters
  bool get isEmpty => id == 0;

  String get displayStatus {
    switch (status) {
      case 'planning':
        return 'Planning';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'on_hold':
        return 'On Hold';
      default:
        return 'Planning';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'planning':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'on_hold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get formattedStartDate =>
      '${startDate.day}/${startDate.month}/${startDate.year}';
  String get formattedEndDate =>
      '${endDate.day}/${endDate.month}/${endDate.year}';

  int get daysRemaining {
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  double get progressPercentage {
    final totalDays = endDate.difference(startDate).inDays;
    final daysPassed = DateTime.now().difference(startDate).inDays;

    if (totalDays <= 0 || daysPassed <= 0) return 0.0;
    if (daysPassed >= totalDays) return 100.0;

    return (daysPassed / totalDays * 100).clamp(0.0, 100.0);
  }
}

class ProjectResponse {
  final List<Project> data;
  final int count;

  ProjectResponse({
    required this.data,
    required this.count,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    // Check if data is null or not a list
    final dataList = json['data'];
    if (dataList == null || dataList is! List) {
      return ProjectResponse(
        data: [],
        count: json['count'] as int? ?? 0,
      );
    }

    return ProjectResponse(
      data: dataList
          .whereType<Map<String, dynamic>>()
          .map((item) => Project.fromJson(item))
          .toList(),
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'count': count,
    };
  }
}
