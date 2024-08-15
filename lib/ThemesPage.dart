import 'package:Talks/services/Themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.themeData == ThemeData.dark();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Talks Themes',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Light Theme'),
            leading: Radio<bool>(
              value: false,
              groupValue: isDarkTheme,
              onChanged: (bool? value) {
                if (value != null) {
                  themeProvider.setTheme(ThemeData.light());
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Dark Theme'),
            leading: Radio<bool>(
              value: true,
              groupValue: isDarkTheme,
              onChanged: (bool? value) {
                if (value != null) {
                  themeProvider.setTheme(ThemeData.dark());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
