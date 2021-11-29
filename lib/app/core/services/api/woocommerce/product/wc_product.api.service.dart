import 'package:flutter/foundation.dart';
import 'package:mercave/app/core/config.service.dart';
import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class WCProductAPIService {
  WooCommerceAPI _wcAPI;

  WCProductAPIService() {
    this._wcAPI = WooCommerceAPI(
      url: "https://${ConfigService.WC_ENDPOINT}",
      consumerKey: ConfigService.WC_CONSUMER_KEY,
      consumerSecret: ConfigService.WC_CONSUMER_SECRET,
    );
  }

  Future getProducts({@required List<String> productList}) async {
    dynamic response;
    String responseCode;

    String productsParam = productList.join(',');

    try {
      String endpoint =
          "products/?include=$productsParam&orderby=title&order=asc&per_page=100";
      response = await this._wcAPI.getAsync(endpoint);

      try {
        responseCode = response['code'];
      } catch (e) {}

      if (responseCode != null) {
        throw ExceptionService.httpException(
          statusCode: response['data']['status'],
          message: response['message'],
          details: response,
        );
      }
    } catch (e) {
      return Future.error(e);
    }
    return Future.value(response);
  }
}
