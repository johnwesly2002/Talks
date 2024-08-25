import 'package:Talks/services/Themeprovider.dart';
import 'package:Talks/utils/textFeilds_styles.dart';
import 'package:Talks/widgets/ThemechangeWIdget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.themeData == ThemeData.dark();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Talks Themes',
          style: ThemTextStyles.HeadingStyles(context),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LightThemeSkeleton(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: isDarkTheme,
                      onChanged: (bool? value) {
                        if (value != null) {
                          themeProvider.setTheme(ThemeData.light());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DarkThemeSkeleton(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isDarkTheme,
                      onChanged: (bool? value) {
                        if (value != null) {
                          themeProvider.setTheme(ThemeData.dark());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
