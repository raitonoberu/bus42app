import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../api/models.dart';

String getFilename(TimetableInfo info) {
  return '${info.routeId}_${info.stopId}';
}

Future<bool> isExists(TimetableInfo timetable) async {
  String path = (await getApplicationDocumentsDirectory()).path +
      '/bookmarks/' +
      getFilename(timetable);
  return await File(path).exists();
}

Future<List<TimetableInfo>> listBookmarks() async {
  String path = (await getApplicationDocumentsDirectory()).path + '/bookmarks';

  Directory directory = Directory(path);
  if (!(await directory.exists())) {
    return <TimetableInfo>[];
  }

  List<FileSystemEntity> files = await directory.list().toList();
  List<String> contents =
      await Future.wait(files.map((file) => (file as File).readAsString()));
  List<TimetableInfo> result = contents
      .map((content) => TimetableInfo.fromMap(jsonDecode(content)))
      .toList();
  result.sort((a, b) => b.savingTime.compareTo(a.savingTime));
  return result;
}

Future<void> saveBookmark(TimetableInfo timetable, bool saveDate) async {
  String path = (await getApplicationDocumentsDirectory()).path +
      '/bookmarks/' +
      getFilename(timetable);

  File file = await File(path).create(recursive: true);
  await file.writeAsString(jsonEncode(
      timetable.toMap(saveDate, DateTime.now().millisecondsSinceEpoch)));
}

Future<void> removeBookmark(TimetableInfo timetable) async {
  String path = (await getApplicationDocumentsDirectory()).path +
      '/bookmarks/' +
      getFilename(timetable);

  await File(path).delete();
}
