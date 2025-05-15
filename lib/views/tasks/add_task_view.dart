import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/providers/task_provider.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:taskit_app/widgets/back_button.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  late TaskProvider _taskProvider;

  @override
  void initState() {
    super.initState();
    _taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _taskProvider.resetForm();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _taskProvider.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.of(context).colors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                color: AppTheme.of(context).colors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.of(context).colors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.of(context).colors.primary,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              textTheme: TextTheme(
                headlineMedium: TextStyle(
                  color: AppTheme.of(context).colors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null && context.mounted) {
        setState(() {
          _taskProvider.selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      } else if (picked != _taskProvider.selectedDate && context.mounted) {
        setState(() {
          _taskProvider.selectedDate = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppTheme.of(context).colors.background,
          appBar: AppBar(
            title: Text(
              'Create Task',
              style: AppTheme.of(context).textStyle.titleLarge,
            ),
            elevation: 0,
            centerTitle: true,
            leading: AppBackButton(
              iconColor: AppTheme.of(context).colors.primary,
              onPressed: () => Navigator.pop(context),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: AppTheme.of(context).colors.grey.withAlpha(100),
                height: 1.0,
              ),
            ),
          ),
          body: Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.of(context).colors.primary,
                              AppTheme.of(context).colors.gradient,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(40),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Task',
                              style: AppTheme.of(
                                context,
                              ).textStyle.heading2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add details for your new task',
                              style: AppTheme.of(context).textStyle.bodyMedium
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Task Title',
                        style: AppTheme.of(context).textStyle.titleMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: taskProvider.titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.title_outlined,
                            color: AppTheme.of(context).colors.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(200),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(200),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.of(context).colors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: AppTheme.of(context).textStyle.titleMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: taskProvider.descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter task description',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Icon(
                              Icons.description_outlined,
                              color: AppTheme.of(context).colors.primary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(150),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(150),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.of(context).colors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Due Date',
                        style: AppTheme.of(context).textStyle.titleMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(100),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.of(context).colors.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                taskProvider.selectedDate == null
                                    ? 'Select date'
                                    : '${taskProvider.selectedDate!.day} - ${taskProvider.selectedDate!.month} - ${taskProvider.selectedDate!.year}, ${taskProvider.selectedDate!.hour}:${taskProvider.selectedDate!.minute.toString().padLeft(2, '0')}',
                                style: AppTheme.of(context).textStyle.bodyLarge,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.of(context).colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Upload File',
                        style: AppTheme.of(context).textStyle.titleMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => taskProvider.pickFile(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.of(
                                context,
                              ).colors.primary.withAlpha(100),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_file_outlined,
                                color: AppTheme.of(context).colors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  taskProvider.selectedFileName ??
                                      'Select file',
                                  style:
                                      AppTheme.of(context).textStyle.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (taskProvider.selectedFileName != null)
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: AppTheme.of(context).colors.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      taskProvider.selectedFile = null;
                                      taskProvider.selectedFileName = null;
                                    });
                                  },
                                )
                              else
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppTheme.of(context).colors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Priority',
                        style: AppTheme.of(context).textStyle.titleMedium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.of(
                              context,
                            ).colors.primary.withAlpha(100),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: taskProvider.priority,
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppTheme.of(context).colors.primary,
                            ),
                            items:
                                taskProvider.priorities.map((String priority) {
                                  return DropdownMenuItem<String>(
                                    value: priority,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.flag_outlined,
                                          color:
                                              priority == 'High'
                                                  ? Colors.red
                                                  : priority == 'Medium'
                                                  ? Colors.orange
                                                  : Colors.green,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(priority),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  taskProvider.priority = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                              taskProvider.isLoading
                                  ? null
                                  : () async {
                                    final success = await taskProvider.saveTask(
                                      context,
                                    );
                                    if (success && mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.of(context).colors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child:
                              taskProvider.isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    'Create Task',
                                    style: AppTheme.of(
                                      context,
                                    ).textStyle.bodyLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppTheme.of(context).colors.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTheme.of(
                              context,
                            ).textStyle.bodyLarge.copyWith(
                              color: AppTheme.of(context).colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
