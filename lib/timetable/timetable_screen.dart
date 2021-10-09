import 'package:flutter/material.dart';

import '../api/api.dart';
import '../api/models.dart' as models;
import '../settings/settings.dart';
import '../widgets.dart';
import 'stop_selector.dart';

// data
String okatoId;
DateTime date;
List<models.TransType> transTypeTree = [];

class TimetableScreen extends StatefulWidget {
  final NavDrawer drawer;

  TimetableScreen(this.drawer);

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  Future selectDate(context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != date) {
      date = picked;
      if (mounted) setState(() {});
    }
  }

  Future selectStop(
      context, models.TransType transType, models.Route route) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StopSelector(date: date, route: route, transType: transType)));
  }

  @override
  Widget build(BuildContext context) {
    if (transTypeTree.isEmpty)
      return Scaffold(
          appBar: appBar('Расписание'),
          drawer: widget.drawer,
          body: Center(child: CircularProgressIndicator()));

    return DefaultTabController(
      length: transTypeTree.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Расписание'),
          brightness: Brightness.dark,
          actions: [
            IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => selectDate(context))
          ],
          bottom: TabBar(
              tabs: transTypeTree.map((transType) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(transType.title),
            );
          }).toList()),
        ),
        drawer: widget.drawer,
        body: TabBarView(
          children: transTypeTree.map((transType) {
            return ListView.separated(
              itemCount: transType.routes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      chip(transType.routes[index].num,
                          Colors.blueGrey.shade600, false),
                    ],
                  ),
                  horizontalTitleGap: 15,
                  title: Text(transType.routes[index].title),
                  onTap: () =>
                      selectStop(context, transType, transType.routes[index]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> initialize() async {
    var update = false;
    if (!api.isInitialized) {
      await api.startSession();
      update = true;
    }
    var newOkato = settings.getOkato();
    if ((newOkato.id != okatoId) | transTypeTree.isEmpty) {
      transTypeTree = [];
      setState(() {});
      transTypeTree = await api.getTransTypeTree(newOkato);
      okatoId = newOkato.id;
      update = true;
    }

    if (update) setState(() {});
  }

  @override
  void initState() {
    initialize();
    date = DateTime.now();
    super.initState();
  }
}
