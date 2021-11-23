import 'dart:async';
import 'dart:convert' as Convert;

import 'package:http/http.dart' as HttpClient;
import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/shared/constants/constant.service.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';

class HttpService {
  static Future get({
    String url,
    Map<String, String> headers = const {},
    int timeout = ConstantService.httpTimeout,
  }) async {
    var payload;

    try {
      HttpClient.Response response = await HttpClient.get(
        url,
        headers: headers,
      ).timeout(
        Duration(seconds: timeout),
        onTimeout: () {
          throw ExceptionService.timeoutException();
        },
      );

      if (response.statusCode.toString().startsWith('2')) {
        payload = Convert.jsonDecode(response.body);
      } else {
        throw ExceptionService.httpException(
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return Future.error(e);
    }

    return Future.value(payload);
  }

  static Future post({
    String url,
    Map<String, String> headers = const {},
    dynamic body = const {},
    int timeout = ConstantService.httpTimeout,
  }) async {
    var payload;

    HttpClient.Response response = await HttpClient.post(
      url,
      headers: headers,
      body: body,
    ).timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        throw ExceptionService.timeoutException();
      },
    );

    payload = Convert.jsonDecode(response.body);

    if (!response.statusCode.toString().startsWith('2')) {
      payload = Convert.jsonDecode(response.body);

      throw ExceptionService.httpException(
        statusCode: response.statusCode,
        message: StringService.removeAllHtmlTags(payload['message']),
        details: payload,
      );
    }

    return Future.value(payload);
  }
}
