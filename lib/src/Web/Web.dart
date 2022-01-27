import 'dart:convert';
import '../lib/lib.dart';
import 'package:http/http.dart' as http;

abstract class Web {
  ///this function is the ultimate internal error handler
  ///errors not because of server but internal app error
  ///later to be merged with error logging function
  static http.Response handleInternalError() {
    return http.Response("Internal Error", 101);
  }

  //various requests

  static Future<http.Response> httpGet(
    String url,
    Map<String, String>? header,
  ) async {
    if (!isUrlCorrect(url)) {
      return handleInternalError();
    }

    final _url = Uri.parse(url);

    final _response = await http.get(
      _url,
      headers: header,
    );

    return _response;
  }

  static Future<http.Response> httpPost(String url, Map<String, String>? header,
      Map<String, dynamic> body) async {
    if (!isUrlCorrect(url)) {
      return handleInternalError();
    }
    final _url = Uri.parse(url);
    final _response = await http.post(
      _url,
      headers: header,
      body: jsonEncode(body),
    );
    return _response;
  }

  static Future<http.Response> httpDelete(String url,
      Map<String, String>? header, Map<String, dynamic> body) async {
    if (!isUrlCorrect(url)) {
      return handleInternalError();
    }
    final _url = Uri.parse(url);
    final _response = await http.delete(
      _url,
      body: body,
      headers: header,
    );
    return _response;
  }

  static Future<http.Response> httpMultipart(
      String url,
      Map<String, String>? headers,
      String method,
      Map<String, dynamic>? body,
      Map<String, String>? file,
      Map<String, List<String>>? files) async {
    if (!isUrlCorrect(url)) {
      return handleInternalError();
    }
    http.StreamedResponse response;
    final _url = Uri.parse(url);
    final request = http.MultipartRequest(method, _url);

    if (headers != null) {
      headers.forEach((key, value) {
        request.headers[key] = value;
      });
    }

    if (body != null) {
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });
    }

    if (file != null) {
      file.forEach((key, value) async {
        try {
          request.files.add(await http.MultipartFile.fromPath(key, value));
        } catch (_) {
          print('ignoring invalid file');
        }
      });
    }

    if (files != null) {
      files.forEach((key, value) async {
        value.forEach((element) async {
          try {
            request.files.add(await http.MultipartFile.fromPath(key, element));
          } catch (_) {
            print('ignoring invalid file');
          }
        });
      });
    }

    response = await request.send();

    var _response = await http.Response.fromStream(response);

    return _response;
  }
}


//TODO: handle internal error as well as server error and translate them back to ui



