import 'package:flutter/cupertino.dart';

class ConstantService {
  /// ==========================================================================
  /// Http
  /// ==========================================================================
  // General
  static const int httpTimeout = 10;

  // HTTP codes
  static const int httpOkCode = 200;
  static const int httpNotFoundCode = 404;
  static const int httpServerErrorCode = 503;

  // HTTP messages
  static const String httpErrorMessage = 'HTTP Error';
  static const String httpNotFoundMessage = 'Not Found Error';
  static const String httpServerErrorMessage = 'Internal Server Error';

  /// ==========================================================================
  /// Exceptions
  /// ==========================================================================
  // Exceptions Codes
  static const String timeoutExceptionCode = 'TIMEOUT_EXCEPTION';
  static const String nullExceptionCode = 'NULL_EXCEPTION';
  static const String databaseExceptionCode = 'DATABASE_EXCEPTION';

  // Exception Messages
  static const String timeoutExceptionMessage = 'Timeout exception';
  static const String nullExceptionMessage = 'Null exception';

  /// ============================================================================
  /// Colors
  /// ============================================================================
  static const Color kCustomPrimaryColor = Color(0xFF8D2789);
  static const Color kCustomSecondaryColor = Color(0xFFFFD817);
  static const Color kCustomGrayColor = Color(0xFFE7E7E7);
  static const Color kCustomStrongGrayColor = Color(0xFF575756);
  static const Color kCustomWhiteColor = Color(0xFFFFFFFF);
  static const Color kCustomBlackColor = Color(0xFF000000);
  static const Color kCustomGrayTextColor = Color(0xFF6C6C6B);

  /// ==========================================================================
  /// Placeholders
  /// ==========================================================================
  static const String kCustomPlaceholderImage = 'assets/placeholder.png';
  static const String kCustomDiscountImage = 'assets/discount.png';

  /// ==========================================================================
  /// Strings
  /// ==========================================================================
  static const String kCustomRecommendedText = 'Recomendados';
  static const String kCustomViewAllText = 'Ver Todos';
  static const String kCustomOnOfferedText = '¡ Ofertas !';
  static const String kCustomCategoryText = 'Mostradores';
  static const String kCustomNeighborhoodText = 'Barrio El Limonar';
  static const String kCustomAddressText = 'Calle 6a # 16 109';
  static const String kCustomAddToCartText = 'Agregar';
  static const String kCustomDetailText = 'Detalle';
  static const String kCustomYouAreSavingText = 'Estás ahorrando';
  static const String kCustomNoProductDescriptionText =
      'No existe detalle para el producto';
  static const kCustomChangeCounter = 'Cambiar mostrador';
  static const kCustomOthersCounter = 'Otros';
  static const String kCustomNoProductAvailableDescriptionText =
      'Este producto no se encuentra disponible';
}
