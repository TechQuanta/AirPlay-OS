import 'package:flutter/material.dart';
// 1. Import the theme configuration file
import 'package:airplay_gui/core/themes/app_theme.dart'; 
// 4. Import the LoadingScreen class
import 'package:airplay_gui/features/loading/startloading.dart';

void main() {
  // Start the application with the root widget, conventionally named MyApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: This setup relies on AppTheme.lightTheme and AppTheme.darkTheme being defined.
    // It also relies on the LoadingScreen widget existing and handling navigation 
    // to either ApiSettingsScreen or HomeScreen after its initialization logic.
    return MaterialApp(
      title: 'Airplay OS',
      
      // 3. Apply the Light Theme from AppTheme
      // Note: Assuming AppTheme is correctly implemented in core/themes/app_theme.dart
      theme: AppTheme.lightTheme, 
      
      // 4. Apply the Dark Theme from AppTheme
      darkTheme: AppTheme.darkTheme,
      
      // 5. Tell the MaterialApp to automatically switch between
      //    light and dark themes based on the system setting.
      themeMode: ThemeMode.system, 
      
      // The application starts on the LoadingScreen. 
      // It is assumed the LoadingScreen will navigate to the HomeScreen when ready.
      home: const LoadingScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}