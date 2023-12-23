import '../../appcenter_exception.dart';

class HttpException extends AppCenterException {
  final int statusCode;

  const HttpException({
    super.plugin,
    super.message,
    required this.statusCode,
    super.stackTrace,
  }) : super(code: "http_exception");
}
