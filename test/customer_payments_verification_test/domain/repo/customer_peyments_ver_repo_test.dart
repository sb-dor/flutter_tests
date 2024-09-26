// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:my_store/api/api_connections.dart';
// import 'package:my_store/features/customer_payments_verification_feature/constants/customer_payments_ver_constants.dart';
// import 'package:my_store/features/customer_payments_verification_feature/data/repo/customer_payments_ver_repo_impl.dart';
// import 'package:my_store/models/customer_invoice_payments.dart';
// import 'package:my_store/models/error_model/failure.dart';
// import 'package:my_store/utils/url_parameter_helper/url_parameter_helper.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:my_store/x_container_inj/container_injection.dart';
//
// // Mock classes
// class MockUrlParameterHelper extends Mock implements UrlParameterHelper {}
//
// class MockHttpClient extends Mock implements http.Client {}
//
// class MockApiConnections extends Mock implements ApiConnections {}
//
// void main() {
//   late CustomerPaymentsVerificationRepoImpl repo;
//   late MockHttpClient mockHttpClient;
//   late MockUrlParameterHelper mockUrlParameterHelper;
//
//   setUp(() {
//     registerFallbackValue(Uri());
//     locator.registerLazySingleton<UrlParameterHelper>(
//       () => UrlParameterHelper(),
//     );
//     mockHttpClient = MockHttpClient();
//     mockUrlParameterHelper = MockUrlParameterHelper();
//     repo = CustomerPaymentsVerificationRepoImpl(mockHttpClient);
//   });
//
//   group('getAllCustomersPayments', () {
//     const paymentsUrl = "/get/customers/unverified-payments";
//     final successResponse = <String, dynamic>{
//       'success': true,
//       'payments': {
//         'data': [
//           {'id': 1, 'amount': 100.0},
//         ]
//       }
//     };
//
//     test('should return a list of payments when the call is successful', () async {
//       // Arrange
//       final expectedPayments = [CustomerInvoicePayments(id: 1, amount: 100.0)];
//
//       when(() => mockUrlParameterHelper.parameterHelper(any())).thenAnswer((_) => "?page=1");
//
//       when(() => mockHttpClient.get(
//             any(),
//             headers: any(named: 'headers'),
//           )).thenAnswer((_) async => http.Response(jsonEncode(successResponse), 200));
//
//       // Act
//       final result = await repo.getAllCustomersPayments();
//
//       // Assert
//       expect(result, isA<Right<Failure, List<CustomerInvoicePayments>>>());
//
//       verify(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).called(1);
//     });
//
//     test('should return Failure when the response status code is not 200', () async {
//       // Arrange
//       when(() => mockUrlParameterHelper.parameterHelper(any())).thenAnswer((_) => "?page=1");
//       when(() => mockHttpClient.get(
//             Uri.parse("url"),
//             headers: any(named: 'headers'),
//           )).thenAnswer((_) async => http.Response('Error', 400));
//
//       // Act
//       final result = await repo.getAllCustomersPayments();
//
//       // Assert
//       expect(
//         result,
//         isA<Left<Failure, List<CustomerInvoicePayments>>>(),
//       );
//
//       // verify that get request called only once
//       verify(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).called(1);
//     });
//   });
// }
