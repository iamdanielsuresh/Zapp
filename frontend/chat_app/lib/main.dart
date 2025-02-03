import 'package:flutter/material.dart';
import 'package:chat_app/screens/SettingScreen.dart';
import 'package:chat_app/screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/screens/ContactScreen.dart';
import 'package:chat_app/screens/NameScreen.dart';
import 'package:chat_app/screens/OtpScreen.dart';
import 'package:chat_app/screens/PhoneScreen.dart';
import 'package:chat_app/components/DarkLightMode.dart'; 
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget 
{
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark; // Default theme is dark

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load saved theme preference using DarkLightMode utility
  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? true; // Default to dark mode
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Save theme preference using DarkLightMode utility
  _saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: lightTheme,  // Using lightTheme from DarkLightMode.dart
      darkTheme: darkTheme,  // Using darkTheme from DarkLightMode.dart
      themeMode: _themeMode,  // Set theme mode based on user preference
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/Name': (context) => NameScreen(),
        '/phone': (context) => PhoneScreen(),
        '/otp': (context) => OtpScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/settings': (context) => SettingsScreen(
          onThemeChanged: (bool isDarkMode) {
            setState(() {
              _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
              _saveTheme(isDarkMode);
            });
          },
        ),
      },
    );
  }
}
