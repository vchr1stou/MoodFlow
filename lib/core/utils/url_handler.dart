import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import '../app_export.dart';
import '../../presentation/sign_up_step_four_screen/provider/sign_up_step_four_provider.dart';
import '../global_keys.dart';
import '../../services/spotify_service.dart';

class UrlHandler {
  static String? _pendingCode;
  static bool _isInitialized = false;
  static int _retryCount = 0;
  static const int _maxRetries = 5;
  static final SpotifyService _spotifyService = SpotifyService();

  static void init() {
    if (_isInitialized) return;
    _isInitialized = true;
    
    debugPrint('=== Initializing URL Handler ===');
    
    // Handle the initial link when the app is opened from a cold start
    getInitialUri().then((Uri? uri) {
      if (uri != null) {
        debugPrint('=== Handling initial URI ===');
        _handleUri(uri);
      }
    }).catchError((e) {
      debugPrint('=== Error getting initial URI ===');
      debugPrint('Error details: $e');
    });

    // Listen for incoming links when the app is in the background
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('=== Handling incoming URI ===');
        _handleUri(uri);
      }
    }, onError: (e) {
      debugPrint('=== Error listening to URI stream ===');
      debugPrint('Error details: $e');
    });

    // Listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());
  }

  static void _handleUri(Uri uri) {
    debugPrint('=== Handling URI ===');
    debugPrint('URI: $uri');
    
    if (uri.scheme == 'moodflow') {
      if (uri.host == 'spotify-callback') {
        _handleSpotifyCallback(uri);
      }
    } else if (uri.scheme == 'https' && uri.host == 'moodflow-1390a.firebaseapp.com' && uri.path == '/spotify-callback') {
      _handleSpotifyCallback(uri);
    }
  }

  static void _handleSpotifyCallback(Uri uri) async {
    debugPrint('=== Handling Spotify callback ===');
    final code = uri.queryParameters['code'];
    debugPrint('Authorization code: $code');
    
    if (code == null) {
      debugPrint('=== No authorization code found ===');
      return;
    }

    // Store the code for later use if needed
    _pendingCode = code;
    _retryCount = 0; // Reset retry count
    _tryHandleCallback();
  }

  static void _tryHandleCallback() async {
    if (_pendingCode == null) return;

    // Check if we've exceeded max retries
    if (_retryCount >= _maxRetries) {
      debugPrint('=== Max retries exceeded, giving up ===');
      _pendingCode = null;
      return;
    }

    _retryCount++;
    debugPrint('=== Attempting callback handling (attempt $_retryCount of $_maxRetries) ===');

    try {
      // Wait a bit for the navigator to be ready
      await Future.delayed(Duration(milliseconds: 2000));

      // Get the current context from the root navigator key
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        debugPrint('=== No context available, will retry when app becomes active ===');
        return;
      }
      debugPrint('=== Found context from root navigator ===');

      // First try to find the provider in the current context
      SignUpStepFourProvider? provider;
      try {
        provider = Provider.of<SignUpStepFourProvider>(context, listen: false);
        debugPrint('=== Found provider in current context ===');
        debugPrint('Provider state:');
        debugPrint('- isAuthenticated: ${provider.isAuthenticated}');
        debugPrint('- userEmail: ${provider.userEmail}');
      } catch (e) {
        debugPrint('=== Provider not found in current context ===');
        debugPrint('Error details: $e');
        debugPrint('Current widget tree:');
        debugPrint(context.widget.toStringDeep());
      }

      if (provider == null) {
        // If provider not found, navigate to sign up screen and try again
        debugPrint('=== Navigating to sign up screen ===');
        await rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.signUpStepFourScreen,
          (route) => false,
        );
        
        // Wait for navigation to complete and try to find provider again
        await Future.delayed(Duration(milliseconds: 2000));
        
        final newContext = rootNavigatorKey.currentContext;
        if (newContext == null) {
          debugPrint('=== No context available after navigation ===');
          return;
        }
        debugPrint('=== Found new context after navigation ===');

        try {
          provider = Provider.of<SignUpStepFourProvider>(newContext, listen: false);
          debugPrint('=== Found provider after navigation ===');
          debugPrint('Provider state:');
          debugPrint('- isAuthenticated: ${provider.isAuthenticated}');
          debugPrint('- userEmail: ${provider.userEmail}');
        } catch (e) {
          debugPrint('=== Failed to find provider after navigation ===');
          debugPrint('Error details: $e');
          debugPrint('New widget tree:');
          debugPrint(newContext.widget.toStringDeep());
          _showError(newContext, 'Failed to authenticate with Spotify: Provider not found');
          return;
        }
      }

      // Handle the callback with the provider
      debugPrint('=== Handling callback with provider ===');
      await provider.handleCallback(_pendingCode!);
      debugPrint('=== Callback handled successfully ===');
      _pendingCode = null; // Clear the pending code after successful handling
      _retryCount = 0; // Reset retry count
    } catch (e) {
      debugPrint('=== Error handling Spotify callback ===');
      debugPrint('Error details: $e');
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        _showError(context, 'Failed to authenticate with Spotify: ${e.toString()}');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('=== App became active, retrying callback handling ===');
      // Add a small delay to ensure the app is fully resumed
      Future.delayed(Duration(milliseconds: 1000), () {
        UrlHandler._tryHandleCallback();
      });
    }
  }
} 