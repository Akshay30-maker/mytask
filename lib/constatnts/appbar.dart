import 'package:flutter/material.dart';
import '../screens/helper/theme_provider.dart';
import '../screens/homescreen.dart';
import 'color_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

PreferredSizeWidget commonAppBar(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  return AppBar(
    backgroundColor: themeProvider.isDarkMode ? DarkPrimaryColor : LightPrimaryColor,
    title: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: const Text(
        'NewsFlash',
        style: TextStyle(
          fontFamily: 'Nunito-ExtraBold',
          fontSize: 20,
        ),
      ),
    ),
    titleSpacing: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.settings,size: 30,),
        onPressed: () {
          _showSettingsDialog(context);
        },
      ),
    ],
  );
}

void _showSettingsDialog(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  bool light = !themeProvider.isDarkMode;
  String language = 'en';

  // Load saved settings
  SharedPreferences.getInstance().then((prefs) {
    light = !(prefs.getBool('isDarkMode') ?? false);
    language = prefs.getString('language') ?? 'en';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Nunito-SemiBold',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Use Dark Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito-SemiBold',
                  ),
                ),
                trailing: Switch(
                  value: !light,
                  activeColor: themeProvider.isDarkMode ? DarkPrimaryColor : LightPrimaryColor,
                  onChanged: (bool value) {
                    _saveTheme(context, !value);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito-SemiBold',
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(language.toUpperCase()),
                ),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog before showing another
                  _showLanguageDialog(context);
                },
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  });
}

void _saveTheme(BuildContext context, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', !value);
  Provider.of<ThemeProvider>(context, listen: false).toggleTheme(!value);
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Select Language',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Nunito-SemiBold',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'English',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Nunito-Medium',
                ),
              ),
              onTap: () {
                _saveLanguage(context, 'en');
                Navigator.of(context).pop(); // Close the settings dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Spanish',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Nunito-Medium',
                ),
              ),
              onTap: () {
                _saveLanguage(context, 'es');
                Navigator.of(context).pop(); // Close the settings dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void _saveLanguage(BuildContext context, String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('language', lang);
}
