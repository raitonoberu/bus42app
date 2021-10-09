import 'package:flutter/material.dart';

import 'api/api.dart';
import 'api/models.dart';
import 'formatters.dart';
import 'selector.dart';
import 'settings/settings.dart';

Widget leadingIcon(IconData icon) {
  return Container(
    height: double.infinity,
    child: Icon(icon),
  );
}

Widget appBar(String title) {
  return AppBar(
    title: Text(title),
    brightness: Brightness.dark,
  );
}

Widget chip(String text, Color color, [bool margin = true]) {
  return Container(
    margin: margin ? EdgeInsets.only(left: 7, top: 7, right: 7) : null,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    child: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    decoration: BoxDecoration(
        color: color,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(15)),
  );
}

class NavDrawer extends StatefulWidget {
  // <a href='https://www.freepik.com/vectors/background'>Background vector created by rawpixel.com - www.freepik.com</a>

  NavDrawer();

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Okato currentOkato;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text(
                      okatoFormatter(currentOkato),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => setOkato(context),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawer.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_bus),
            title: Text('Расписание'),
            onTap: () {
              Navigator.of(context).pop();
              if (ModalRoute.of(context).settings.name != '/timetable')
                Navigator.pushReplacementNamed(context, '/timetable');
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Закладки'),
            onTap: () {
              Navigator.of(context).pop();
              if (ModalRoute.of(context).settings.name != '/bookmarks')
                Navigator.pushReplacementNamed(context, '/bookmarks');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Настройки'),
            onTap: () {
              Navigator.of(context).pop();
              if (ModalRoute.of(context).settings.name != '/settings')
                Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }

  Future setOkato(context) async {
    Okato _defaultOkato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Selector('Регион', api.getOkatoList(), okatoFormatter)));
    if (_defaultOkato == null) return;
    if (_defaultOkato.id == currentOkato.id) return;
    settings.setOkato(_defaultOkato);
    currentOkato = _defaultOkato;
    Navigator.of(context).pushReplacementNamed('/timetable');
  }

  @override
  void initState() {
    currentOkato = settings.getOkato();
    super.initState();
  }
}
