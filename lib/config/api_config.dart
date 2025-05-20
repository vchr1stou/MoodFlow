import '../services/remote_config_service.dart';

class ApiConfig {
  static final RemoteConfigService _remoteConfig = RemoteConfigService();

  static String get geminiApiKey => _remoteConfig.getGeminiApiKey();
  static String get googleApiKey => _remoteConfig.getGoogleApiKey();
  static String get searchEngineId => _remoteConfig.getSearchEngineId();
  static String get googleMapsApiKey => _remoteConfig.getGoogleMapsApiKey();
} 