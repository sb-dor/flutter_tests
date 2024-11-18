import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/data/source/home_datasource.dart';
import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;

import '../../../fixtures/home_fixtures.dart';

void main() {
  late http.Client client;
  late HomeDataSourceNetwork homeDataSourceNetwork;

  /// always test network data for:
  /// "homeDataSourceNotEmptyResponse", "homeDataSourceServerError", "homeDataSourceWrongResponseType",
  /// ""
  /// if function returns null check for -> homeDataSourceNullResponse"
  /// "homeDataSourceStructuredError", "homeDataSourceNetworkError"

  group(
    'homeDataSourceNetworkTest',
    () {
      test(
        'homeDataSourceNotEmptyResponse',
        () async {
          final mapOfProducts = {
            "data": productsTest.map((e) => e.toJson()).toList(),
          };
          client = http_testing.MockClient(
            (req) async => http.Response(jsonEncode(mapOfProducts), 200),
          );
          homeDataSourceNetwork = HomeDataSourceNetwork(client);

          expectLater(
            homeDataSourceNetwork.getProducts(),
            completion(
              isNotEmpty,
            ),
          );
        },
      );

      test(
        'homeDataSourceServerError',
        () async {
          client = http_testing.MockClient(
            (req) async => http.Response("Server error", 500),
          );
          homeDataSourceNetwork = HomeDataSourceNetwork(client);

          expectLater(
            homeDataSourceNetwork.getProducts(),
            throwsA(
              isA<ClientException>(),
            ), // Expect an exception
          );
        },
      );

      test(
        'HomeDataSourceWrongResponseType',
        () async {
          client = http_testing.MockClient(
            (req) async => http.Response('', 200),
          );
          homeDataSourceNetwork = HomeDataSourceNetwork(client);
          expect(
            () => homeDataSourceNetwork.getProducts(),
            throwsA(isA<WrongResponseTypeException>()),
          );
        },
      );

      test('getProducts throws Exception for network issues', () async {
        client = http_testing.MockClient(
          (req) async => throw http.ClientException('Failed to connect'),
        );
        homeDataSourceNetwork = HomeDataSourceNetwork(client);

        expect(
          () => homeDataSourceNetwork.getProducts(),
          throwsA(isA<ClientException>()),
        );
      });
    },
  );
}
