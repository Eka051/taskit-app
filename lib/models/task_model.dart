import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String? attachmentUrl;
  final String? fileName;
  final String userId;

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
    this.attachmentUrl,
    this.fileName,
    required this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      dueDate:
          json['dueDate'] != null
              ? DateTime.parse(json['dueDate'] as String)
              : DateTime.now(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: json['priority'] as String?,
      category: json['category'] as String?,
      notes: json['notes'] as String?,
      reminder: json['reminder'] as String?,
      status: json['status'] as String?,
      createdAt:
          json['createdAt'] != null
              ? (json['createdAt'] is Timestamp
                  ? (json['createdAt'] as Timestamp).toDate()
                  : DateTime.parse(json['createdAt'] as String))
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? (json['updatedAt'] is Timestamp
                  ? (json['updatedAt'] as Timestamp).toDate()
                  : DateTime.parse(json['updatedAt'] as String))
              : null,
      attachment:
          json['attachment'] != null
              ? File(json['attachment'] as String)
              : null,
      attachmentUrl: json['attachmentUrl'] as String?,
      fileName: json['fileName'] as String?,
      userId: json['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority,
      'category': category,
      'notes': notes,
      'reminder': reminder,
      'status': status,
      'userId': userId,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      if (fileName != null) 'fileName': fileName,
    };
  }
}
