part of internal_lib;

abstract class CacheControllerInterface {
  Future<dynamic> retriever(String? alias);
  Future<void> refiller(Response response, String? alias);
  Future<void> makeCacheDirty(Response response, String? alias);
}
