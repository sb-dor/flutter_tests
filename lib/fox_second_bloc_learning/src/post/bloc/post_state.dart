import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'state_model/post_state_model.dart';
part 'post_state.freezed.dart';

@immutable
@freezed
sealed class PostState with _$PostState {
  const PostState._();
  //
  // String? get path => when(
  //       initial: () => null,
  //       hasText: (text) => null,
  //       addingText: () => null,
  //       addingFile: (text) => null,
  //       hasFileAndText: (_, path) => path,
  //       sending: (_, path) => path,
  //       error: (_, path, __) => path,
  //       successful: (_, path) => path,
  //     );
  //
  // //
  // String? get text => when(
  //       initial: () => null,
  //       hasText: (text) => text,
  //       addingText: () => null,
  //       addingFile: (text) => text,
  //       hasFileAndText: (text, _) => text,
  //       sending: (text, _) => text,
  //       error: (text, _, __) => text,
  //       successful: (text, _) => text,
  //     );

  // checks only your preferred state and returns anything that related to return function
  // other functions will not be considered and you can return anything you want
  // also you can create like this for each state
  // in order to not emit same state again and again
  //
  // NOTE!
  // if you want to use transformers with freezed
  // the best solution for transformer is "concurrent()"
  // but you have to created getters for each state (optional, one is enough)
  // in order to check whether specific state is working and you can not to emit particular
  // state again while it's in precess (you can call other events at that time)
  bool get isSending => maybeMap(orElse: () => false, sending: (_) => true);

  const factory PostState.initial(PostStateModel postStateModel) = LoadingTextState;

  const factory PostState.hasText(PostStateModel postStateModel) = HasTextState;

  const factory PostState.addingText(PostStateModel postStateModel) = AddingTextState;

  const factory PostState.addingFile(PostStateModel postStateModel) = AddingFileState;

  const factory PostState.hasFileAndText(PostStateModel postStateModel) = HasFileAndTextState;

  const factory PostState.sending(PostStateModel postStateModel) = SendingState;

  const factory PostState.sendError(PostStateModel postStateModel) = SendErrorState;

  const factory PostState.error(
    PostStateModel postStateModel, {
    @Default("Произошла ошибка") String? errorMessage,
  }) = PostErrorState;

  const factory PostState.successful(PostStateModel postStateModel) = PostSuccessfulState;
}
