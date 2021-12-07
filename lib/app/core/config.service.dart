class ConfigService {
  /// ==========================================================================
  /// Database config
  /// ==========================================================================
  static const DATABASE_NAME = 'MercaVeDB_20200112_1945.db';

  /// ==========================================================================
  /// Woo-commerce Config
  /// ==========================================================================
  static const WC_ENDPOINT = 'https://www.mercave.com.co/';
  static const WC_OWN_ENDPOINT = 'http://www.mercave.com.co/mobile/wc_api/';
  static const WC_CONSUMER_KEY = 'ck_c0b240598bd6ffa050546dbc98b832afbe5fb833';
  static const WC_CONSUMER_SECRET =
      'cs_410fc4a600fb2039e050e86ba01591c8a0013bcd';

  /// ==========================================================================
  /// App URL: iOS & Android
  /// ==========================================================================
  static const String APP_STORE_URL =
      'https://apps.apple.com/us/app/merca-v%C3%A9/id1500663698?l=es&ls=1';
  static const String PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.etrivinos.mercave&hl=es_419';

  static const bool USE_OWN_WOOCOMMERCE_API = true;
}
