import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/spotify_config.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class SpotifyService {
  static const String clientId = '826c83b9cc66470b98e91492884bab68';
  static const String redirectUri = 'moodflow://spotify-callback';
  static const String scope = 'user-read-email user-read-private';

  Future<void> loginWithSpotify() async {
    debugPrint('=== Starting Spotify login ===');
    
    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'scope': scope,
      'show_dialog': 'true',
    });

    debugPrint('=== Launching Spotify auth URL ===');
    debugPrint('URL: $authUrl');

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      debugPrint('=== Successfully launched Spotify login ===');
    } else {
      debugPrint('=== Failed to launch Spotify login ===');
      throw Exception('Could not launch Spotify login');
    }
  }

  Future<String> getAccessToken(String code) async {
    debugPrint('=== Getting access token ===');
    
    try {
      final response = await http.get(
        Uri.https('us-central1-moodflow-1390a.cloudfunctions.net', '/exchangeSpotifyCode', {
          'code': code,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('=== Successfully got access token ===');
        return data['access_token'];
      } else {
        debugPrint('=== Failed to get access token ===');
        debugPrint('Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      debugPrint('=== Error getting access token ===');
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String accessToken) async {
    debugPrint('=== Getting user profile ===');
    
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('=== Successfully got user profile ===');
      return data;
    } else {
      debugPrint('=== Failed to get user profile ===');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
      throw Exception('Failed to get user profile');
    }
  }
} 