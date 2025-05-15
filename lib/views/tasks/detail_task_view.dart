import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/models/task_model.dart';
import 'package:taskit_app/providers/task_provider.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:taskit_app/widgets/back_button.dart';
import 'package:taskit_app/widgets/dialog_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class DetailTaskView extends StatefulWidget {
  final String? taskId;
  const DetailTaskView({super.key, this.taskId});

  @override
  State<DetailTaskView> createState() => _DetailTaskViewState();
}

class _DetailTaskViewState extends State<DetailTaskView> {
  TaskModel? task;
  bool isLoading = true;
  String? taskId;
  late TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
    taskProvider = Provider.of<TaskProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.taskId == null) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args != null && args is String) {
          taskId = args;
        }
      } else {
        taskId = widget.taskId;
      }
      _loadTask();
    });
  }

  Future<void> _loadTask() async {
    if (taskId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      task = taskProvider.getTaskById(taskId!);

      if (task == null) {
        await taskProvider.fetchTasks(context);
        task = taskProvider.getTaskById(taskId!);
      }
    } catch (e) {
      if (context.mounted) {
        AppDialog.showErrorDialog(
          context: context,
          message: 'Error loading task: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _openAttachment() async {
    if (task?.attachmentUrl == null) return;

    try {
      final Uri url = Uri.parse(task!.attachmentUrl!);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${task!.attachmentUrl}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isLoading && mounted) {
        _loadTask();
      }
    });
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.of(context).colors.background,
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : (task == null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: AppTheme.of(context).colors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Task not found',
                            style: AppTheme.of(context).textStyle.titleLarge,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Go Back'),
                          ),
                        ],
                      ),
                    )
                    : CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 200.0,
                          floating: false,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: AppTheme.of(context).colors.primary,
                          leading: AppBackButton(
                            iconColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.of(context).colors.primary,
                                    AppTheme.of(context).colors.gradient,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                (task!.priority == 'High')
                                                    ? AppTheme.of(
                                                      context,
                                                    ).colors.error
                                                    : (task!.priority ==
                                                        'Medium')
                                                    ? AppTheme.of(
                                                      context,
                                                    ).colors.tertiary
                                                    : AppTheme.of(
                                                      context,
                                                    ).colors.green,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.flag,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                task!.priority ?? 'Medium',
                                                style: AppTheme.of(context)
                                                    .textStyle
                                                    .labelMedium
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        CircleAvatar(
                                          backgroundColor: Colors.white
                                              .withAlpha(100),
                                          radius: 20,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed:
                                                () => taskProvider
                                                    .navigateToEditTask(
                                                      context,
                                                      task!.id,
                                                    ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      task!.title,
                                      style: AppTheme.of(
                                        context,
                                      ).textStyle.headlineMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoCard(
                                  context,
                                  Icons.calendar_today,
                                  "Due Date",
                                  DateFormat(
                                    'dd/MM/yyyy, HH:mm',
                                  ).format(task!.dueDate),
                                  AppTheme.of(context).colors.tertiary,
                                ),
                                const SizedBox(height: 16),
                                _buildInfoCard(
                                  context,
                                  Icons.check_circle_outline,
                                  "Status",
                                  task!.isCompleted ? "Completed" : "Pending",
                                  task!.isCompleted
                                      ? AppTheme.of(context).colors.green
                                      : AppTheme.of(context).colors.secondary,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Description",
                                  style: AppTheme.of(context)
                                      .textStyle
                                      .titleLarge
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(30),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    task!.description.isEmpty
                                        ? "No description provided"
                                        : task!.description,
                                    style:
                                        AppTheme.of(
                                          context,
                                        ).textStyle.bodyLarge,
                                  ),
                                ),

                                if (task!.attachmentUrl != null) ...[
                                  const SizedBox(height: 24),
                                  Text(
                                    "Attachment",
                                    style: AppTheme.of(context)
                                        .textStyle
                                        .titleLarge
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: _openAttachment,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(10),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppTheme.of(
                                                context,
                                              ).colors.primary.withAlpha(10),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.attach_file,
                                              color:
                                                  AppTheme.of(
                                                    context,
                                                  ).colors.primary,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Attachment",
                                                  style: AppTheme.of(
                                                    context,
                                                  ).textStyle.bodySmall.copyWith(
                                                    color:
                                                        AppTheme.of(context)
                                                            .colors
                                                            .secondaryTextColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  task!.fileName ??
                                                      "View Attachment",
                                                  style: AppTheme.of(context)
                                                      .textStyle
                                                      .titleMedium
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppTheme.of(
                                                              context,
                                                            ).colors.primary,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.open_in_new,
                                            color:
                                                AppTheme.of(
                                                  context,
                                                ).colors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 30),
                                Consumer<TaskProvider>(
                                  builder: (context, provider, _) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed:
                                                provider.isLoading
                                                    ? null
                                                    : () {
                                                      provider
                                                          .toggleTaskCompletion(
                                                            task!.id,
                                                            !task!.isCompleted,
                                                            context,
                                                          )
                                                          .then(
                                                            (_) => _loadTask(),
                                                          );
                                                    },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  task!.isCompleted
                                                      ? AppTheme.of(
                                                        context,
                                                      ).colors.grey
                                                      : AppTheme.of(
                                                        context,
                                                      ).colors.green,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child:
                                                provider.isLoading
                                                    ? const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                    )
                                                    : Text(
                                                      task!.isCompleted
                                                          ? "Reopen Task"
                                                          : "Complete Task",
                                                      style: AppTheme.of(
                                                            context,
                                                          ).textStyle.buttonText
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                    ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Consumer<TaskProvider>(
                                  builder: (context, provider, _) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed:
                                                provider.isLoading
                                                    ? null
                                                    : () => provider
                                                        .deleteTask(
                                                          task!.id,
                                                          context,
                                                        ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color:
                                                    AppTheme.of(
                                                      context,
                                                    ).colors.error,
                                              ),
                                              foregroundColor:
                                                  AppTheme.of(
                                                    context,
                                                  ).colors.error,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color:
                                                      AppTheme.of(
                                                        context,
                                                      ).colors.error,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Delete Task",
                                                  style: AppTheme.of(context)
                                                      .textStyle
                                                      .buttonText
                                                      .copyWith(
                                                        color:
                                                            AppTheme.of(
                                                              context,
                                                            ).colors.error,
                                                        fontSize: 16,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.of(context).textStyle.bodySmall.copyWith(
                  color: AppTheme.of(context).colors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.of(
                  context,
                ).textStyle.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
