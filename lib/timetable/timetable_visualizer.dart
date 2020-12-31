import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/api.dart';
import '../api/models.dart' as models;
import '../bookmarks/bookmarks.dart';
import '../settings/settings.dart';
import 'utils.dart';
import 'widgets.dart';

class TimetableVisualizer extends StatefulWidget {
  final Bus42Api api;
  final SettingsController settings;
  final models.TimetableInfo data;
  final bool isStarred;

  TimetableVisualizer({this.api, this.settings, this.data, this.isStarred = false});

  @override
  _TimetableVisualizerState createState() => _TimetableVisualizerState();
}

class _TimetableVisualizerState extends State<TimetableVisualizer> {
  Bus42Api api;

  models.Timetable timetable;
  SettingsController settings;
  bool isInitialized = false;
  bool isStarred;
  bool notFound = false;

  RefreshController refreshController;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      infoCard(widget.data, timetable),
    ];

    if (timetable != null) {
      if (timetable.races.length > 0) children.add(racesCard(timetable.races));
      children += timetable.stopList.map((stop) {
        return stopList(stop,
            grid: settings.getGridMode(),
            remaining: settings.getTimeRemaining());
      }).toList();
    } else if (notFound == true) {
      children.add(
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: Text('Нет данных'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data.transType} ${widget.data.routeNum}'),
        brightness: Brightness.dark,
        actions: isInitialized
            ? [
                IconButton(
                  icon: Icon(
                    isStarred ? Icons.star : Icons.star_border,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (isStarred) {
                      unstar();
                    } else {
                      star();
                    }
                  },
                )
              ]
            : null,
      ),
      body: SmartRefresher(
        physics: ClampingScrollPhysics(),
        enablePullUp: false,
        enablePullDown: true,
        controller: refreshController,
        onRefresh: () => initialize(),
        child: ListView(
          shrinkWrap: true,
          children: children,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  Future unstar() async {
    await removeBookmark(widget.data);
    isStarred = false;
    if (mounted) setState(() {});
  }

  Future star() async {
    int saving = settings.getSaveDate();
    bool saveDate;

    switch (saving) {
      case -1:
        {
          saveDate = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Сохранить дату?'),
                  actions: [
                    FlatButton(
                      child: Text('Да'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    FlatButton(
                      child: Text('Нет'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                );
              });
        }
        break;
      case 0:
        {
          saveDate = false;
        }
        break;
      case 1:
        {
          saveDate = true;
        }
        break;
    }
    if (saveDate == null) return;

    await saveBookmark(widget.data, saveDate);
    isStarred = true;
    if (mounted) setState(() {});
  }

  Future initialize() async {
    // timetable
    try {
      timetable = await api.getRaspisanie(widget.data);
      timetable.stopList.forEach((stop) {
        if (stop.hours.length > 0) stop.next = highlight(stop.hours);
      });
    } on TypeError {
      notFound = true;
    }

    // star
    if (!isStarred) {
      if (await isExists(widget.data)) {
        isStarred = true;
      }
    }

    isInitialized = true;
    if (mounted) setState(() {});
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    api = widget.api;
    settings = widget.settings;
    isStarred = widget.isStarred;
    if (widget.data.date == null) widget.data.date = DateTime.now();
    refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }
}
