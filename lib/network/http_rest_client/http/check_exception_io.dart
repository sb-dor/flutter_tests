import 'dart:io';

import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/http.dart' as http;

// coverage:ignore-start
/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) => switch (e) {
// Under the hood, HTTP has _ClientSocketException that implements
// SocketException interface and extends ClientException
// ignore: avoid-unrelated-type-assertions
      final SocketException socketException => ConnectionException(
          message: socketException.message,
          cause: socketException,
        ),
      _ => null, // other exception is null
    };
// coverage:ignore-end
