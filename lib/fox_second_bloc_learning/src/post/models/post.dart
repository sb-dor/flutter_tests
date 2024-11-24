import 'dart:io';
import 'package:uuid/uuid.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final DateTime datetime;
  final String author;
  final File? attachedFile;

  Post({
    required this.title,
    required this.content,
    required this.author,
    this.attachedFile,
  })  : id = const Uuid().v4(),
        datetime = DateTime.now();
}
