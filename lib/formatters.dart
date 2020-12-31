import 'api/models.dart';

String okatoFormatter(Okato okato) {
  return okato.title;
}

String routeFormatter(Route route) {
  return '${route.num} - ${route.title}';
}

String bookmarkFormatter(TimetableInfo info) {
  return '${info.routeNum}: ${info.raceFirst} - ${info.raceLast}';
}

String weekdayFormatter(Timetable timetable) {
  int value = int.parse(timetable.dow);

  switch (value) {
    case 96:
      {
        return 'Выходные';
      }
      break;
    case 127:
      {
        return 'Ежедневно';
      }
      break;
    case 31:
      {
        return 'Будни';
      }
      break;
    default:
      {
        String result = '';
        if (0 != 1 & value) result += 'Пн, ';
        if (0 != 2 & value) result += 'Вт, ';
        if (0 != 4 & value) result += 'Ср, ';
        if (0 != 8 & value) result += 'Чт, ';
        if (0 != 16 & value) result += 'Пт, ';
        if (0 != 32 & value) result += 'Сб, ';
        if (0 != 64 & value) result += 'Вс, ';
        return result.substring(0, result.length - 2);
      }
  }
}
