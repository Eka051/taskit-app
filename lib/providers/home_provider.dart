import 'package:flutter/material.dart';
import 'package:taskit_app/providers/task_provider.dart';

class HomeProvider with ChangeNotifier {
  Future<void> refreshTasks(
    BuildContext context,
    TaskProvider taskProvider,
  ) async {
    await taskProvider.fetchTasks(context);
  }

  Color getPriorityColor(String? priority, BuildContext context) {
    return TaskProvider().getPriorityColor(priority, context);
  }

  bool isOverdue(DateTime dueDate) {
    return TaskProvider().isOverdue(dueDate);
  }

  void navigateToTaskDetail(BuildContext context, String taskId) {
    TaskProvider().navigateToTaskDetail(context, taskId);
  }

  void navigateToAddTask(BuildContext context) {
    TaskProvider().navigateToAddTask(context);
  }
}
