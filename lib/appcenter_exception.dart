import 'package:flutter/foundation.dart';

/// A generic class which provides exceptions for AppCenter.
/// (similar with FirebaseException)
///
/// ```dart
/// try {
///   ...
/// } on AppCenterException catch (e) {
///   print(e.toString());
/// }
/// ```
@immutable
class AppCenterException implements Exception {
  /// A generic class which provides exceptions for AppCenter.
  ///
  /// ```dart
  /// try {
  ///   ...
  /// } catch (e) {
  ///   print(e.toString());
  /// }
  /// ```
  const AppCenterException({
    this.plugin = "core",
    this.message,
    this.code = "unknown",
    this.stackTrace,
  });

  /// The plugin the exception is for.
  ///
  /// The value will be used to prefix the message to give more context about
  /// the exception.
  final String plugin;

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppCenterException) return false;
    return other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(plugin, code, message);

  @override
  String toString() {
    String output = '[$plugin/$code] $message';

    if (stackTrace != null) {
      output += '\n\n$stackTrace';
    }

    return output;
  }
}
