import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/network/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RepositoryTest {
  //
  final http.Client _client;

  RepositoryTest(this._client);

  //

  Future<Map<String, Object?>?> getTestData({File? file}) async {
    const baseURL = "http://192.168.100.3:8000";
    const url = "/api/post/images/test";

    final RestClientBase restClient = RestClientHttp(baseUrl: baseURL, client: _client);

    final data = await restClient.post(
      url,
      body: {
        "flutter_version": "flutter v3.5.4",
      },
      files: file != null
          ? [
              http.MultipartFile.fromBytes(
                // this file's name will be added inside fields of multipartRequest
                // take a look -> http/rest_client_http.dart file
                'name_of_the_file',
                await file.readAsBytes(),
                // this file's name will be added inside fields of multipartRequest
                // take a look -> http/rest_client_http.dart file
                // when you do in laravel -> $request->file('name_of_the_file')
                filename: 'name_of_the_file',
              ),
            ]
          : null,
    );

    return data;
  }
}
