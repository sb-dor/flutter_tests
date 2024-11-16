import 'package:flutter/material.dart';
import 'package:flutter_tests/network/repository_test.dart';
import 'package:http/http.dart' as http;

class NetworkTestPage extends StatefulWidget {
  const NetworkTestPage({super.key});

  @override
  State<NetworkTestPage> createState() => _NetworkTestPageState();
}

class _NetworkTestPageState extends State<NetworkTestPage> {
  late RepositoryTest _repo;

  @override
  void initState() {
    super.initState();
    _repo = RepositoryTest(http.Client());
    _repo.getTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test network"),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _repo.getTestData(),
        child: ListView(),
      ),
    );
  }
}
