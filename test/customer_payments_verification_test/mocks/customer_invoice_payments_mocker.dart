// import 'dart:math';
//
// import 'package:faker/faker.dart';
// import 'package:my_store/models/customer_invoice_payments.dart';
// import 'package:my_store/models/customer_model.dart';
//
// abstract final class CustomerInvoicePaymentMocker {
//   static final _faker = Faker();
//   static final _random = Random();
//
//   static List<CustomerInvoicePayments> mockedPayments({int length = 15}) {
//     final list = <CustomerInvoicePayments>[];
//     for (int i = 0; i < length; i++) {
//       list.add(
//         CustomerInvoicePayments(
//           id: _random.nextInt(pow(10, 10).toInt()),
//           customerId: Customer(
//             firstName: _faker.person.firstName(),
//             lastName: _faker.person.lastName(),
//           ),
//           amount: _random.nextInt(pow(10, 10).toInt()).toDouble(),
//         ),
//       );
//     }
//     return list;
//   }
// }
