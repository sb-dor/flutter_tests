import 'package:uuid/uuid.dart';

final class TodoModel {
  final String? id;
  final String? name;

  TodoModel({this.name}) : id = const Uuid().v4();
}
