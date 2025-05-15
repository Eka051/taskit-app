import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/providers/auth_provider.dart';
import 'package:taskit_app/providers/home_provider.dart';
import 'package:taskit_app/providers/login_provider.dart';
import 'package:taskit_app/providers/task_provider.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks(context);
    });
  }

  Future<void> _refreshTasks() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.refreshTasks(context, taskProvider);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.of(context).colors.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshTasks,
            color: AppTheme.of(context).colors.primary,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
                decelerationRate: ScrollDecelerationRate.normal,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Builder(
                          builder: (_) {
                            final pic =
                                Provider.of<AppAuthProvider>(
                                  context,
                                ).profilePictureUrl;
                            return CircleAvatar(
                              backgroundColor:
                                  AppTheme.of(context).colors.primary,
                              radius: 25,
                              backgroundImage:
                                  pic != null && pic.startsWith('http')
                                      ? NetworkImage(pic)
                                      : null,
                              child:
                                  (pic != null && pic.length == 1)
                                      ? Text(
                                        pic,
                                        style: AppTheme.of(
                                          context,
                                        ).textStyle.titleMedium.copyWith(
                                          color:
                                              AppTheme.of(
                                                context,
                                              ).colors.onSecondary,
                                        ),
                                      )
                                      : null,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            text: 'Halo, \n',
                            style: AppTheme.of(
                              context,
                            ).textStyle.bodyMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: authProvider.user?.displayName ?? 'User',
                                style: AppTheme.of(
                                  context,
                                ).textStyle.titleLarge.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            loginProvider.logout(context);
                          },
                          icon: Icon(Icons.logout_outlined, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.of(context).colors.primary,
                            AppTheme.of(context).colors.gradient,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.of(
                              context,
                            ).colors.primary.withAlpha(40),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Image.asset('assets/images/object-3.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Manage your tasks',
                                        style: AppTheme.of(
                                          context,
                                        ).textStyle.headlineLarge.copyWith(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 210,
                                        child: Text(
                                          'With Taskit, you can easily manage your tasks and stay organized.',
                                          style: AppTheme.of(
                                            context,
                                          ).textStyle.titleSmall.copyWith(
                                            color: Colors.white.withAlpha(180),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed:
                              () => homeProvider.navigateToAddTask(context),
                          label: Text(
                            'Add Task',
                            style: AppTheme.of(
                              context,
                            ).textStyle.bodyLarge.copyWith(
                              color: AppTheme.of(context).colors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: Icon(
                            Icons.add_circle_outline_outlined,
                            size: 30,
                            color: AppTheme.of(context).colors.primary,
                          ),
                          iconAlignment: IconAlignment.end,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Consumer<TaskProvider>(
                      builder: (context, taskProvider, _) {
                        if (taskProvider.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (taskProvider.tasks.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/no-tasks.png',
                                    height: 150,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No tasks available',
                                    style:
                                        AppTheme.of(
                                          context,
                                        ).textStyle.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Create your first task by tapping the + button above',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTheme.of(
                                          context,
                                        ).textStyle.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              taskProvider.tasks.map((task) {
                                return Card(
                                  color: AppTheme.of(context).colors.background,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(
                                      color: AppTheme.of(
                                        context,
                                      ).colors.primary.withAlpha(120),
                                      width: 1,
                                    ),
                                  ),
                                  shadowColor: AppTheme.of(
                                    context,
                                  ).colors.primary.withAlpha(50),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap:
                                        () => homeProvider.navigateToTaskDetail(
                                          context,
                                          task.id,
                                        ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 18,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: homeProvider
                                                  .getPriorityColor(
                                                    task.priority,
                                                    context,
                                                  )
                                                  .withAlpha(50),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.task_alt_rounded,
                                              color: homeProvider
                                                  .getPriorityColor(
                                                    task.priority,
                                                    context,
                                                  ),
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: AppTheme.of(context)
                                                      .textStyle
                                                      .titleMedium
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        decoration:
                                                            task.isCompleted
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  task.description.isNotEmpty
                                                      ? task.description
                                                      : 'No description',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTheme.of(context)
                                                      .textStyle
                                                      .bodyMedium
                                                      .copyWith(
                                                        color:
                                                            AppTheme.of(
                                                              context,
                                                            ).colors.tertiary,
                                                        fontSize: 14,
                                                        decoration:
                                                            task.isCompleted
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                      ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Due: ${DateFormat('dd/MM/yyyy, HH:mm').format(task.dueDate)}',
                                                  style: AppTheme.of(
                                                    context,
                                                  ).textStyle.bodySmall.copyWith(
                                                    color:
                                                        homeProvider.isOverdue(
                                                                  task.dueDate,
                                                                ) &&
                                                                !task
                                                                    .isCompleted
                                                            ? AppTheme.of(
                                                              context,
                                                            ).colors.error
                                                            : AppTheme.of(
                                                              context,
                                                            ).colors.tertiary,
                                                    fontWeight:
                                                        homeProvider.isOverdue(
                                                                  task.dueDate,
                                                                ) &&
                                                                !task
                                                                    .isCompleted
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              taskProvider.toggleTaskCompletion(
                                                task.id,
                                                !task.isCompleted,
                                                context,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    task.isCompleted
                                                        ? AppTheme.of(context)
                                                            .colors
                                                            .green
                                                            .withAlpha(50)
                                                        : AppTheme.of(context)
                                                            .colors
                                                            .grey
                                                            .withAlpha(50),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(
                                                task.isCompleted
                                                    ? Icons.check_circle_rounded
                                                    : Icons.circle_outlined,
                                                color:
                                                    task.isCompleted
                                                        ? AppTheme.of(
                                                          context,
                                                        ).colors.green
                                                        : AppTheme.of(
                                                          context,
                                                        ).colors.grey,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
