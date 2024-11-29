import 'package:flutter_tests/network/http_rest_client/http_exceptions/rest_client_exception.dart';

abstract interface class IPostDatasource {
  Future<bool> savePost();

  Future<void> addText();
}

class PostDatasourceImpl implements IPostDatasource {
  @override
  Future<bool> savePost() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      return true;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const WrongResponseTypeException(message: "Wrong response from server"),
        stackTrace,
      );
    }
  }

  @override
  Future<void> addText() async {
    try {
      await Future.delayed(const Duration(seconds: 5));
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const WrongResponseTypeException(message: "Wrong response from server"),
        stackTrace,
      );
    }
  }
}
