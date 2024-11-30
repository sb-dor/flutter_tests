
import 'post_datasource.dart';

abstract interface class IPostRepository {
  Future<bool> savePost(Map<String, Object?> postData);

  Future<void> addText();
}

class PostRepositoryImpl implements IPostRepository {
  final IPostDatasource _postDatasource;

  PostRepositoryImpl(this._postDatasource);

  @override
  Future<bool> savePost(Map<String, Object?> postData) => _postDatasource.savePost(postData);

  @override
  Future<void> addText() => _postDatasource.addText();
}
