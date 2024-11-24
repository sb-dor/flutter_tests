abstract interface class IPostDatasource {
  Future<bool> savePost();

  Future<void> addText();
}

class PostDatasourceImpl implements IPostDatasource {
  @override
  Future<bool> savePost() async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  @override
  Future<void> addText() {
    // TODO: implement addText
    throw UnimplementedError();
  }
}
