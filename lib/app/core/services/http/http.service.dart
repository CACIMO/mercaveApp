import 'dart:async';
import 'dart:convert' as Convert;

import 'package:http/http.dart' as HttpClient;
import 'package:mercave/app/core/config.service.dart';
import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/shared/constants/constant.service.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';

class HttpService {
  static final String _domain = ConfigService.WC_ENDPOINT;
  static Future get(
      {String url,
      Map<String, String> headers = const {},
      int timeout = ConstantService.httpTimeout,
      bool http = false,
      Map<String, dynamic> queryParams = const {}}) async {
    var payload;

    try {
      print('$_domain');
      HttpClient.Response response = await HttpClient.get(
        http
            ? Uri.http(_domain, url, queryParams)
            : Uri.https(_domain, url, queryParams),
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
    print(Uri.https(_domain, url));
    HttpClient.Response response = await HttpClient.post(
            Uri.https(_domain, url),
            body: body,
            headers: headers)
        .timeout(
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
