import 'package:shared_preferences/shared_preferences.dart';

import '../api/models.dart';

Settings settings = Settings();

final defaultGridMode = true;
final defaultOkato = Okato.all();
final defaultSaveDate = 0;
final defaultInitialScreen = 0;
final defaultTimeRemaining = true;

class Settings {
  SharedPreferences prefs;
  bool isInitialized = false;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    isInitialized = true;
  }

  void setGridMode(bool value) {
    prefs.setBool('gridMode', value);
  }

  bool getGridMode() {
    bool flag = prefs.getBool('gridMode');
    if (flag == null) return defaultGridMode;
    return flag;
  }

  void setInitialScreen(int value) {
    prefs.setInt('initialScreen', value);
  }

  void setTimeRemaining(bool value) {
    prefs.setBool('timeRemaining', value);
  }

  bool getTimeRemaining() {
    bool flag = prefs.getBool('timeRemaining');
    if (flag == null) return defaultTimeRemaining;
    return flag;
  }

  int getInitialScreen() {
    int index = prefs.getInt('initialScreen');
    if (index == null) return defaultInitialScreen;
    return index;
  }

  void setSaveDate(int value) {
    prefs.setInt('saveDate', value);
  }

  int getSaveDate() {
    var result = prefs.getInt('saveDate');
    if (result == null) return defaultSaveDate;
    return result;
  }

  void setOkato(Okato okato) {
    prefs.setStringList('okato', [okato.id, okato.title]);
  }

  Okato getOkato() {
    List list = prefs.getStringList('okato');
    if (list == null) return defaultOkato;
    return Okato.fromSettings(list);
  }
}
