import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/app_export.dart';
import '../../core/services/storage_service.dart';

class SpotifyMusicSelectionScreen extends StatefulWidget {
  const SpotifyMusicSelectionScreen({Key? key}) : super(key: key);

  @override
  SpotifyMusicSelectionScreenState createState() => SpotifyMusicSelectionScreenState();

  static Widget builder(BuildContext context) {
    return SpotifyMusicSelectionScreen();
  }
}

class SpotifyMusicSelectionScreenState extends State<SpotifyMusicSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  List<dynamic> _recommendedTracks = [];
  bool _isLoading = false;
  String? _selectedTrackId;
  String? _accessToken;
  String? _errorMessage;

  // Replace these with your Spotify API credentials
  static const String _clientId = '826c83b9cc66470b98e91492884bab68';
  static const String _clientSecret = '95bed038b55d4a519d328c4dfe032ce0';

  @override
  void initState() {
    super.initState();
    _getSpotifyToken();
  }

  Future<void> _getSpotifyToken() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _accessToken = data['access_token'];
          _isLoading = false;
        });
        _loadRecommendedTracks();
      } else {
        print('Error getting token: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _errorMessage = 'Failed to connect to Spotify. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error getting token: $e');
      setState(() {
        _errorMessage = 'Network error. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecommendedTracks() async {
    if (_accessToken == null) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _recommendedTracks = data['tracks'];
          _isLoading = false;
        });
      } else {
        print('Error loading tracks: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _errorMessage = 'Failed to load tracks. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading tracks: $e');
      setState(() {
        _errorMessage = 'Network error. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchTracks(String query) async {
    if (query.isEmpty || _accessToken == null) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track&limit=10'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data['tracks']['items'];
          _isLoading = false;
        });
      } else {
        print('Error searching tracks: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _errorMessage = 'Failed to search tracks. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error searching tracks: $e');
      setState(() {
        _errorMessage = 'Network error. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Widget _buildTrackItem(dynamic track) {
    final imageUrl = track['album']['images'].isNotEmpty
        ? track['album']['images'][0]['url']
        : null;
    final title = track['name'];
    final artist = track['artists'][0]['name'];
    final isSelected = track['id'] == _selectedTrackId;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedTrackId = track['id']);
        // Save the selected track
        StorageService.saveSelectedTrack({
          'id': track['id'],
          'name': track['name'],
          'artist': track['artists'][0]['name'],
          'imageUrl': imageUrl,
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
            width: 1.h,
          ),
        ),
        child: Row(
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.h),
                child: Image.network(
                  imageUrl,
                  width: 60.h,
                  height: 60.h,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24.h,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Color(0xFFBCBCBC).withOpacity(0.04),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFBCBCBC).withOpacity(0.04),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 40.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Select a Track",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 16.h),
                // Search bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24.h),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.h,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search for a song...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        ),
                        onChanged: _searchTracks,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Results
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: Colors.white))
                      : _errorMessage != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  TextButton(
                                    onPressed: _getSpotifyToken,
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _searchController.text.isEmpty
                              ? ListView.builder(
                                  itemCount: _recommendedTracks.length,
                                  itemBuilder: (context, index) => _buildTrackItem(_recommendedTracks[index]),
                                )
                              : ListView.builder(
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) => _buildTrackItem(_searchResults[index]),
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 