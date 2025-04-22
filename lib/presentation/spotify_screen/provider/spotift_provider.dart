import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/spotify_model.dart';

/// A provider class for the SpotifyScreen.
///
/// This provider manages the state of the SpotifyScreen, including the
/// current spotifyModelObj

// ignore_for_file: must_be_immutable
class SpotifyProvider extends ChangeNotifier {
  SpotifyModel spotifyModelObj = SpotifyModel();

  @override
  void dispose() {
    super.dispose();
  }
}
