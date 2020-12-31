import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'api/api.dart';
import 'bookmarks/bookmarks_screen.dart';
import 'settings/settings.dart';
import 'settings/settings_screen.dart';
import 'timetable/timetable_screen.dart';
import 'widgets.dart' show NavDrawer;

// adb connect 127.0.0.1:62025

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final api = Bus42Api();
  final settings = SettingsController();
  await settings.initialize();
  runApp(Bus42Info(api, settings));
}

class Bus42Info extends StatelessWidget {
  final Bus42Api api;
  final SettingsController settings;

  Bus42Info(this.api, this.settings);

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

    // drawer
    var drawer = NavDrawer(api, settings);

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
        '/timetable': (context) => TimetableScreen(api, settings, drawer),
        '/bookmarks': (context) => BookmarksScreen(api, settings, drawer),
        '/settings': (context) => SettingsScreen(api, settings, drawer),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('ru')],
    );
  }
}
