import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/http/http.service.dart';

class ConfigAPIService {
  static Future getConfig() async {
    dynamic config = [];

    try {
      config = await HttpService.get(
          url: 'https://www.mercave.com.co/mobile/config.php');
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
      deliveryDays = await HttpService.get(
        url: 'https://www.mercave.com.co/mobile/fechas_entrega.php',
      );
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
