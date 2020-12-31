import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../api/models.dart';

List<int> highlight(List<Hour> hours) {
  var now = DateTime.now();
  int diff;

  // ищем ближайший час
  Hour nextHour = hours[0];
  diff = 35;
  hours.forEach((hour) {
    var newDiff = hour.hour - now.hour;
    if (newDiff >= 0 && newDiff < diff) {
      diff = newDiff;
      nextHour = hour;
    }
  });

  // теперь проверяем минуты
  Minute nextMin = nextHour.minutes[0];
  diff = 61;
  if (nextHour.hour == now.hour) {
    nextHour.minutes.forEach((minute) {
      var newDiff = int.parse(minute.minute) - now.minute;
      if (newDiff >= 0 && newDiff < diff) {
        diff = newDiff;
        nextMin = minute;
      }
    });

    if (diff == 61) {
      var index = hours.indexOf(nextHour);
      if (hours.length != index + 1) {
        nextHour = hours[index + 1];
        nextMin = nextHour.minutes[0];
      } else {
        nextHour = hours[0];
        nextMin = nextHour.minutes[0];
      }
    }
  }

  // подсвечиваем
  nextHour.isHighlighted = true;
  nextMin.isHighlighted = true;

  return <int>[nextHour.hour, int.parse(nextMin.minute)];
}

String _intToRemaining(int intTime) {
  int hours = intTime ~/ 60;
  int minutes = intTime - hours * 60;
  return 'через $minutes мин';
}

String getStopNext(Stop stop, bool remaining) {
  if (!remaining) {
    String hours = stop.next[0].toString();
    if (hours.length == 1) hours = '0' + hours;
    String mins = stop.next[1].toString();
    if (mins.length == 1) mins = '0' + mins;
    return '$hours:$mins';
  }

  var now = DateTime.now();
  int nowInt = now.hour * 60 + now.minute;
  int nextInt = stop.next[0] * 60 + stop.next[1];
  if ((nextInt >= nowInt) & ((nextInt - nowInt) < 60)) {
    return _intToRemaining(nextInt - nowInt);
  } else {
    return getStopNext(stop, false);
  }
}

// stop_selector

class RoutePainter extends CustomPainter {
  final int type;

  // -1 - start
  // 0 - middle
  // 1 - finish
  RoutePainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    var zeroOffset = Offset(0, 0);
    double bigRadius = 10;
    double smallRadius = 4;
    double height = 48;

    var bluePaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = bigRadius - smallRadius;
    var whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (type == -1) {
      canvas.drawCircle(zeroOffset, bigRadius, bluePaint);
      canvas.drawCircle(zeroOffset, smallRadius, whitePaint);
      canvas.drawRect(
          Rect.fromCenter(
            center: Offset(0, bigRadius),
            height: bigRadius,
            width: smallRadius * 2,
          ),
          whitePaint);
      canvas.drawCircle(zeroOffset, 1, bluePaint);
      canvas.drawLine(zeroOffset, Offset(0, height), bluePaint);
    } else if (type == 0) {
      canvas.drawLine(Offset(0, -height), Offset(0, height), bluePaint);
      canvas.drawCircle(zeroOffset, smallRadius, bluePaint);
    } else if (type == 1) {
      canvas.drawCircle(zeroOffset, bigRadius, bluePaint);
      canvas.drawCircle(zeroOffset, 1, bluePaint);
      canvas.drawRect(
          Rect.fromCenter(
            center: Offset(0, -bigRadius),
            height: bigRadius,
            width: smallRadius * 2,
          ),
          whitePaint);
      canvas.drawLine(zeroOffset, Offset(0, -height), bluePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RaceSection implements ExpandableListSection<Stop> {
  bool expanded;
  List<Stop> items;
  Race race;

  @override
  List<Stop> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
