import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:taskit_app/models/task_model.dart';
import 'package:taskit_app/widgets/dialog_app.dart';

class TaskProvider with ChangeNotifier {
  final CollectionReference _taskCollection = FirebaseFirestore.instance
      .collection('tasks');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _currentTaskId;
  String? get currentTaskId => _currentTaskId;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;
  String priority = 'Medium';
  File? selectedFile;
  String? selectedFileName;
  String? fileUrl;
  bool isCompleted = false;

  final List<String> priorities = ['Low', 'Medium', 'High'];

  TaskProvider() {
    fetchTasks();
  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    selectedDate = null;
    priority = 'Medium';
    selectedFile = null;
    selectedFileName = null;
    fileUrl = null;
    isCompleted = false;
    _currentTaskId = null;
  }

  void setEditData(TaskModel task) {
    _currentTaskId = task.id;
    descriptionController.text = task.description;
    titleController.text = task.title;
    selectedDate = task.dueDate;
    priority = task.priority ?? 'Medium';
    isCompleted = task.isCompleted;
    fileUrl = task.attachment?.path;
    if (task.attachment != null) {
      selectedFileName = path.basename(task.attachment!.path);
    }
    notifyListeners();
  }

  Future<void> fetchTasks([BuildContext? context]) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        _tasks = [];
        return;
      }

      QuerySnapshot snapshot =
          await _taskCollection
              .where('userId', isEqualTo: userId)
              .orderBy('dueDate', descending: false)
              .get();

      _tasks =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TaskModel.fromJson({'id': doc.id, ...data});
          }).toList();
    } catch (e) {
      if (context != null && context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveTask(BuildContext context) async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      String? attachmentUrl;

      if (selectedFile != null) {
        final fileName = path.basename(selectedFile!.path);
        final fileRef = _storage.ref().child(
          'tasks/$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName',
        );

        await fileRef.putFile(
          selectedFile!,
          SettableMetadata(contentType: _getContentType(fileName)),
        );

        attachmentUrl = await fileRef.getDownloadURL();
      }

      final taskData = {
        'userId': userId,
        'title': titleController.text,
        'description': descriptionController.text,
        'dueDate':
            selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'isCompleted': isCompleted,
        'priority': priority,
        'createdAt':
            _currentTaskId == null ? FieldValue.serverTimestamp() : null,
        'updatedAt': FieldValue.serverTimestamp(),
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        if (selectedFileName != null) 'fileName': selectedFileName,
      };

      taskData.removeWhere((key, value) => value == null);

      if (_currentTaskId == null) {
        await _taskCollection.add(taskData);
      } else {
        await _taskCollection.doc(_currentTaskId).update(taskData);
      }

      await fetchTasks(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _currentTaskId == null
                  ? 'Task added successfully'
                  : 'Task updated successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      resetForm();
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(
    String id,
    bool completed,
    BuildContext? context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _taskCollection.doc(id).update({'isCompleted': completed});
      await fetchTasks(context);
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
    if (context == null || !context.mounted) return;

    bool confirmDelete = false;
    await AppDialog.showConfirmationDialog(
      context: context,
      title: 'Delete Task',
      message:
          'Are you sure you want to delete this task? This action cannot be undone.',
      onConfirm: () {
        confirmDelete = true;
        Navigator.of(context).pop();
      },
      onCancel: () {
        confirmDelete = false;
        Navigator.of(context).pop();
      },
    );

    AppDialog.showSuccessDialog(
      context: context,
      message: 'Task deleted successfully',
    );

    if (!confirmDelete) return;

    _isLoading = true;
    notifyListeners();

    try {
      final taskDoc = await _taskCollection.doc(id).get();
      final data = taskDoc.data() as Map<String, dynamic>?;

      if (data != null && data['attachmentUrl'] != null) {
        try {
          final ref = _storage.refFromURL(data['attachmentUrl'].toString());
          await ref.delete();
        } catch (e) {
          if (context.mounted) {
            AppDialog.showErrorDialog(
              context: context,
              message: 'Error deleting file: ${e.toString()}',
            );
          }
        }
      }

      await _taskCollection.doc(id).delete();
      if (context.mounted) {
        AppDialog.showSuccessDialog(
          context: context,
          message: 'Task deleted successfully',
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
      await fetchTasks(context);
    } catch (e) {
      if (context.mounted) {
        AppDialog.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickFile(BuildContext context) async {
    try {
      final choice = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select File Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Image'),
                  onTap: () => Navigator.pop(context, 'image'),
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Document'),
                  onTap: () => Navigator.pop(context, 'document'),
                ),
              ],
            ),
          );
        },
      );

      if (choice == null) return;

      if (choice == 'image') {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          selectedFile = File(image.path);
          selectedFileName = path.basename(image.path);
          notifyListeners();
        }
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'doc',
            'docx',
            'txt',
            'jpg',
            'jpeg',
            'png',
          ],
        );

        if (result != null) {
          selectedFile = File(result.files.single.path!);
          selectedFileName = result.files.single.name;
          notifyListeners();
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppDialog.showErrorDialog(
          context: context,
          message: 'Error picking file: ${e.toString()}',
        );
      }
    }
  }

  // Navigation methods
  void navigateToTaskDetail(BuildContext context, String taskId) {
    Navigator.pushNamed(context, '/task-detail', arguments: taskId);
  }

  void navigateToAddTask(BuildContext context) {
    Navigator.pushNamed(context, '/add-task');
  }

  void navigateToEditTask(BuildContext context, String taskId) {
    Navigator.pushNamed(context, '/edit-task', arguments: taskId).then((_) {
      // Refresh tasks when returning from edit screen
      fetchTasks(context);
    });
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  // UI helper methods
  Color getPriorityColor(String? priority, BuildContext context) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  bool isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
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
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'txt':
        return 'text/plain';
      default:
        return null;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
