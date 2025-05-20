import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.fetchAndActivate();
  }

  // Spotify
  String getSpotifyClientId() {
    return _remoteConfig.getString('spotify_client_id');
  }

  String getSpotifyClientSecret() {
    return _remoteConfig.getString('spotify_client_secret');
  }

  // YouTube
  String getYoutubeApiKey() {
    return _remoteConfig.getString('youtube_api_key');
  }

  // Unsplash
  String getUnsplashApiKey() {
    return _remoteConfig.getString('unsplash_api_key');
  }

  // TMDB (Movies)
  String getTmdbApiKey() {
    return _remoteConfig.getString('tmdb_api_key');
  }

  // Gemini
  String getGeminiApiKey() {
    return _remoteConfig.getString('gemini_api_key');
  }

  // Google
  String getGoogleApiKey() {
    return _remoteConfig.getString('google_api_key');
  }

  // Google Custom Search
  String getSearchEngineId() {
    return _remoteConfig.getString('search_engine_id');
  }

  // Google Maps
  String getGoogleMapsApiKey() {
    return _remoteConfig.getString('google_maps_api_key');
  }
} 