import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mercave/app/core/models/coupon_model.dart';
import 'package:mercave/app/core/models/redeemable_coupon_model.dart';

class CouponService {
  CouponService._();
  factory CouponService() => _instance;
  static final _instance = CouponService._();
  static const _baseUrl = 'wp-json';
  static const _domain = "mercave.com.co";

  Future<List<CouponModel>> requestUserCoupons(int userId) async {
    final url = '$_baseUrl/getcupones/v1/user/$userId';
    final response = await http.get(Uri.https(_domain, url));
    final List body = json.decode(response.body);
    final coupons = body.map((e) => CouponModel.fromMap(e)).toList();
    return coupons;
  }

  Future<RedeemableCouponModel> requestCouponData(
    int userId,
    String couponCode,
  ) async {
    final url = '$_baseUrl/getcupones/v2/user/$userId?cupon=$couponCode';
    final response = await http.get(Uri.https(_domain, url));
    final Map body = json.decode(response.body);
    if (response.statusCode == 200) {
      return RedeemableCouponModel.fromMap(body);
    } else if (body['message'] != null) {
      throw body['message'];
    } else {
      throw response.reasonPhrase;
    }
  }
}
