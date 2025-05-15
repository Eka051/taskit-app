import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/firebase_options.dart';
import 'package:taskit_app/providers/auth_provider.dart';
import 'package:taskit_app/providers/login_provider.dart';
import 'package:taskit_app/utils/const.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:taskit_app/views/auth/login_view.dart';
import 'package:taskit_app/views/home/home_view.dart';
import 'package:taskit_app/views/splashscreen/splashscreen_view.dart';
import 'package:taskit_app/views/tasks/add_task_view.dart';

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
      ),
    );
  }
}
