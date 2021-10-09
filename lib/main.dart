import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bookmarks/bookmarks_screen.dart';
import 'settings/settings.dart';
import 'settings/settings_screen.dart';
import 'timetable/timetable_screen.dart';
import 'widgets.dart' show NavDrawer;

// adb connect 127.0.0.1:62025

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settings.initialize();
  runApp(Bus42Info());
}

class Bus42Info extends StatelessWidget {
  NavDrawer drawer = NavDrawer();

  Bus42Info();

  @override
  Widget build(BuildContext context) {
    // system settings
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // initial route
    String initialRoute;
    switch (settings.getInitialScreen()) {
      case 0:
        {
          initialRoute = '/timetable';
        }
        break;
      case 1:
        {
          initialRoute = '/bookmarks';
        }
    }

    return MaterialApp(
      title: 'Bus42.info',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColorBrightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      initialRoute: initialRoute,
      routes: {
        '/timetable': (context) => TimetableScreen(drawer),
        '/bookmarks': (context) => BookmarksScreen(drawer),
        '/settings': (context) => SettingsScreen(drawer),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('ru')],
    );
  }
}
