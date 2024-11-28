import 'package:flutter/foundation.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_state_model.freezed.dart';

// if you don't want to add Diagnosticable
// don't add, it help you for debugging in Flutter inspector
@freezed
class PostStateModel with _$PostStateModel{
  const factory PostStateModel({
    required List<Post> posts,
    Post? post,
  }) = _PostStateModel;

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   properties.add(DiagnosticsProperty<List<Post>>('posts', posts));
  //   properties.add(DiagnosticsProperty<Post?>('post', post));
  //   super.debugFillProperties(properties);
  // }
  // @override
  // String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
  //   final builder = DiagnosticPropertiesBuilder();
  //   debugFillProperties(builder);
  //   return builder.properties
  //       .map((property) => '${property.name}: ${property.value}')
  //       .join(', ');
  // }
}
