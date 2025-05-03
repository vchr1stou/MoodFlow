import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/spotify_service.dart';
import '../sign_up_step_four_screen/provider/sign_up_step_four_provider.dart';

class SpotifyCallbackScreen extends StatefulWidget {
  const SpotifyCallbackScreen({Key? key}) : super(key: key);

  @override
  State<SpotifyCallbackScreen> createState() => _SpotifyCallbackScreenState();
}

class _SpotifyCallbackScreenState extends State<SpotifyCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    try {
      debugPrint('=== Handling Spotify callback ===');
      final uri = Uri.base;
      debugPrint('Received URI: $uri');
      final code = uri.queryParameters['code'];
      debugPrint('Extracted code: $code');
      
      if (code != null) {
        debugPrint('=== Found authorization code ===');
        final provider = Provider.of<SignUpStepFourProvider>(context, listen: false);
        await provider.handleCallback(code);
        debugPrint('=== Successfully handled callback ===');
        
        if (mounted) {
          Navigator.of(context).pop(); // Go back to the previous screen
        }
      } else {
        debugPrint('=== No authorization code found ===');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to authenticate with Spotify: No authorization code received'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      debugPrint('=== Error handling Spotify callback ===');
      debugPrint('Error details: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to authenticate with Spotify: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Completing Spotify authentication...'),
          ],
        ),
      ),
    );
  }
} 