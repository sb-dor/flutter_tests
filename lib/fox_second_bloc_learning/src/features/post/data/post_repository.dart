
import 'post_datasource.dart';

abstract interface class IPostRepository {
  Future<bool> savePost();

  Future<void> addText();
}

class PostRepositoryImpl implements IPostRepository {
  final IPostDatasource _postDatasource;

  PostRepositoryImpl(this._postDatasource);

  @override
  Future<bool> savePost() => _postDatasource.savePost();

  @override
  Future<void> addText() => _postDatasource.addText();
}
