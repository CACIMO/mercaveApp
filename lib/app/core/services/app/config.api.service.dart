import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/http/http.service.dart';

class ConfigAPIService {
  static Future getConfig() async {
    dynamic config = [];

    try {
      config = await HttpService.get(url: 'mobile/config.php', http: true);
    } catch (e) {
      return Future.error(
        ExceptionService.httpException(
          statusCode: -1,
          message: e.message,
        ),
      );
    }

    return Future.value(config);
  }

  static Future getDeliveryDays() async {
    dynamic deliveryDays = [];

    try {
      print('object');
      deliveryDays =
          await HttpService.get(url: 'mobile/fechas_entrega.php', http: true);
    } catch (e) {
      return Future.error(
        ExceptionService.httpException(
          statusCode: -1,
          message: e.message,
        ),
      );
    }

    return Future.value(deliveryDays);
  }
}
