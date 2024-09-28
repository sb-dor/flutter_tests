import 'package:flutter/material.dart';

class ListviewScrollTest extends StatefulWidget {
  const ListviewScrollTest({super.key});

  @override
  State<ListviewScrollTest> createState() => _ListviewScrollTestState();
}

class _ListviewScrollTestState extends State<ListviewScrollTest> {
  final _generatedList = List.generate(5000, (i) => "Item of number: ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scrolling test"),
      ),
      body: ListView.separated(
        key: const ValueKey("scrollable_listview"),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: _generatedList.length,
        padding: const EdgeInsets.only(left: 10, right: 10),
        itemBuilder: (context, index) {
          return Text(
            key: ValueKey("generated_text_${index + 1}"),
            _generatedList[index],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
