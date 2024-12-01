import 'package:flutter/material.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';

@immutable
class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey<String>("post_widget_${post.id}"),
      title: Text(post.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.content),
          Text(post.author),
        ],
      ),
    );
  }
}
