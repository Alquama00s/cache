part of internal_lib;

class DefaultCacheController implements CacheControllerInterface {
  Box? _defaultBox, _statusBox;

  Future<void> init() async {
    //Hive.initFlutter();object
    if (_defaultBox == null) _defaultBox = await Hive.openBox("defaultBox");
    if (_statusBox == null) _statusBox = await Hive.openBox("statusBox");
  }

  void _checkInitialized() {
    if (_defaultBox == null || _statusBox == null) {
      throw Exception("initialize defalutCacheController first use init");
    }
  }

  @override
  Future<dynamic> retriever(String? alias) async {
    _checkInitialized();
    var isdirty = _statusBox!.get(alias) ?? true;

    if (isdirty) {
      return isdirty;
    } else {
      var cachedResponse = _defaultBox!.get(alias);
      return Response(cachedResponse, 102);
    }
  }

  @override
  Future<void> refiller(Response response, String? alias) async {
    if (response.isResponseGood) {
      _checkInitialized();
      await _defaultBox!.put(alias, response.body);
      await _statusBox!.put(alias, false);
    }
  }

  @override
  Future<void> makeCacheDirty(Response response, String? alias) async {
    if (response.isResponseGood) {
      _checkInitialized();
      await _statusBox!.put(alias, true);
    }
  }

  Future<void> clearCache() async {
    _checkInitialized();
    await _defaultBox!.deleteFromDisk();
    await _statusBox!.deleteFromDisk();
    _defaultBox = null;
    _statusBox = null;
  }
}

final DefaultCacheController defaultCacheController = DefaultCacheController();
