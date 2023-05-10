/// Implementation of Request and Response Chopper interceptors that provides simple but pleasant to look at output.
library simple_chopper_logger;

import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';

/// A function that is used to log all data.
/// By default, it uses [print].
///
/// To change the default behavior, pass any function that takes a [String] as an argument.
typedef Logger = void Function(String line);

const _prefix = '[SimpleChopperLogger] ';

/// A [RequestInterceptor] and [ResponseInterceptor] that logs requests and responses.
///
/// Logging of specific parts of the request and response can be enabled or disabled
/// by using the appropriate constructor parameters.
///
/// The default logging method is [print], but this can be changed by passing a custom
/// [Logger] to the constructor.
///
/// Default prefix added to each log line is `'[SimpleChopperLogger] '`, but this can
/// be changed by passing a custom prefix to the constructor.
///
/// **Warning** Be careful when using this in production, as it will log sensitive
/// information such as headers and request/response bodies.
class SimpleChopperLogger implements RequestInterceptor, ResponseInterceptor {
  SimpleChopperLogger({
    this.includeRequestHeaders = true,
    this.includeRequestBody = true,
    this.includeResponseHeaders = true,
    this.includeResponseBody = true,
    this.prefix = _prefix,
    this.logger = print,
  });

  /// Specifies whether request headers should be logged.
  final bool includeRequestHeaders;

  /// Specifies whether request body should be logged.
  final bool includeRequestBody;

  /// Specifies whether response headers should be logged.
  final bool includeResponseHeaders;

  /// Specifies whether response body should be logged.
  final bool includeResponseBody;

  /// Specifies the prefix that will be added to each log line.
  final String prefix;

  /// Specifies the logger that will be used to log each line.
  ///
  /// By default, it uses [print].
  final Logger logger;

  @override
  FutureOr<Request> onRequest(Request request) {
    final output = StringBuffer();

    final now = DateTime.now().yyyymmddhhnnss;

    output.write('[Request] ');

    output.write('${request.method},');

    output.writeln(' $now ');

    output.writeln('${request.url}');

    if (includeRequestHeaders) {
      output.writeln('Headers:');
      final formattedHeaders =
          const JsonEncoder.withIndent('  ').convert(request.headers);
      output.writeln(formattedHeaders);
    }

    if (includeRequestBody && request.body != null) {
      output.writeln('Body:');
      try {
        final formattedBody = const JsonEncoder.withIndent('  ').convert(
          const JsonDecoder().convert(request.body as String),
        );
        output.writeln(formattedBody);
      } catch (e) {
        output.writeln(request.body);
      }
    }

    for (final line in output.toString().split('\n')) {
      logger('$prefix$line');
    }

    return request;
  }

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) {
    final request = response.base.request;
    final output = StringBuffer();

    final now = DateTime.now().yyyymmddhhnnss;

    final method = request?.method;
    final url = request?.url;
    final responseBase = response.base;
    final reasonPhrase = responseBase.reasonPhrase;

    output.write('[Response] ');

    if (method != null) {
      output.write('$method, ');
    }

    output.write(response.statusCode.toString());
    if (reasonPhrase != null) {
      output.write(' ($reasonPhrase),');
    }

    output.writeln(' $now ');

    if (url != null) {
      output.writeln('$url');
    }

    if (includeResponseHeaders) {
      output.writeln('Headers:');
      final formattedHeaders =
          const JsonEncoder.withIndent('  ').convert(response.headers);
      output.writeln(formattedHeaders);
    }

    if (includeResponseBody &&
        response.body != null &&
        response.bodyString.isNotEmpty) {
      output.writeln('Body:');
      try {
        final formattedBody = const JsonEncoder.withIndent('  ').convert(
          const JsonDecoder().convert(response.bodyString),
        );

        output.writeln(formattedBody);
      } catch (e) {
        output.writeln(response.body);
      }
    }

    for (final line in output.toString().split('\n')) {
      logger('$prefix$line');
    }

    return response;
  }
}

/// Extension on [DateTime] that returns a formatted string.
/// Format: `YYYY-MM-DD - HH:NN:SS`
extension _YYYYMMDDHHNNSS on DateTime {
  String get yyyymmddhhnnss =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} - ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
}
