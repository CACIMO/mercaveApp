import 'package:mercave/app/core/config.service.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class WCOrderAPIService {
  WooCommerceAPI _wcAPI;

  WCOrderAPIService() {
    this._wcAPI = WooCommerceAPI(
      url: ConfigService.WC_ENDPOINT,
      consumerKey: ConfigService.WC_CONSUMER_KEY,
      consumerSecret: ConfigService.WC_CONSUMER_SECRET,
    );
  }

  Future getOrdersByUserId({int userId, int offset = 0}) async {
    List<dynamic> orders;

    try {
      String endpoint = "orders?customer=$userId&order=desc&offset=$offset";
      orders = await this._wcAPI.getAsync(endpoint);
    } catch (e) {
      return Future.error(e);
    }
    return Future.value(orders);
  }

  Future getOrderById({int orderId}) async {
    Map order;

    try {
      String endpoint = "orders/$orderId";
      order = await this._wcAPI.getAsync(endpoint);
    } catch (e) {
      return Future.error(e);
    }
    return Future.value(order);
  }
}
