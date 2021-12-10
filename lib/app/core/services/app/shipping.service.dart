import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/http/http.service.dart';

class ShippingAPIService {
  static Future<bool> updateShippingValue(String postid) async {
    Map<String, dynamic> response;

    try {
      print('PostId: $postid');
      response = await HttpService.get(
          url:
              'https://www.mercave.com.co/mobile/shipping.php?post_id=$postid');
    } catch (e) {
      return Future.error(false);
    }
    print('Response bool:${response}');
    if (response != null) {
      bool val = response['code'] == 0 ? (true) : (false);
      return Future.value(val);
    } else
      return Future.value(false);
  }
}
