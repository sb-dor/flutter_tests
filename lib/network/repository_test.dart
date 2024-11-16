import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/network/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

class RepositoryTest {
  //
  final http.Client _client;

  RepositoryTest(this._client);

  //

  Future<void> getTestData() async {
    const baseURL = "http://192.168.100.3:8000";
    const url = "/api/check/product/in/bookmarks";

    final restClient = RestClientHttp(baseUrl: baseURL, client: _client);

    final data = await restClient.send(
      path: url,
      method: RequestType.POST,
      body: {
        "frameworktest": "flutter",
      },
    );

    debugPrint("test repository data coming: $data");
  }
}
