import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/app_export.dart';
import '../../../services/spotify_service.dart';
import '../models/sign_up_step_four_model.dart';
import 'package:provider/provider.dart';

/// A provider class for the SignUpStepFourScreen.
///
/// This provider manages the state of the SignUpStepFourScreen,
/// including the current signUpStepFourModelObj.
// ignore_for_file: must_be_immutable
class SignUpStepFourProvider extends ChangeNotifier {
  SignUpStepFourModel signUpStepFourModelObj = SignUpStepFourModel();
  final SpotifyService _spotifyService = SpotifyService();
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _error;
  bool _isLoading = false;
  String? _accessToken;
  Map<String, dynamic>? _userProfile;
  String? _spotifyToken;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get error => _error;
  bool get isLoading => _isLoading;
  String? get spotifyToken => _spotifyToken;

  Future<void> loginWithSpotify() async {
    try {
      const clientId = '826c83b9cc66470b98e91492884bab68';
      const redirectUri = 'moodflow://spotify-callback';
      const scope = 'user-read-private user-read-email';
      
      final spotifyAuthUrl = Uri.https('accounts.spotify.com', '/authorize', {
        'client_id': clientId,
        'response_type': 'code',
        'redirect_uri': redirectUri,
        'scope': scope,
      });
      
      if (await canLaunchUrl(spotifyAuthUrl)) {
        await launchUrl(spotifyAuthUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Spotify authentication');
      }
    } catch (e) {
      debugPrint('Error launching Spotify authentication: $e');
      rethrow;
    }
  }

  void setSpotifyToken(String token) {
    _spotifyToken = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> handleCallback(String code) async {
    try {
      debugPrint('=== Handling Spotify callback ===');
      debugPrint('Code: $code');

      // Get access token
      _accessToken = await _spotifyService.getAccessToken(code);
      debugPrint('=== Got access token ===');

      // Get user profile
      final userProfile = await _spotifyService.getUserProfile(_accessToken!);
      debugPrint('=== Got user profile ===');
      debugPrint('User profile: $userProfile');

      // Update state
      _isAuthenticated = true;
      _userEmail = userProfile['email'] as String;
      _userProfile = userProfile;
      
      // Force UI updates
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 100));
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 100));
      notifyListeners();

      debugPrint('=== Successfully handled callback ===');
      debugPrint('User email: $_userEmail');
      debugPrint('Is authenticated: $_isAuthenticated');
    } catch (e) {
      debugPrint('=== Error handling callback ===');
      debugPrint('Error details: $e');
      _isAuthenticated = false;
      _userEmail = null;
      _userProfile = null;
      _accessToken = null;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    debugPrint('=== Disposing SignUpStepFourProvider ===');
    debugPrint('Final auth state: $_isAuthenticated');
    debugPrint('Final email: $_userEmail');
    super.dispose();
  }
}
