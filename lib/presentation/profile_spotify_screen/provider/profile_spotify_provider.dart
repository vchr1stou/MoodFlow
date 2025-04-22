import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_spotify_model.dart';

/// A provider class for the ProfileSpotifyScreen.
///
/// This provider manages the state of the ProfileSpotifyScreen,
/// including the current profileSpotifyModelObj.
// ignore_for_file: must_be_immutable
class ProfileSpotifyProvider extends ChangeNotifier {
  ProfileSpotifyModel profileSpotifyModelObj = ProfileSpotifyModel();

  @override
  void dispose() {
    super.dispose();
  }
}
