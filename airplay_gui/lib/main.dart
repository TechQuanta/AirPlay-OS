import 'package:flutter/material.dart';
// 1. Import the theme configuration file
import 'package:airplay_gui/core/themes/app_theme.dart'; 
// 2. Import the LoadingScreen class
import 'package:airplay_gui/main.dart'; 
import 'package:airplay_gui/features/loading/startloading.dart';

void main() {
  // Start the application with the root widget, conventionally named MyApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplay OS',
      
      // 3. Apply the Light Theme from AppTheme
      theme: AppTheme.lightTheme,
      
      // 4. Apply the Dark Theme from AppTheme
      darkTheme: AppTheme.darkTheme,
      
      // 5. Tell the MaterialApp to automatically switch between
      //    light and dark themes based on the system setting.
      themeMode: ThemeMode.system, 
      
      // The application starts on the LoadingScreen
      home: const LoadingScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}
