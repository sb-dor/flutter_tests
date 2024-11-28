import 'package:flutter_tests/fox_second_bloc_learning/src/features/post/models/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_state.dart';

part 'post_event.freezed.dart';

@freezed
sealed class PostEvent with _$PostEvent {
  //
  // events mixins
  // comes with freezed package

  @With<SendingEmitter>()
  @With<SuccessFulEmitter>()
  @With<ErrorEmitter>()
  @With<SendErrorEmitter>()
  const factory PostEvent.addPost({required final Post post}) = AddPost;

  // AddTextContainer has "text" getter inside
  // it will be a helper for your event's "text"
  // look, your event has "text" parameter inside constructor
  // @Implements<TextContainer>() // name whatever you want
  // @With<InitialStateEmitter>()
  // @With<AddingTextEmitter>()
  // @With<HasTextEmitter>()
  // @With<ErrorEmitter>()
  const factory PostEvent.addText({required final String text}) = AddTextEvent;

  // FileContainer has "path" getter inside
  // it will be a helper for your event's "path"
  // look, your event has "path" parameter inside constructor
  // @Implements<FileContainer>() // name whatever you want
  // @With<AddFileEmitter>()
  // @With<HasTextAndFileEmitter>()
  // @With<ErrorEmitter>()
  // @With<HasTextAndFileEmitter>()
  const factory PostEvent.addFile({required final String path}) = AddFileEvent;

  //
  // @With<SendingEmitter>()
  // @With<SuccessFulEmitter>()
  // @With<InitialStateEmitter>()
  // @With<ErrorEmitter>()
  const factory PostEvent.send() = SendPostEvent;

// const factory PostEvent.cancel() = CancelPostEvent;
//
// const factory PostEvent.restore() = RestorePostEvent;
}

// events mixins

// abstract class TextContainer {
//   String get text;
// }
//
// abstract class FileContainer {
//   String get path;
// }

// you can create only one mixin and add all necessary states there
// and this means that you will not write logic for emitting
// directly inside bloc, but here, because it kinda bores to
// add states inside bloc

// Notice that mixins are not created for specific event but for one
// super class, but mixins with their functions are separated
// mixin InitialStateEmitter {
//   PostState initial() => const PostState.initial();
// }
//
// mixin AddingTextEmitter {
//   PostState addingText() => const PostState.addingText();
// }
//
// mixin HasTextEmitter implements TextContainer {
//   PostState hasText() => PostState.hasText(text: text);
// }
//
// mixin AddFileEmitter {
//   PostState addFile({required PostState state}) {
//     // assert means that you are checking something in development mode
//     // for example: if state.text is null then is shows a message
//     // message is optional,
//
//     // assert means "утверждать", means that you are saying that state.text is not null
//     // but when it be null, it throws error, with you added message
//     assert(state.text != null, "You can not add file while text is empty");
//     return PostState.addingFile(text: state.text!);
//   }
// }
//
// mixin HasTextAndFileEmitter implements FileContainer {
//   PostState hasFileAndText({required PostState state}) {
//     assert(state.text != null, "You can not add file while text is empty");
//     return PostState.hasFileAndText(text: state.text!, path: path);
//   }
// }
//
mixin SendingEmitter {
  PostState sending({required PostState state}) {
    // assert(state.text != null && state.path != null,
    //     'You can not send file, both file and text should not be empty');
    return PostState.sending(state.postStateModel);
  }
}

mixin SuccessFulEmitter {
  PostState successFul({required PostState state}) {
    return PostState.successful(state.postStateModel);
  }
}

mixin SendErrorEmitter {
  PostState sendError({required PostState state}) {
    return PostState.sendError(state.postStateModel);
  }
}
//
mixin ErrorEmitter {
  PostState error({
    required PostState state,
    String? message,
  }) =>
      PostState.error(
        state.postStateModel,
        errorMessage: message,
      );
}
