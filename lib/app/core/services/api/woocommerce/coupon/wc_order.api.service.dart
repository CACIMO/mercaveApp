import 'package:mercave/app/core/config.service.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class WCCouponAPIService {
  WooCommerceAPI _wcAPI;

  WCCouponAPIService() {
    this._wcAPI = WooCommerceAPI(
      url: "https://${ConfigService.WC_ENDPOINT}",
      consumerKey: ConfigService.WC_CONSUMER_KEY,
      consumerSecret: ConfigService.WC_CONSUMER_SECRET,
    );
  }

  Future getCouponByCode({String code}) async {
    List<dynamic> coupons;
    Map coupon;

    try {
      String endpoint = "coupons/?code=$code";
      coupons = await this._wcAPI.getAsync(endpoint);

      if (coupons.length == 1) coupon = coupons[0];
    } catch (e) {
      return Future.error(e);
    }
    return Future.value(coupon);
  }
}
