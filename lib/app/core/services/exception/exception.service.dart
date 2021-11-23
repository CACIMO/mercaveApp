import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mercave/app/shared/constants/constant.service.dart';

class ExceptionService {
  static PlatformException timeoutException({int seconds}) {
    return PlatformException(
      code: ConstantService.timeoutExceptionCode,
      message: TimeoutException(
        ConstantService.timeoutExceptionMessage,
        Duration(seconds: seconds),
      ).toString(),
    );
  }

  static PlatformException nullException() {
    return PlatformException(
      code: ConstantService.nullExceptionCode,
      message: ConstantService.nullExceptionMessage,
    );
  }

  static PlatformException httpException({
    int statusCode,
    String message = ConstantService.httpErrorMessage,
    dynamic details,
  }) {
    return PlatformException(
      code: statusCode.toString(),
      message: message,
      details: details,
    );
  }

  static PlatformException databaseException({String message}) {
    return PlatformException(
      code: ConstantService.databaseExceptionCode,
      message: message,
    );
  }
}
