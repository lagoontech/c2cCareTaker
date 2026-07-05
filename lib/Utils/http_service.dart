import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../sharedPref/sharedPref.dart';

/// Central HTTP client. Logs the user out when an authenticated request
/// returns HTTP 401 while a session token is stored.
class HttpService {
  HttpService._();

  static final HttpService instance = HttpService._();

  static bool _loggingOut = false;

  Future<Map<String, String>> authHeaders({Map<String, String>? extra}) async {
    final token = await SharedPref().getToken();
    return {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  bool _hasAuthHeader(Map<String, String>? headers) {
    if (headers == null) return false;
    return headers.keys.any((key) => key.toLowerCase() == 'authorization');
  }

  Future<bool> _hasCachedToken() async {
    final token = await SharedPref().getToken();
    return token != null && token.isNotEmpty;
  }

  String _endpointName(Uri url) {
    final path = url.path.isNotEmpty ? url.path : '/';
    if (url.hasQuery) {
      return '$path?${url.query}';
    }
    return path;
  }

  void _logRequest(String method, Uri url, int statusCode) {
    debugPrint(
      '[HTTP] $method ${_endpointName(url)} → $statusCode',
    );
  }

  Future<void> _logoutIfUnauthorized(
    int statusCode,
    Map<String, String>? headers,
  ) async {
    if (statusCode != 401 || !_hasAuthHeader(headers)) return;
    if (!await _hasCachedToken()) return;
    if (_loggingOut) return;

    _loggingOut = true;
    try {
      await SharedPref().logout();
    } finally {
      _loggingOut = false;
    }
  }

  Future<http.Response> _finalizeResponse(
    http.Response response,
    String method,
    Uri url,
    Map<String, String>? headers,
  ) async {
    _logRequest(method, url, response.statusCode);
    await _logoutIfUnauthorized(response.statusCode, headers);
    return response;
  }

  Future<http.StreamedResponse> _finalizeStreamedResponse(
    http.StreamedResponse response,
    String method,
    Uri url,
    Map<String, String>? headers,
  ) async {
    _logRequest(method, url, response.statusCode);
    await _logoutIfUnauthorized(response.statusCode, headers);
    return response;
  }

  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(url, headers: headers);
    return _finalizeResponse(response, 'GET', url, headers);
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _finalizeResponse(response, 'POST', url, headers);
  }

  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.put(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _finalizeResponse(response, 'PUT', url, headers);
  }

  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.delete(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _finalizeResponse(response, 'DELETE', url, headers);
  }

  Future<http.StreamedResponse> sendMultipart(
    http.MultipartRequest request,
  ) async {
    final response = await request.send();
    return _finalizeStreamedResponse(
      response,
      request.method,
      request.url,
      request.headers,
    );
  }

  Future<http.Response> authGet(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return get(url, headers: await authHeaders(extra: headers));
  }

  Future<http.Response> authPost(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return post(
      url,
      headers: await authHeaders(extra: headers),
      body: body,
      encoding: encoding,
    );
  }

  Future<http.Response> authPut(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return put(
      url,
      headers: await authHeaders(extra: headers),
      body: body,
      encoding: encoding,
    );
  }

  Future<http.Response> authDelete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return delete(
      url,
      headers: await authHeaders(extra: headers),
      body: body,
      encoding: encoding,
    );
  }
}
