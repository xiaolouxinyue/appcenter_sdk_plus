import 'package:flutter/foundation.dart';

@immutable
class SendLogsResponse {
  final List<String> validDiagnosticsIds;
  final List<String> throttledDiagnosticsIds;

  const SendLogsResponse({
    required this.validDiagnosticsIds,
    required this.throttledDiagnosticsIds,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'validDiagnosticsIds': validDiagnosticsIds,
      'throttledDiagnosticsIds': throttledDiagnosticsIds,
    };
  }

  SendLogsResponse.fromMap(Map<String, dynamic> map)
      : validDiagnosticsIds = _convertToStringList(map['validDiagnosticsIds']),
        throttledDiagnosticsIds =
            _convertToStringList(map['throttledDiagnosticsIds']);

  static List<String> _convertToStringList(List<dynamic>? dynamicList) {
    if (dynamicList == null) {
      return [];
    }
    return dynamicList.map((e) => e.toString()).toList();
  }

  @override
  String toString() {
    return 'SendLogsResponse${toMap()}';
  }
}
