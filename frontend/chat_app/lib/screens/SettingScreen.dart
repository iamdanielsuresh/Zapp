import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(bool) onThemeChanged;

  SettingsScreen({required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: SwitchListTile(
          title: Text('Dark Mode'),
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (bool value) {
            onThemeChanged(value);
          },
        ),
      ),
    );
  }
}
