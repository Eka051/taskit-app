import 'dart:io';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String? priority;
  final String? category;
  final String? notes;
  final String? reminder;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final File? attachment;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.priority,
    this.category,
    this.notes,
    this.reminder,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.attachment,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: json['priority'] as String?,
      category: json['category'] as String?,
      notes: json['notes'] as String?,
      reminder: json['reminder'] as String?,
      status: json['status'] as String?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      attachment:
          json['attachment'] != null
              ? File(json['attachment'] as String)
              : null,
    );
  }
}
