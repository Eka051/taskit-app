import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/firebase_options.dart';
import 'package:taskit_app/providers/auth_provider.dart';
import 'package:taskit_app/providers/home_provider.dart';
import 'package:taskit_app/providers/login_provider.dart';
import 'package:taskit_app/providers/task_provider.dart';
import 'package:taskit_app/utils/const.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:taskit_app/views/auth/login_view.dart';
import 'package:taskit_app/views/home/home_view.dart';
import 'package:taskit_app/views/splashscreen/splashscreen_view.dart';
import 'package:taskit_app/views/tasks/add_task_view.dart';
import 'package:taskit_app/views/tasks/detail_task_view.dart';
import 'package:taskit_app/views/tasks/edit_task_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TaskitApp());
}

class TaskitApp extends StatelessWidget {
  const TaskitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: AppTheme.createTextTheme(ThemeData.light().textTheme),
          colorScheme: AppTheme.createThemeData(context).colorScheme,
        ),
        home: const SplashscreenView(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.login: (context) => const LoginView(),
          AppRoutes.home: (context) => const HomeView(),
          AppRoutes.addTask: (context) => const AddTaskView(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.taskDetails) {
            final taskId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => DetailTaskView(taskId: taskId),
            );
          } else if (settings.name == AppRoutes.editTask) {
            final taskId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => EditTaskView(taskId: taskId),
            );
          }
          return null;
        },
      ),
    );
  }
}
