import 'package:flutter/material.dart';

import '../api/api.dart';
import '../widgets.dart';
import 'settings.dart';

class SettingsScreen extends StatefulWidget {
  final Bus42Api api;
  final SettingsController settings;
  final NavDrawer drawer;

  SettingsScreen(this.api, this.settings, this.drawer);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsController settings = SettingsController();

  String initialScreenString;
  String gridModeString;
  String timeRemainingString;
  String saveDateString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      appBar: appBar('Настройки'),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text('Начальный экран'),
              leading: leadingIcon(Icons.flag),
              subtitle: Text(initialScreenString),
              onTap: () => initialScreen(context),
            ),
            ListTile(
              title: Text('Вид расписания'),
              leading: leadingIcon(Icons.grid_view),
              subtitle: Text(gridModeString),
              onTap: () => gridMode(context),
            ),
            ListTile(
              title: Text('Время до прибытия'),
              leading: leadingIcon(Icons.timer),
              subtitle: Text(timeRemainingString),
              onTap: () => timeRemaining(context),
            ),
            ListTile(
              title: Text('Сохранение даты'),
              leading: leadingIcon(Icons.calendar_today),
              subtitle: Text(saveDateString),
              onTap: () => saveDate(context),
            ),
          ],
        ).toList(),
      ),
    );
  }

  Future initialScreen(BuildContext context) async {
    int _initialScreen = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Начальный экран'),
            children: [
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Расписание'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
              ),
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Закладки'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(1);
                },
              ),
            ],
          );
        });
    if (_initialScreen == null) return;
    settings.setInitialScreen(_initialScreen);
    fillValues();
  }

  Future gridMode(BuildContext context) async {
    bool _gridMode = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Вид расписания'),
            children: [
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Список'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Сетка'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
    if (_gridMode == null) return;
    settings.setGridMode(_gridMode);
    fillValues();
  }

  Future timeRemaining(BuildContext context) async {
    bool _timeRemaining = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Время до прибытия'),
            children: [
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Показывать'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Не показывать'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (_timeRemaining == null) return;
    settings.setTimeRemaining(_timeRemaining);
    fillValues();
  }

  Future saveDate(BuildContext context) async {
    int _saveDate = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Сохранение даты'),
            children: [
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Сохранять'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(1);
                },
              ),
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Не сохранять'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
              ),
              SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Всегда спрашивать'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(-1);
                },
              ),
            ],
          );
        });
    if (_saveDate == null) return;
    settings.setSaveDate(_saveDate);
    fillValues();
  }

  void fillValues() {
    switch (settings.getInitialScreen()) {
      case 0:
        {
          initialScreenString = 'Расписание';
        }
        break;
      case 1:
        {
          initialScreenString = 'Закладки';
        }
        break;
    }

    switch (settings.getGridMode()) {
      case false:
        {
          gridModeString = 'Список';
        }
        break;
      case true:
        {
          gridModeString = 'Сетка';
        }
        break;
    }

    switch (settings.getTimeRemaining()) {
      case false:
        {
          timeRemainingString = 'Не показывать';
        }
        break;
      case true:
        {
          timeRemainingString = 'Показывать';
        }
        break;
    }

    switch (settings.getSaveDate()) {
      case 1:
        {
          saveDateString = 'Сохранять';
        }
        break;
      case 0:
        {
          saveDateString = 'Не сохранять';
        }
        break;
      default:
        {
          saveDateString = 'Всегда спрашивать';
        }
        break;
    }

    setState(() {});
  }

  @override
  void initState() {
    settings = widget.settings;
    fillValues();
    super.initState();
  }
}
