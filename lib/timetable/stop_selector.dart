import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../api/api.dart';
import '../api/models.dart' as models;
import '../formatters.dart';
import '../widgets.dart';
import 'timetable_visualizer.dart';
import 'utils.dart';

class StopSelector extends StatefulWidget {
  final DateTime date;
  final models.TransType transType;
  final models.Route route;

  StopSelector({this.date, this.transType, this.route});

  @override
  _StopSelectorState createState() => _StopSelectorState();
}

class _StopSelectorState extends State<StopSelector> {
  List<models.Race> races = [];
  bool isLoaded = false;

  List<RaceSection> sectionList;

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
          appBar: appBar(routeFormatter(widget.route)),
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: appBar(routeFormatter(widget.route)),
      body: ExpandableListView(
        physics: ClampingScrollPhysics(),
        builder: SliverExpandableChildDelegate(
            sticky: false,
            separatorBuilder: (context, isExpanded, index) {
              return Divider(height: 0);
            },
            sectionList: sectionList,
            headerBuilder: (context, sectionIndex, index) {
              var section = sectionList[sectionIndex];
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  margin: section.isSectionExpanded()
                      ? null
                      : EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  color: Colors.blueGrey.shade100,
                  child: header(section.race, section.isSectionExpanded()),
                ),
                onTap: () {
                  section.setSectionExpanded(!section.isSectionExpanded());
                  setState(() {});
                },
              );
            },
            itemBuilder: (context, sectionIndex, itemIndex, index) {
              var item = sectionList[sectionIndex].items[itemIndex];
              return ListTile(
                horizontalTitleGap: 0,
                leading: leading(
                    item.id, itemIndex, sectionList[sectionIndex].items.length),
                title: Text(item.title),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimetableVisualizer(
                                data: models.TimetableInfo.fromItems(
                                  transType: widget.transType,
                                  route: widget.route,
                                  date: widget.date,
                                  race: sectionList[sectionIndex].race,
                                  stop: item,
                                ),
                              )));
                },
              );
            }),
      ),
    );
  }

  List<RaceSection> _getSections() {
    var sections = <RaceSection>[];
    races.forEach((race) {
      var section = RaceSection()
        ..race = race
        ..items = race.stopList
        ..expanded = false;
      sections.add(section);
    });
    return sections;
  }

  Future initialize() async {
    races = await api.getRaceTree(widget.route, widget.date);
    sectionList = _getSections();
    isLoaded = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }
}

Widget header(models.Race race, bool isExpanded) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isExpanded ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
        Text(race.firststation),
        Icon(Icons.keyboard_arrow_right),
        Text(race.laststation),
      ],
    ),
  );
}

Widget leading(dynamic id, int index, int length) {
  int type;
  if (id == 0) {
    type = null;
  } else if (index <= 1) {
    type = -1;
  } else if (index == (length - 1)) {
    type = 1;
  } else {
    type = 0;
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(left: 10),
        child: CustomPaint(
          painter: type != null ? RoutePainter(type) : null,
        ),
      )
    ],
  );
}
