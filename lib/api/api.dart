import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

class Bus42Api {
  final String url = 'https://bus42.info/navi/api/rpc.php';
  final Map headers = <String, String>{
    'accept': 'application/json, text/plain, */*',
    'accept-encoding': 'gzip, deflate, br',
    'accept-language':
        'ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7,zh-TW;q=0.6,zh;q=0.5',
    'content-type': 'application/json',
    'origin': 'https://bus42.info',
    'referer': 'https://bus42.info/navi/index.html',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
  };

  int count;
  String sid;
  bool isInitialized = false;

  Future _send(String method, [Map params]) async {
    params ??= {};
    if (sid != null) {
      params['sid'] = sid;
    }
    var data = {
      'jsonrpc': '2.0',
      'method': method,
      'params': params,
      'id': count
    };
    http.Response response;
    try {
      response =
          await http.post(url, body: jsonEncode(data), headers: this.headers);
    } on SocketException {
      Fluttertoast.showToast(msg: 'Проверьте интернет-соединение');
      throw SocketException;
    }
    count++;
    var result = jsonDecode(response.body)['result'];
    if (result == null) {
      await startSession();
      return _send(method, params);
    }
    return result;
  }

  Future<void> startSession() async {
    count = 0;
    sid = null;
    Map response = await _send('startSession');
    sid = response['sid'];
    isInitialized = true;
  }

  Future<List<Okato>> getOkatoList() async {
    List response = await _send('getOkatoList');
    var result = <Okato>[Okato.all()];
    response.forEach((json) {
      result.add(Okato.fromJson(json));
    });
    return result;
  }

  Future<List<TransType>> getTransTypeTree(Okato okato) async {
    List response = await _send('getTransTypeTree', {'ok_id': okato.id});
    var result = <TransType>[];
    response.forEach((json) {
      result.add(TransType.fromJson(json));
    });
    return result;
  }

  Future<List<Race>> getRaceTree(Route route, DateTime date) async {
    List response = await _send('getRaceTree',
        {'data': date.toIso8601String().split('T')[0], 'mr_id': route.id});
    var result = <Race>[];
    response.forEach((json) {
      result.add(Race.fromJson(json));
    });
    return result;
  }

  Future<Timetable> getRaspisanie(TimetableInfo timetable) async {
    Map response = await _send('getRaspisanie', {
      'data': timetable.date.toIso8601String().split('T')[0],
      'mr_id': timetable.routeId,
      'rc_kkp': timetable.stopKkp,
      'rl_racetype': timetable.raceType,
      'st_id': timetable.stopId,
    });
    return Timetable.fromJson(response);
  }

// -----------------
// -- MAP RELATED --
// -----------------

// Future<List<RegionCenter>> getRegionCenter(Okato okato) async {
//   List response = await _send('getRegionCenter', {'ok_id': okato.id});
//   var result = <RegionCenter>[];
//   response.forEach((json) {
//     result.add(RegionCenter.fromJson(json));
//   });
//   return result;
// }

// may be added later
// getRoute(Route route)
// getUnits(List<Route> routeList)
// getStopsInRect()

}
