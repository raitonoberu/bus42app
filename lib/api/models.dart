class Okato {
  String id;
  String full_title;
  String title;
  String title_en;

  Okato.fromJson(Map<String, dynamic> json) {
    id = json['ok_id'];
    full_title = json['ok_full_title'];
    title = json['ok_title'];
    title_en = json['ok_title_en'];
  }

  Okato.all() {
    id = '';
    full_title = 'Все регионы /';
    title = 'Все регионы';
    title_en = 'All regions';
  }

  Okato.fromSettings(List<String> settingsOkato) {
    id = settingsOkato[0];
    title = settingsOkato[1];
  }
}

class TransType {
  List<Route> routes = [];
  String id;
  String title;
  String title_en;

  TransType.fromJson(Map<String, dynamic> json) {
    json['routes'].forEach((json) {
      routes.add(Route.fromJson(json));
    });
    id = json['tt_id'];
    title = json['tt_title'];
    title_en = json['tt_title_en'];
  }
}

class Route {
  String id;
  String num;
  String title;
  String title_en;

  Route.fromJson(Map<String, dynamic> json) {
    id = json['mr_id'];
    num = json['mr_num'];
    title = json['mr_title'];
    title_en = json['mr_title_en'];
  }
}

class Race {
  List<Stop> stopList = [];
  String route_id;
  String id;
  String firststation;
  String firststation_en;
  String firststation_id;
  String laststation;
  String laststation_en;
  String laststation_id;
  String racetype;

  Race.fromJson(Map<String, dynamic> json) {
    if (json['stopList'] != null) {
      json['stopList'].forEach((json) {
        stopList.add(Stop.fromJson(json));
      });
    }
    route_id = json['mr_id'];
    id = json['rl_id'];
    firststation = json['rl_firststation'];
    firststation_en = json['rl_firststation_en'];
    firststation_id = json['rl_firststation_id'];
    laststation = json['rl_laststation'];
    laststation_en = json['rl_laststation_en'];
    laststation_id = json['rl_laststation_id'];
    racetype = json['rl_racetype'];
  }
}

class Stop {
  List<Hour> hours = [];
  dynamic id;
  String kkp;
  dynamic orderby;
  String title;
  String title_en;

  List<int> next; // [hour, minute]

  Stop.fromJson(Map<String, dynamic> json) {
    if (json['hours'] != null) {
      json['hours'].forEach((json) {
        hours.add(Hour.fromJson(json));
      });
    }
    ;
    id = json['st_id'];
    kkp = json['rc_kpp'];
    orderby = json['rc_orderby'];
    title = json['st_title'];
    title_en = json['st_title_en'];
  }
}

class Timetable {
  List<Stop> stopList = [];
  List<Race> races = [];
  String id;
  String dow;
  String enddate;
  bool enddateexists;
  String num;
  String season;
  String startdate;
  String srv_id;

  Timetable.fromJson(Map<String, dynamic> json) {
    json['stopList'].forEach((json) {
      stopList.add(Stop.fromJson(json));
    });
    json['races'].forEach((json) {
      races.add(Race.fromJson(json));
    });
    id = json['rv_id'];
    dow = json['rv_dow'];
    enddate = json['rv_enddate'];
    int.parse(json['rv_enddateexists']) == 0
        ? enddateexists = false
        : enddateexists = true;
    num = json['rv_num'];
    season = json['rv_season'];
    startdate = json['rv_startdate'];
    srv_id = json['srv_id'];
  }
}

class Hour {
  int hour;
  List<Minute> minutes = [];
  bool isHighlighted = false;

  Hour.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    json['minutes'].forEach((json) {
      minutes.add(Minute.fromJson(json));
    });
  }
}

class Minute {
  String minute;
  String racetype;
  bool isHighlighted = false;

  Minute.fromJson(Map<String, dynamic> json) {
    minute = json['minute'];
    racetype = json['rl_racetype'];
  }
}

class TimetableInfo {
  int savingTime;
  DateTime date;
  String transType;
  String routeId;
  String routeNum;
  String routeTitle;
  String raceType;
  String raceFirst;
  String raceLast;
  String stopTitle;
  String stopKkp;
  dynamic stopId;

  TimetableInfo.fromItems(
      {DateTime date, TransType transType, Route route, Race race, Stop stop}) {
    this.date = date;
    this.transType = transType.title;
    this.routeId = route.id;
    this.routeNum = route.num;
    this.routeTitle = route.title;
    this.raceType = race.racetype;
    this.raceFirst = race.firststation;
    this.raceLast = race.laststation;
    this.stopTitle = stop.title;
    this.stopKkp = stop.kkp;
    this.stopId = stop.id;
  }

  TimetableInfo.fromMap(Map<String, dynamic> map) {
    savingTime = map['savingTime'];
    if (map['date'] != null) {
      date = DateTime.parse(map['date']);
    } else {
      date = null;
    }
    transType = map['transType'];
    routeId = map['routeId'];
    routeNum = map['routeNum'];
    routeTitle = map['routeTitle'];
    raceType = map['raceType'];
    raceFirst = map['raceFirst'];
    raceLast = map['raceLast'];
    stopTitle = map['stopTitle'];
    stopKkp = map['stopKkp'];
    stopId = map['stopId'];
  }

  Map<String, dynamic> toMap(bool saveDate, int time) {
    var _date;
    if (saveDate == true) {
      _date = date.toIso8601String();
    } else {
      _date = null;
    }
    return {
      'savingTime': time,
      'date': _date,
      'transType': transType,
      'routeId': routeId,
      'routeNum': routeNum,
      'routeTitle': routeTitle,
      'raceType': raceType,
      'raceFirst': raceFirst,
      'raceLast': raceLast,
      'stopTitle': stopTitle,
      'stopKkp': stopKkp,
      'stopId': stopId,
    };
  }
}

// -----------------
// -- MAP RELATED --
// -----------------

// class RegionCenter {
//   String centerLat;
//   String centerLong;
//
//   RegionCenter.fromJson(Map<String, dynamic> json) {
//     centerLat = json['centerLat'];
//     centerLong = json['centerLong'];
//   }
// }
