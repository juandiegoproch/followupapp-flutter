import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:followupapp/presentation/screens/tasks_view_screen.dart';
import 'package:followupapp/service/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance // handle init/close of app apparently
      .addObserver(AppLifecycleListener(onExitRequested: () async {
    await stopBackend();
    debugPrint("Backend stopped, exiting");
    return AppExitResponse.exit;
  }));
  startBackend();
  runApp(const FollowUpApp());
}

class FollowUpApp extends StatelessWidget {
  const FollowUpApp({super.key});

  @override
  build(context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
            primary: Colors.green,
            secondary: Colors.grey,
            brightness: Brightness.light,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Color.fromARGB(255, 244, 244, 244),
            onSurface: Colors.black),
        appBarTheme: const AppBarTheme(
            color: Colors.green, foregroundColor: Colors.green),
      ),
      routes: {
        '/': (context) => const TaskViewScreen(),
      },
      initialRoute: '/',
    );
  }
}
