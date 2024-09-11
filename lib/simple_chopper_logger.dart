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

/// A function that is used to format [DateTime] objects.
/// By default, it uses [DateTime.toString].
typedef DateFormatter = String Function(DateTime dateTime);

const _prefix = '[SimpleChopperLogger] ';

/// An [Interceptor] that logs requests and responses.
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
class SimpleChopperLogger implements Interceptor {
  SimpleChopperLogger({
    this.includeRequestHeaders = true,
    this.includeRequestBody = true,
    this.includeResponseHeaders = true,
    this.includeResponseBody = true,
    this.prefix = _prefix,
    this.logger = print,
    this.dateFormatter,
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

  /// Specifies the date formatter that will be used to format [DateTime] objects.
  ///
  /// By default, it uses [DateTime.toString].
  final DateFormatter? dateFormatter;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    final output = StringBuffer();

    final now =
        dateFormatter?.call(DateTime.now()) ?? DateTime.now().toString();

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

    output.clear();

    final response = await chain.proceed(request);

    final method = request.method;
    final responseBase = response.base;
    final reasonPhrase = responseBase.reasonPhrase;

    output.write('[Response] ');

    output.write('$method, ');

    output.write(response.statusCode.toString());

    if (reasonPhrase != null) {
      output.write(' ($reasonPhrase),');
    }

    output.writeln(' $now ');

    output.writeln('${request.url}');

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
