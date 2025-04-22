import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/discover_model.dart';

/// A provider class for the DiscoverScreen.
///
/// This provider manages the state of the DiscoverScreen, including the
/// current discoverModelObj

// ignore_for_file: must_be_immutable
class DiscoverProvider extends ChangeNotifier {
  DiscoverModel discoverModelObj = DiscoverModel();

  @override
  void dispose() {
    super.dispose();
  }
}
