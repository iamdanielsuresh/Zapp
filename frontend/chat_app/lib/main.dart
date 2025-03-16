import 'package:chat_app/components/message_model.dart';
import 'package:chat_app/screens/ChatScreen.dart';
import 'package:chat_app/screens/MessageScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/SettingScreen.dart';
import 'package:chat_app/screens/SplashScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/screens/ContactScreen.dart';
import 'package:chat_app/screens/NameScreen.dart';
import 'package:chat_app/screens/OtpScreen.dart';
import 'package:chat_app/screens/PhoneScreen.dart';
import 'package:chat_app/components/DarkLightMode.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
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
      initialRoute: '/messages',
      routes: {
        '/': (context) => SplashScreen(),
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
        '/messages': (context) => MessagesScreen(userId: '14',), // New MessagesScreen route
      },
    );
  }
}
