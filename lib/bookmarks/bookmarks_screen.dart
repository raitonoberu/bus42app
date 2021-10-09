import 'package:flutter/material.dart';

import '../api/api.dart';
import '../api/models.dart';
import '../formatters.dart';
import '../timetable/timetable_visualizer.dart';
import '../widgets.dart';
import 'bookmarks.dart';

class BookmarksScreen extends StatefulWidget {
  final NavDrawer drawer;

  BookmarksScreen(this.drawer);

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<TimetableInfo> items = [];

  Future showTimetable(BuildContext context, TimetableInfo item) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TimetableVisualizer(data: item, isStarred: true),
        ));
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      appBar: appBar('Закладки'),
      body: ListView.separated(
        physics: ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bookmarkFormatter(items[index])),
            leading: leadingIcon(Icons.star),
            subtitle: Text(items[index].stopTitle),
            minLeadingWidth: 24,
            onTap: () {
              showTimetable(context, items[index]);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
      ),
    );
  }

  Future refresh() async {
    items = await listBookmarks();
    if (mounted) setState(() {});
  }

  Future initialize() async {
    if (!api.isInitialized) await api.startSession();
    await refresh();
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }
}
