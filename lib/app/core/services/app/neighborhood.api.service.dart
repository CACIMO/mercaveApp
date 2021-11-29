import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/http/http.service.dart';

class NeighborhoodAPIService {
  static Future getNeighborhoods() async {
    dynamic neighborhoods = [];

    try {
      neighborhoods = await HttpService.get(
          url: 'https://www.mercave.com.co/mobile/barrios.php');
    } catch (e) {
      return Future.error(
        ExceptionService.httpException(
          statusCode: -1,
          message: e.message,
        ),
      );
    }

    return Future.value(neighborhoods);
  }
}
