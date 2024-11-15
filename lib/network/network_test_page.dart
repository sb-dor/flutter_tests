import 'package:flutter/material.dart';
import 'package:flutter_tests/network/repository_test.dart';
import 'package:http/http.dart' as http;

class NetworkTestPage extends StatefulWidget {
  const NetworkTestPage({super.key});

  @override
  State<NetworkTestPage> createState() => _NetworkTestPageState();
}

class _NetworkTestPageState extends State<NetworkTestPage> {
  @override
  void initState() {
    super.initState();
    final repo = RepositoryTest(http.Client());
    repo.getTestData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test network"),),
    );
  }
}
