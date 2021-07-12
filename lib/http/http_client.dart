import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'http_interceptor.dart';

class HttpClient {
  static String baseUrl = '192.168.100.219:60627';
  static String tokenApi = 'radio';

  static final Client _client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    requestTimeout: const Duration(seconds: 60),
  );

  static Future<Response> postXWWForm(
      {@required String route, @required Map<String, dynamic> jsonBody}) async {
    final Uri urlEndPoint = Uri.http(baseUrl, route);
    print(urlEndPoint.host);
    try {
      final Response response = await HttpClient._client.post(
        urlEndPoint,
        body: jsonBody,
        headers: {'Content-type': 'application/x-www-form-urlencoded'},
      );

      return handleHttpError(response: response);
    } catch (e) {
      handleHttpInterceptorException(e);
    }

    throw 'Erro desconhecido"';
  }

  static void handleHttpInterceptorException(dynamic e) {
    if (e.message.startsWith('Timeout') != null) {
      throw Exception('Serviço não disponível!');
    } else {
      throw e;
    }
  }

  static Future<Response> postJson(
      {@required String route, @required String jsonBody}) async {
    final Uri urlEndPoint = Uri.http(baseUrl, route);
    try {
      final Response response = await HttpClient._client.post(
        urlEndPoint,
        body: jsonBody,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Basic $tokenApi',
        },
      );

      return handleHttpError(response: response);
    } catch (e) {
      handleHttpInterceptorException(e);
    }

    throw 'Erro desconhecido"';
  }

  static Future<Response> get({
    @required String route,
    Map<String, String> parameters,
    String routeUrl,
  }) async {
    Uri urlEndPoint = Uri.http(baseUrl, route);
    if (parameters != null) {
      urlEndPoint = Uri.http(baseUrl, route, parameters);
    }

    try {
      final Response response = await HttpClient._client.get(
        urlEndPoint,
        headers: {
          'Authorization': 'Basic $tokenApi',
        },
      );

      return handleHttpError(response: response);
    } catch (e) {
      handleHttpInterceptorException(e);
    }

    throw 'Erro desconhecido"';
  }

  static Response handleHttpError({@required Response response}) {
    if (response.statusCode == 200) {
      return response;
    }

    if (response.statusCode == 500) {
      final dynamic errors = jsonDecode(response.body)['errors'];
      final String error = errors[0]['message'] as String;
      print(error);
      throw Exception(error);
    }

    throw HttpException('Http Error: ${response.statusCode.toString()}');
  }
}
