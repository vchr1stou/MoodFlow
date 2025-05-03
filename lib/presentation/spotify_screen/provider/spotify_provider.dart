import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../services/spotify_service.dart';
import '../models/spotify_model.dart';

class SpotifyProvider extends ChangeNotifier {
  SpotifyModel spotifyModelObj = SpotifyModel();
  final SpotifyService _spotifyService = SpotifyService();
  bool _isLoading = false;
  String? _accessToken;
  Map<String, dynamic>? _userProfile;

  bool get isLoading => _isLoading;
  String? get accessToken => _accessToken;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _accessToken != null;

  Future<void> loginWithSpotify() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _spotifyService.loginWithSpotify();
    } catch (e) {
      debugPrint('Spotify login error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleCallback(String code) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _accessToken = await _spotifyService.getAccessToken(code);
      _userProfile = await _spotifyService.getUserProfile(_accessToken!);
      
      // Save tokens and user info to your preferred storage
      // For example, using SharedPreferences or Firebase
    } catch (e) {
      debugPrint('Spotify callback error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    _userProfile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
} 