
//
// class MockedHttpClient extends Mock implements http.Client {}
//
// void main() {
//   late http.Client httpClient;
//   late CustomerPaymentVerificationBloc _customerBloc;
//
//   final successResponse = <String, dynamic>{
//     'success': true,
//     'payments': {
//       'data': [
//         {'id': 1, 'amount': 100.0, 'status': '-'},
//         {'id': 2, 'amount': 300.0, 'status': null},
//       ]
//     }
//   };
//
//   // will setUp each test before their start
//   setUpAll(() async {
//     registerFallbackValue(Uri());
//     locator.registerLazySingleton<UrlParameterHelper>(
//           () => UrlParameterHelper(),
//     );
//     await DbHelper.initDatabase();
//     httpClient = MockedHttpClient();
//     _customerBloc = CustomerPaymentVerificationBloc(
//       CustomerPaymentsVerificationRepoImpl(httpClient),
//     );
//   });
//
//   group(
//     'customer payments verification page test',
//         () {
//       test('url test', () {
//         when(() => httpClient.get(
//           any(),
//           headers: any(named: "headers"),
//         )).thenAnswer(
//               (v) async => http.Response(jsonEncode(successResponse), 200),
//         );
//       });
//
//       testWidgets(
//         'check listview',
//             (WidgetTester tester) async {
//           when(() => httpClient.get(
//             any(), // remember to name each any in order make them unique
//             headers:
//             any(named: "headers"), // remember to name each any in order make them unique
//           )).thenAnswer(
//                 (v) async => http.Response(jsonEncode(successResponse), 200),
//           );
//
//           await tester.pumpWidget(CustomersPaymentsVerificationTest(
//             bloc: _customerBloc,
//           ));
//
//           await Future.delayed(const Duration(seconds: 2));
//
//           await tester.pumpAndSettle();
//
//           final listViewFind = find.byType(CustomScrollView).first;
//
//           expect(listViewFind, findsOneWidget);
//
//           final checkCheckBox = find.byKey(const ValueKey('checkbox_for_all_selection')).first;
//
//           expect(checkCheckBox, findsOneWidget);
//
//           var checkBox = tester.firstWidget<Checkbox>(checkCheckBox);
//
//           expect(checkBox.value, false);
//
//           await tester.tap(checkCheckBox);
//
//           await tester.pumpAndSettle();
//
//           checkBox = tester.firstWidget<Checkbox>(checkCheckBox);
//
//           expect(checkBox.value, true);
//         },
//       );
//     },
//   );
// }
//
// class CustomersPaymentsVerificationTest extends StatelessWidget {
//   final CustomerPaymentVerificationBloc bloc;
//
//   const CustomersPaymentsVerificationTest({
//     super.key,
//     required this.bloc,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<CustomerPaymentVerificationBloc>(
//           create: (_) => bloc,
//         )
//       ],
//       child: MaterialApp(
//         builder: EasyLoading.init(),
//         home: const Scaffold(
//           body: CustomerPaymentsVerificationPage(),
//         ),
//       ),
//     );
//   }
// }
