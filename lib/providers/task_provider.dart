import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:taskit_app/widgets/dialog_app.dart';

class TaskProvider with ChangeNotifier {
  final CollectionReference _taskCollection = FirebaseFirestore.instance
      .collection('tasks');
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> get tasks => _tasks;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaskProvider() {
    _fetchTasks();
  }

  Future<void> _fetchTasks([BuildContext? context]) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await _taskCollection.get();
      _tasks =
          snapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Map<String, dynamic> task, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _taskCollection.add(task);
      await _fetchTasks();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(String id, Map<String, dynamic> task, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _taskCollection.doc(id).update(task);
      await _fetchTasks();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _taskCollection.doc(id).delete();
      await _fetchTasks();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeTask(String id, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _taskCollection.doc(id).update({'completed': true});
      await _fetchTasks();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uncompleteTask(String id, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _taskCollection.doc(id).update({'completed': false});
      await _fetchTasks();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadFile(String id, String filePath, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = filePath.split('/').last;
      final taskRef = storageRef.child('tasks/$id/$fileName');

      final uploadTask = await taskRef.putFile(
        File(filePath),
        SettableMetadata(contentType: _getContentType(fileName)),
      );

      final fileUrl = await uploadTask.ref.getDownloadURL();

      await _taskCollection.doc(id).update({
        'fileUrl': fileUrl,
        'fileName': fileName,
      });

      await _fetchTasks();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _getContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return null;
    }
  }
}
