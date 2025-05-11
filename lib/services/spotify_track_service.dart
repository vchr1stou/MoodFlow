import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/spotify_config.dart';

class SpotifyTrackService {
  static const String _baseUrl = 'https://api.spotify.com/v1';
  String? _accessToken;

  Future<void> _getAccessToken() async {
    try {
      debugPrint('=== Getting Spotify access token ===');
      final authString = '${SpotifyConfig.clientId}:${SpotifyConfig.clientSecret}';
      final base64Auth = base64Encode(utf8.encode(authString));
      debugPrint('Auth string: $authString');
      debugPrint('Base64 auth: $base64Auth');

      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic $base64Auth',
        },
        body: {
          'grant_type': 'client_credentials',
        },
      );

      debugPrint('Token response status: ${response.statusCode}');
      debugPrint('Token response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        debugPrint('Successfully got access token: ${_accessToken?.substring(0, 10)}...');
      } else {
        debugPrint('Error getting token: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to get Spotify access token: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting token: $e');
      throw Exception('Failed to get Spotify access token: $e');
    }
  }

  Future<Map<String, dynamic>> searchTrack(String query) async {
    if (_accessToken == null) {
      await _getAccessToken();
    }

    try {
      debugPrint('=== Searching track: $query ===');
      final response = await http.get(
        Uri.parse('$_baseUrl/search?q=$query&type=track&limit=1'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      debugPrint('Search response status: ${response.statusCode}');
      debugPrint('Search response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['tracks']['items'].isNotEmpty) {
          final track = data['tracks']['items'][0];
          return {
            'id': track['id'],
            'name': track['name'],
            'artists': track['artists'].map((artist) => artist['name']).join(', '),
            'album': track['album']['name'],
            'albumArtUrl': track['album']['images'][0]['url'],
            'spotifyUrl': track['external_urls']['spotify'],
          };
        }
      } else if (response.statusCode == 401) {
        debugPrint('Token expired, getting new token...');
        await _getAccessToken();
        return searchTrack(query);
      }
      throw Exception('No track found: ${response.body}');
    } catch (e) {
      debugPrint('Error searching track: $e');
      throw Exception('Failed to search track: $e');
    }
  }

  Future<Map<String, dynamic>> getTrackInfo(String spotifyUrl) async {
    try {
      debugPrint('=== Getting track info for URL: $spotifyUrl ===');
      // Extract track ID from Spotify URL
      final trackId = spotifyUrl.split('/track/')[1].split('?')[0];
      debugPrint('Extracted track ID: $trackId');
      
      if (_accessToken == null) {
        await _getAccessToken();
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/tracks/$trackId'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      debugPrint('Track info response status: ${response.statusCode}');
      debugPrint('Track info response body: ${response.body}');

      if (response.statusCode == 200) {
        final track = json.decode(response.body);
        return {
          'id': track['id'],
          'name': track['name'],
          'artists': track['artists'].map((artist) => artist['name']).join(', '),
          'album': track['album']['name'],
          'albumArtUrl': track['album']['images'][0]['url'],
          'spotifyUrl': track['external_urls']['spotify'],
        };
      } else if (response.statusCode == 401) {
        debugPrint('Token expired, getting new token...');
        await _getAccessToken();
        return getTrackInfo(spotifyUrl);
      }
      throw Exception('Failed to get track info: ${response.body}');
    } catch (e) {
      debugPrint('Error getting track info: $e');
      throw Exception('Failed to get track info: $e');
    }
  }
} 