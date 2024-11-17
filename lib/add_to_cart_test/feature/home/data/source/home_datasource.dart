import 'package:flutter/cupertino.dart';
import 'package:flutter_tests/add_to_cart_test/core/models/product/product.dart';
import 'package:flutter_tests/network/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_tests/network/http_rest_client/rest_client_base.dart';
import 'package:http/http.dart' as http;

abstract interface class HomeDatasource {
  Future<List<Product>> getProducts();
}

class HomeDataSourceNetwork implements HomeDatasource {
  final http.Client _client;
  final RestClientBase _restClientBase;

  HomeDataSourceNetwork(
    this._client, {
    String mainUrl = "http://192.168.100.3:8000/api", // don't do this
  }) : _restClientBase = RestClientHttp(
          // For test purposes only!, write a code or create .env file to get MAIN_URL data
          baseUrl: mainUrl,
          client: _client,
        );

  final String _recommended = "product/rekomenduyemiye";

  @override
  Future<List<Product>> getProducts() async {
    final data = await _restClientBase.get(_recommended);

    List<dynamic> list = data?['data'] as List;

    return list.map((e) => Product.fromJson(e)).toList();
  }
}
