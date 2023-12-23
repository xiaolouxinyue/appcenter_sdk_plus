import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_async/sqlite3_async.dart';

import '../../domain/event_log.dart';
import '../../domain/log.dart';
import '../../domain/managed_error_log.dart';

@immutable
class LogRepository {
  static const int _logsDbVersion = 1;
  static const String _tableName = "logs";
  final AsyncDatabase db;

  const LogRepository._internal(this.db);

  static Future<LogRepository> create(String? dbPath) async {
    dbPath ??= await _createDbPath();
    var logsDatabase = await _createAndOpenLogsDb(dbPath);
    return LogRepository._internal(logsDatabase);
  }

  static Future<String> _createDbPath() async {
    var databasePath = await getApplicationSupportDirectory();
    if (!await databasePath.exists()) {
      await databasePath.create(recursive: true);
    }
    return path.join(databasePath.path, "logs.db");
  }

  static Future<AsyncDatabase> _createAndOpenLogsDb(String dbPath) async {
    var db = await AsyncDatabase.open(dbPath);
    var dbVersion = await db.getUserVersion();
    if (dbVersion == _logsDbVersion) {
      return db;
    }
    await db.execute("DROP TABLE IF EXISTS $_tableName");
    await db.execute("CREATE TABLE $_tableName("
        "id TEXT PRIMARY KEY,"
        "type TEXT NOT NULL,"
        "timestamp TEXT NOT NULL,"
        "value TEXT NOT NULL)");
    await db.setUserVersion(_logsDbVersion);
    return db;
  }

  static Log _convertToLog(dynamic item) {
    var decodedValue = jsonDecode(item["value"]);
    if (item["type"] == "event") {
      return EventLog.fromMap(decodedValue);
    }
    return ManagedErrorLog.fromMap(decodedValue);
  }

  Future<void> save(Log logItem) async {
    return await db.execute(
        "INSERT INTO $_tableName (id,type,timestamp,value) "
        "VALUES (?,?,?,?)",
        [
          logItem.id,
          logItem.type,
          logItem.timestamp,
          jsonEncode(logItem.toMap()),
        ]);
  }

  Future<List<Log>> findAll(int offset, int limit) async {
    return (await db.select(
            "SELECT * "
            "FROM $_tableName "
            "ORDER BY timestamp DESC "
            "LIMIT ? OFFSET ?",
            [limit, offset]))
        .map((item) => _convertToLog(item))
        .toList();
  }

  Future<void> deleteByIds(List<String> logItemIds) async {
    if (logItemIds.isEmpty) {
      return;
    }
    var whereClause = logItemIds.map((id) => "id='$id'").join(" OR ");
    return await db.execute("DELETE FROM $_tableName "
        "WHERE $whereClause");
  }

  Future<int> count() async {
    return (await db.select("SELECT count(id) AS c FROM $_tableName"))
        .first["c"] as int;
  }
}
