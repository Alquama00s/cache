import 'package:cache/src/Web/Web.dart';

import '../lib/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import '../lib/lib.dart';

class Cache with ChangeNotifier {
  //Box? _defaultBox, _statusBox;
  bool _toggle = true;

  bool get state => _toggle;

  Future<Response> getRequest(String url, Map<String, String>? header,
      {bool cache = false,
      String? alias,
      CacheControllerInterface? controller}) async {
    try {
      if (cache) {
        assert(controller != null || alias != null);
        controller ??= defaultCacheController;
        var _cacheResponse = await controller.retriever(alias);

        //dirty cache response
        if (_cacheResponse == true) {
          var _backendResponse = await Web.httpGet(url, header);
          if (_backendResponse.isResponseGood) {
            await controller.refiller(_backendResponse, alias);
          }
          return _backendResponse;
        }

        return _cacheResponse as Response;
      }
    } catch (e) {
      print("Error $e");
    }
    return await Web.httpGet(url, header);
  }

  Future<Response> multipartGetRequest(String url, Map<String, String>? header,
      {Map<String, dynamic>? body,
      Map<String, String>? file,
      Map<String, List<String>>? files,
      bool cache = false,
      String? alias,
      CacheControllerInterface? controller}) async {
    if (cache) {
      assert(controller != null || alias != null);
      controller ??= defaultCacheController;

      var _cacheResponse = await controller.retriever(alias);

      //dirty cache response
      if (_cacheResponse == true) {
        var _backendResponse =
            await Web.httpMultipart(url, header, 'GET', body, file, files);
        if (_backendResponse.isResponseGood) {
          await controller.refiller(_backendResponse, alias);
        }
        return _backendResponse;
      }

      return _cacheResponse as Response;
    }
    return await Web.httpMultipart(url, header, 'GET', body, file, files);
  }

  Future<Response> multipartPostRequest(String url, Map<String, String>? header,
      {Map<String, dynamic>? body,
      Map<String, String>? file,
      Map<String, List<String>>? files,
      bool cache = false,
      String? alias,
      CacheControllerInterface? controller}) async {
    var _backendResponse =
        await Web.httpMultipart(url, header, 'POST', body, file, files);
    if (cache) {
      assert(controller != null || alias != null);
      controller ??= defaultCacheController;

      print("notified");

      await controller.makeCacheDirty(_backendResponse, alias);
    }
    _toggle = !_toggle;
    notifyListeners();
    return _backendResponse;
  }

  Future<Response> postRequest(
      String url, Map<String, String>? header, Map<String, dynamic> body,
      {bool cache = false,
      String? alias,
      CacheControllerInterface? controller}) async {
    var _backendResponse = await Web.httpPost(url, header, body);
    if (cache) {
      assert(controller != null || alias != null);
      controller ??= defaultCacheController;

      await controller.makeCacheDirty(_backendResponse, alias);
    }
    _toggle = !_toggle;
    notifyListeners();
    return _backendResponse;
  }

  Future<Response> deleteRequest(
      String url, Map<String, String>? header, Map<String, dynamic> body,
      {bool cache = false,
      String? alias,
      CacheControllerInterface? controller}) async {
    var _backendResponse = await Web.httpDelete(url, header, body);
    if (cache) {
      assert(controller != null || alias != null);
      controller ??= defaultCacheController;

      await controller.makeCacheDirty(_backendResponse, alias);
    }
    _toggle = !_toggle;
    notifyListeners();
    return _backendResponse;
  }
}
