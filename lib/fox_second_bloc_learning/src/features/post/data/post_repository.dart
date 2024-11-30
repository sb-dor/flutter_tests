
import 'post_datasource.dart';

abstract interface class IPostRepository {
  Future<bool> savePost(Map<String, Object?> postData);

  Future<bool> addText(String text);
}

class PostRepositoryImpl implements IPostRepository {
  final IPostDatasource _postDatasource;

  PostRepositoryImpl(this._postDatasource);

  @override
  Future<bool> savePost(Map<String, Object?> postData) => _postDatasource.savePost(postData);

  @override
  Future<bool> addText(String text) => _postDatasource.addText(text);
}
