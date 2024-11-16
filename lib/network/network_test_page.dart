import 'package:flutter/material.dart';
import 'package:flutter_tests/network/repository_test.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
        child: ListView(
          children: [
            IconButton(
              onPressed: () async {
                final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                await _repo.getTestData(file: file);
              },
              icon: const Icon(Icons.file_copy),
            ),
          ],
        ),
      ),
    );
  }
}
