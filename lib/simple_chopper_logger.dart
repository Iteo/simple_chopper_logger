library simple_chopper_logger;

import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';

typedef Logger = void Function(String line);

extension YYYYMMDDHHNNSS on DateTime {
  String get yyyymmddhhnnss =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} - ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
}

const _prefix = '[SimpleChopperLogger] ';

class SimpleChopperLogger implements RequestInterceptor, ResponseInterceptor {
  SimpleChopperLogger({
    this.includeRequestHeaders = true,
    this.includeRequestBody = true,
    this.includeResponseHeaders = true,
    this.includeResponseBody = true,
    this.prefix = _prefix,
    this.logger = print,
  });

  final bool includeRequestHeaders;
  final bool includeRequestBody;
  final bool includeResponseHeaders;
  final bool includeResponseBody;
  final String prefix;
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
  FutureOr<Response> onResponse(Response response) {
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
