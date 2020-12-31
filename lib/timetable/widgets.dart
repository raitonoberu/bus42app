import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../api/models.dart';
import '../formatters.dart';
import '../widgets.dart';
import 'utils.dart';
// timetable_screen

Widget infoCard(TimetableInfo info, Timetable timetable) {
  var children = [
    _infoRow('Маршрут: ', info.routeTitle),
    SizedBox(height: 5),
    _infoRaceRow(info.raceFirst, info.raceLast),
  ];
  if (timetable != null) {
    children += [
      SizedBox(height: 5),
      _infoRow('Действует с: ', timetable.startdate.replaceAll('-', '.')),
    ];
    if (timetable.enddateexists) {
      children += [
        SizedBox(height: 5),
        _infoRow('Действует до: ', timetable.enddate.replaceAll('-', '.')),
      ];
    }
    children += [
      SizedBox(height: 5),
      _infoRow('Дни недели: ', weekdayFormatter(timetable)),
    ];
  }

  return Card(
    margin: EdgeInsets.all(5),
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: children,
      ),
    ),
  );
}

Widget _infoRow(String title, String value) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
        text: TextSpan(style: TextStyle(color: Colors.black), children: [
      TextSpan(text: title, style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: value)
    ])),
  );
}

Widget _infoRaceRow(String raceFirst, String raceLast) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
        text: TextSpan(style: TextStyle(color: Colors.black), children: [
      TextSpan(
          text: 'Направление: от: ',
          style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: raceFirst),
      TextSpan(text: ' до: ', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: raceLast),
    ])),
  );
}

// timetable_visualizer

Widget racesCard(List<Race> races) {
  return Card(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Wrap(
        children: races.map((race) => _raceItem(race)).toList(),
      ),
    ),
  );
}

Widget _raceItem(Race race) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            race.racetype,
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
        RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
          TextSpan(text: 'от: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: race.firststation),
          TextSpan(text: '\n'),
          TextSpan(text: 'до: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: race.laststation),
        ]))
      ],
    ),
  );
}

Widget stopList(Stop stop, {bool grid, bool remaining}) {
  Widget content;
  if (stop.hours.length > 0) {
    if (grid) {
      content = GridView.builder(
        // сетка
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: .8),
        itemCount: stop.hours.length,
        itemBuilder: (context, index) {
          return _stopListGridItem(stop.hours[index]);
        },
      );
    } else {
      content = ListView.builder(
        // список
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: stop.hours.length,
        itemBuilder: (context, index) {
          return _stopListListItem(stop.hours[index]);
        },
      );
    }
  } else {
    content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(child: Text('Нет данных')),
    );
  }

  return StickyHeader(
    header: Row(
      children: [
        chip(stop.title, Colors.blueGrey),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: (stop.next != null)
                ? [
                    chip(getStopNext(stop, remaining), Colors.blueGrey[700]),
                  ]
                : [],
          ),
        )
      ],
    ),
    content: content,
  );
}

Widget _stopListGridItem(Hour hour) {
  double spacing = 5;
  if (hour.minutes.length > 12) spacing -= 2;

  return Card(
    shadowColor: hour.isHighlighted ? Colors.black : Colors.white,
    color: hour.isHighlighted ? Colors.blueGrey.shade50 : Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              hour.hour.toString(),
              style: TextStyle(fontSize: 25),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: spacing,
            direction: Axis.vertical,
            children: hour.minutes.map((minute) {
              List<Widget> children = [
                Text(
                  minute.minute,
                  style: minute.isHighlighted
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
              ];
              if (minute.racetype != 'A' && minute.racetype != 'B')
                children.add(Text(
                  '[${minute.racetype}]',
                  style: TextStyle(color: Colors.deepOrange, fontSize: 10),
                ));
              return Row(
                children: children,
              );
            }).toList(),
          )
        ],
      ),
    ),
  );
}

Widget _stopListListItem(Hour hour) {
  return Card(
    shadowColor: hour.isHighlighted ? Colors.blueGrey : Colors.white,
    color: hour.isHighlighted ? Colors.blueGrey.shade50 : Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Container(
      margin: EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: Text(
                hour.hour.toString(),
                style: TextStyle(fontSize: 27),
              ),
            ),
            VerticalDivider(
              color:
                  !hour.isHighlighted ? Colors.grey.shade300 : Colors.black26,
              thickness: 1,
              width: 20,
              indent: 3,
              endIndent: 3,
            ),
            Expanded(
              child: Wrap(
                runSpacing: 5,
                children: hour.minutes.map((minute) {
                  List<Widget> children = [
                    Text(
                      minute.minute,
                      style: minute.isHighlighted
                          ? TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                          : TextStyle(fontSize: 17),
                    ),
                  ];
                  if (minute.racetype != 'A' && minute.racetype != 'B')
                    children.add(Text(
                      '[${minute.racetype}]',
                      style: TextStyle(color: Colors.deepOrange, fontSize: 11),
                    ));
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
