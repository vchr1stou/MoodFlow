import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart' as ui;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../log_input_screen/log_input_screen.dart';
import '../log_input_colors_screen/log_input_colors_screen.dart';
import '../emoji_log_one_screen/emoji_log_one_screen.dart';
import '../emoji_log_two_screen/emoji_log_two_screen.dart';
import '../emoji_log_three_screen/emoji_log_three_screen.dart';
import '../emoji_log_four_screen/emoji_log_four_screen.dart';
import '../emoji_log_five_screen/emoji_log_five_screen.dart';
import '../log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';
import '../ai_screen_text/ai_screen_text.dart';

import 'models/log_model.dart';
import 'models/log_screen_one_item_model.dart';
import 'provider/log_provider.dart';
import 'widgets/log_screen_one_item_widget.dart';
import '../../core/services/storage_service.dart';

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
    );
  }
}

class LogScreen extends StatefulWidget {
  final String source;
  final String emojiSource;
  final String feeling;

  const LogScreen({
    Key? key,
    required this.source,
    required this.emojiSource,
    required this.feeling,
  }) : super(key: key);

  @override
  LogScreenState createState() => LogScreenState();

  static Widget builder(BuildContext context, {required String source, String emojiSource = 'emoji_one', String feeling = ''}) {
    return LogScreen(source: source, emojiSource: emojiSource, feeling: feeling);
  }
}

class LogScreenState extends State<LogScreen> {
  late DateTime _selectedDate;
  Set<String> toggledIcons = {};
  List<Contact> selectedContacts = [];
  String? selectedLocation;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  double nextButtonTop = 229.h + 10.h + 30.h + 10.h + 76.h + 10.h + 30.h + 10.h + 76.h + 18.h;
  double nextTextTop = 0.h;
  Position? _currentPosition;
  String? _currentAddress;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String? _locationName;
  Uint8List? _mapScreenshot;
  final String _placesApiKey = 'AIzaSyABz9tCdUz29okHDMNQYEMX-LuvNUtjZZw';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  String? _currentMood;
  String? _moodSource;

  @override
  void initState() {
    super.initState();
    print('🚀 LogScreen: Initializing with feeling: ${widget.feeling}');
    print('🚀 LogScreen: Initializing with emojiSource: ${widget.emojiSource}');
    print('🚀 LogScreen: Current saved mood: ${StorageService.getCurrentMood()}');
    print('🚀 LogScreen: Current saved source: ${StorageService.getMoodSource()}');
    
    _selectedDate = DateTime.now();
    _requestContactPermission();
    _loadSavedData(); // Load saved contacts
    _saveCurrentMood(); // Save the initial mood and timestamp
    
    print('✅ LogScreen: Initialization complete');
  }

  Future<void> _saveCurrentMood() async {
    print('📝 LogScreen: Starting _saveCurrentMood');
    print('📝 LogScreen: Widget feeling: ${widget.feeling}');
    print('📝 LogScreen: Widget emojiSource: ${widget.emojiSource}');
    print('📝 LogScreen: Current saved mood: ${StorageService.getCurrentMood()}');
    print('📝 LogScreen: Current saved source: ${StorageService.getMoodSource()}');
    
    // Always save the current mood and source
    print('💾 LogScreen: Saving current mood and source');
    await StorageService.saveCurrentMood(widget.feeling, widget.emojiSource);
    await StorageService.saveSelectedDateTime(_selectedDate);
    
    // Store the current mood and timestamp in static variables for direct access
    _currentMood = widget.feeling;
    _moodSource = widget.emojiSource;
    
    print('✅ LogScreen: Mood saved successfully');
    print('✅ LogScreen: New saved mood: ${StorageService.getCurrentMood()}');
    print('✅ LogScreen: New saved source: ${StorageService.getMoodSource()}');
  }

  Future<void> _requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact permission is required to add people')),
      );
    }
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to enable location services
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFBCBCBC).withOpacity(0.04),
            title: Text(
              'Location Services Disabled',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Please enable location services to use this feature.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openLocationSettings();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFBCBCBC).withOpacity(0.04),
              title: Text(
                'Location Permission Required',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Please grant location permission to use this feature.',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(
                    'Open Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Geolocator.openAppSettings();
                  },
                ),
              ],
            );
          },
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFBCBCBC).withOpacity(0.04),
            title: Text(
              'Location Permission Permanently Denied',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Please enable location permission in app settings to use this feature.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('Getting current location...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Got position: ${position.latitude}, ${position.longitude}');
      
      // Only set current location if no markers exist (no selected location)
      if (_markers.isEmpty) {
        setState(() {
          _currentPosition = position;
          _markers.add(
            Marker(
              markerId: MarkerId('current_location'),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: InfoWindow(title: 'Current Location'),
            ),
          );
        });
        
        // Save coordinates only if no location was previously selected
        await StorageService.saveLocationCoordinates(position.latitude, position.longitude);
      }
      
      if (_mapController != null && _markers.isNotEmpty) {
        print('Animating camera to position');
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _markers.first.position,
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _showLocationPicker() async {
    // Request location permission when opening the picker
    final permissionGranted = await _requestLocationPermission();
    if (!permissionGranted) {
      return;
    }

    // Get current location when opening the picker
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
      return;
    }

    // Reset location state only if no location was previously selected
    if (_markers.isEmpty) {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
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
                    "Select Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Search Box
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
                        child: TypeAheadField<PlacePrediction>(
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search for a place...',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.h),
                                isDense: true,
                              ),
                            );
                          },
                          suggestionsCallback: (String pattern) async {
                            if (pattern.length >= 3) {
                              return await _getPlaces(pattern);
                            }
                            return [];
                          },
                          itemBuilder: (context, PlacePrediction prediction) {
                            return ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1.h,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    title: Text(
                                      prediction.description,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.h,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.h,
                                      vertical: 8.h,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          decorationBuilder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16.h),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(16.h),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 1.h,
                                    ),
                                  ),
                                  child: child,
                                ),
                              ),
                            );
                          },
                          hideOnEmpty: true,
                          hideOnLoading: true,
                          onSelected: (PlacePrediction prediction) async {
                            _searchController.text = prediction.description;
                            final placeDetails = await _getPlaceDetails(prediction.placeId);
                            if (placeDetails != null) {
                              final location = placeDetails['geometry']['location'];
                              if (location != null) {
                                setState(() {
                                  _markers.clear();
                                  _markers.add(
                                    Marker(
                                      markerId: MarkerId('selected_location'),
                                      position: LatLng(location['lat'] ?? 0, location['lng'] ?? 0),
                                      infoWindow: InfoWindow(title: prediction.description),
                                    ),
                                  );
                                  _locationName = prediction.description;
                                });
                                // Save the selected location coordinates
                                await StorageService.saveLocationCoordinates(location['lat'], location['lng']);
                                await StorageService.saveSelectedLocation(prediction.description);
                                
                                if (_mapController != null) {
                                  _mapController!.animateCamera(
                                    CameraUpdate.newLatLng(
                                      LatLng(location['lat'] ?? 0, location['lng'] ?? 0),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Enter Location Name input
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
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter location name',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.h),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _locationName = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Make the map bigger
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.h,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.h),
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                  zoom: 15,
                                ),
                                markers: _markers,
                                onMapCreated: (GoogleMapController controller) {
                                  print('Map created successfully');
                                  _mapController = controller;
                                  try {
                                    controller.setMapStyle('''
                                      [
                                        {
                                          "elementType": "geometry",
                                          "stylers": [
                                            {
                                              "color": "#242f3e"
                                            }
                                          ]
                                        },
                                        {
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#746855"
                                            }
                                          ]
                                        },
                                        {
                                          "elementType": "labels.text.stroke",
                                          "stylers": [
                                            {
                                              "color": "#242f3e"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "administrative.locality",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#d59563"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "poi",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#d59563"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "poi.park",
                                          "elementType": "geometry",
                                          "stylers": [
                                            {
                                              "color": "#263c3f"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "poi.park",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#6b9a76"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "road",
                                          "elementType": "geometry",
                                          "stylers": [
                                            {
                                              "color": "#38414e"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "road",
                                          "elementType": "geometry.stroke",
                                          "stylers": [
                                            {
                                              "color": "#212a37"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "road",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#9ca5b3"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "road.highway",
                                          "elementType": "geometry",
                                          "stylers": [
                                            {
                                              "color": "#746855"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "road.highway",
                                          "elementType": "geometry.stroke",
                                          "stylers": [
                                            {
                                              "color": "#1f2835"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "road.highway",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#f3d19c"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "transit",
                                          "elementType": "geometry",
                                          "stylers": [
                                            {
                                              "color": "#2f3948"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "transit.station",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#d59563"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "water",
                                          "elementType": "geometry",
                                          "stylers": [
                                            {
                                              "color": "#17263c"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "water",
                                          "elementType": "labels.text.fill",
                                          "stylers": [
                                            {
                                              "color": "#515c6d"
                                            }
                                          ]
                                        },
                                        {
                                          "featureType": "water",
                                          "elementType": "labels.text.stroke",
                                          "stylers": [
                                            {
                                              "color": "#17263c"
                                            }
                                          ]
                                        }
                                      ]
                                    ''');
                                    print('Map style set successfully');
                                  } catch (e) {
                                    print('Error setting map style: $e');
                                  }
                                },
                                onTap: (LatLng position) {
                                  print('Map tapped at: ${position.latitude}, ${position.longitude}');
                                  setState(() {
                                    _markers.clear();
                                    _markers.add(
                                      Marker(
                                        markerId: MarkerId('selected_location'),
                                        position: position,
                                        infoWindow: InfoWindow(title: 'Selected Location'),
                                      ),
                                    );
                                  });
                                  // Save coordinates
                                  StorageService.saveLocationCoordinates(position.latitude, position.longitude);
                                },
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                zoomControlsEnabled: true,
                                mapType: MapType.normal,
                                compassEnabled: true,
                                rotateGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                              ),
                            ),
                            if (_currentPosition == null)
                              Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_markers.isNotEmpty) {
                              final selectedMarker = _markers.first;
                              // Generate Google Maps link
                              final mapsLink = 'https://www.google.com/maps/search/?api=1&query=${selectedMarker.position.latitude},${selectedMarker.position.longitude}';
                              print('Generated maps link: $mapsLink');
                              
                              // Save the selected location before closing
                              print('Saving location coordinates: ${selectedMarker.position.latitude}, ${selectedMarker.position.longitude}');
                              await StorageService.saveLocationCoordinates(
                                selectedMarker.position.latitude,
                                selectedMarker.position.longitude
                              );
                              
                              // Always save a location name, even if none was entered
                              final locationNameToSave = _locationName ?? 'Selected Location';
                              print('Saving location name: $locationNameToSave');
                              await StorageService.saveSelectedLocation(locationNameToSave);
                              
                              // Save the Google Maps link
                              print('Saving maps link to storage');
                              await StorageService.saveMapsLink(mapsLink);
                              
                              // Verify all location data was saved
                              final savedLink = await StorageService.getMapsLink();
                              final savedLocation = await StorageService.getSelectedLocation();
                              final savedCoords = await StorageService.getLocationCoordinates();
                              print('Verified saved data:');
                              print('- Maps link: $savedLink');
                              print('- Location name: $savedLocation');
                              print('- Coordinates: $savedCoords');
                              
                              // Capture the map area
                              if (_mapController != null) {
                                try {
                                  // Wait for the map to settle
                                  await Future.delayed(Duration(milliseconds: 500));
                                  
                                  // Take the screenshot
                                  final Uint8List? screenshot = await _mapController!.takeSnapshot();
                                  if (screenshot != null) {
                                    setState(() {
                                      _mapScreenshot = screenshot;
                                    });
                                    await StorageService.saveMapScreenshot(screenshot);
                                  }
                                } catch (e) {
                                  print('Error capturing map screenshot: $e');
                                }
                              }

                              // Update the preview map with the selected location
                              setState(() {
                                _markers.clear();
                                _markers.add(
                                  Marker(
                                    markerId: MarkerId('selected_location'),
                                    position: LatLng(
                                      selectedMarker.position.latitude,
                                      selectedMarker.position.longitude
                                    ),
                                    infoWindow: InfoWindow(
                                      title: locationNameToSave
                                    ),
                                  ),
                                );
                              });

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a location on the map')),
                              );
                            }
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickContact() async {
    try {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                        "Select a Contact",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...contacts.map((contact) => GestureDetector(
                                onTap: () {
                                  if (!selectedContacts.any((c) => c.displayName == contact.displayName)) {
                                    setState(() {
                                      selectedContacts.add(contact);
                                    });
                                    _saveSelectedContacts(); // Save contacts after adding
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('This contact is already added')),
                                    );
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.h),
                                  child: Row(
                                    children: [
                                      if (contact.avatar != null)
                                        CircleAvatar(
                                          radius: 20.h,
                                          backgroundImage: MemoryImage(contact.avatar!),
                                        )
                                      else
                                        CircleAvatar(
                                          radius: 20.h,
                                          child: Text(
                                            contact.displayName?.substring(0, 1).toUpperCase() ?? '?',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      SizedBox(width: 16.h),
                                      Text(
                                        contact.displayName ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking contact')),
      );
    }
  }

  void _toggleIcon(String iconName) {
    setState(() {
      if (toggledIcons.contains(iconName)) {
        toggledIcons.remove(iconName);
      } else {
        toggledIcons.add(iconName);
      }
      // Save toggled icons
      StorageService.saveToggledIcons(toggledIcons);
    });
  }

  String _getIconPath(String basePath, String iconName) {
    if (toggledIcons.contains(iconName)) {
      // Special handling for music icon
      if (iconName == 'Music') {
        return 'assets/images/music_2.svg';
      }
      // Replace .svg with _2.svg for other icons
      return basePath.replaceAll('.svg', '_2.svg');
    }
    // Special handling for music icon when not toggled
    if (iconName == 'Music') {
      return 'assets/images/music_log.svg';
    }
    return basePath;
  }

  Widget _buildIconWithText(String iconName, double left, double top, String iconPath, String text) {
    return Positioned(
      left: left,
      top: top,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleIcon(iconName),
            child: SvgPicture.asset(
              _getIconPath(iconPath, iconName),
              width: 43.h,
              height: 42.h,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Background blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color(0xFF808080).withOpacity(0.2),
                ),
              ),
            ),
            // Content
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 87.h),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Mood Captured!",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                height: 30/36,
                                letterSpacing: -2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 23.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/log_1_mood.svg',
                                  width: 267.h,
                                  height: 74.h,
                                ),
                                Positioned(
                                  top: 5.h,
                                  child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: (StorageService.getCurrentMood()?.split(' ').first ?? widget.feeling.split(' ').first) + '\u2009',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: StorageService.getCurrentMood()?.split(' ').last ?? widget.feeling.split(' ').last,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 29,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Transform.translate(
                                        offset: Offset(-4.h, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () => _selectDate(context),
                                              child: Text(
                                                _getFormattedDateTime(),
                                                style: TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.08,
                                                  height: 16/13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 1.5.h),
                                            GestureDetector(
                                              onTap: () => _selectDate(context),
                                              child: SvgPicture.asset(
                                                'assets/images/chevron_log.svg',
                                                width: 7.h,
                                                height: 10.92.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 13.h),
                            Text(
                              "What's happening?",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 20/20,
                                color: Colors.white.withOpacity(0.96),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            SizedBox(
                              height: 229.h + 10.h + 30.h + 10.h + 76.h + 10.h + 30.h + 10.h + 76.h + 10.h + 42.h + 15.h,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/box_log_1.svg',
                                    width: 340.h,
                                    height: 229.h,
                                  ),
                                  // First row
                                  _buildIconWithText('Work', 35.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/work.svg', 'Work'),
                                  _buildIconWithText('Family', 36.h + 43.h + 32.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/family.svg', 'Family'),
                                  _buildIconWithText('Study', 36.h + (43.h + 32.h) * 2, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/study.svg', 'Study'),
                                  _buildIconWithText('Relationship', 19.h + (43.h + 32.h) * 3, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/relationship.svg', 'Relationship'),
                                  // Second row
                                  _buildIconWithText('Exercise', 30.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/exercise.svg', 'Exercise'),
                                  _buildIconWithText('Party', 36.h + 43.h + 32.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/party.svg', 'Party'),
                                  _buildIconWithText('Travelling', 27.h + (43.h + 32.h) * 2, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/travelling.svg', 'Travelling'),
                                  _buildIconWithText('Weather', 32.h + (43.h + 32.h) * 3, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/weather.svg', 'Weather'),
                                  // Third row
                                  _buildIconWithText('Music', 35.h, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/music_log.svg', 'Music'),
                                  _buildIconWithText('Hobby', 36.h + 43.h + 32.h, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/hobby.svg', 'Hobby'),
                                  _buildIconWithText('Shopping', 29.h + (43.h + 32.h) * 2, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/shopping.svg', 'Shopping'),
                                  _buildIconWithText('Beauty', 36.h + (43.h + 32.h) * 3, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/beauty.svg', 'Beauty'),
                                  // Text below box
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 229.h + 11.h,
                                    child: Text(
                                      "Who were you with?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // First person log SVG for contacts
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 229.h + 10.h + 30.h + 10.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/person_log.svg',
                                          width: 340.h,
                                          height: 76.h,
                                        ),
                                        if (selectedContacts.isEmpty)
                                          Positioned.fill(
                                            child: Center(
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 500),
                                                curve: Curves.easeInOutCubic,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    AnimatedSwitcher(
                                                      duration: Duration(milliseconds: 500),
                                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                                        return FadeTransition(
                                                          opacity: animation,
                                                          child: ScaleTransition(
                                                            scale: animation,
                                                            child: child,
                                                          ),
                                                        );
                                                      },
                                                      child: Padding(
                                                        key: ValueKey<bool>(true),
                                                        padding: EdgeInsets.symmetric(horizontal: 11.h),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: _pickContact,
                                                              child: SvgPicture.asset(
                                                                'assets/images/plus_log_1.svg',
                                                                width: 35.h,
                                                                height: 34.h,
                                                              ),
                                                            ),
                                                            SizedBox(height: 2.h),
                                                            Text(
                                                              "Add People",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily: 'Roboto',
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          Positioned.fill(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          ...selectedContacts.asMap().entries.map((entry) {
                                                            final index = entry.key;
                                                            final contact = entry.value;
                                                            return Padding(
                                                              padding: EdgeInsets.only(right: 8.h),
                                                              child: Dismissible(
                                                                key: Key(contact.displayName ?? 'contact_$index'),
                                                                direction: DismissDirection.up,
                                                                onDismissed: (direction) {
                                                                  setState(() {
                                                                    selectedContacts.removeAt(index);
                                                                  });
                                                                  _saveSelectedContacts(); // Save contacts after removal
                                                                },
                                                                child: GestureDetector(
                                                                  onTap: () => _onContactSelected(contact),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      if (contact.avatar != null)
                                                                        CircleAvatar(
                                                                          radius: 20.h,
                                                                          backgroundImage: MemoryImage(contact.avatar!),
                                                                        )
                                                                      else
                                                                        CircleAvatar(
                                                                          radius: 20.h,
                                                                          backgroundColor: Colors.white.withOpacity(0.2),
                                                                          child: Text(
                                                                            contact.displayName?.substring(0, 1).toUpperCase() ?? '?',
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      SizedBox(height: 4.h),
                                                                      Text(
                                                                        contact.displayName?.split(' ')[0] ?? 'Unknown',
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          GestureDetector(
                                                            onTap: _pickContact,
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 20.h,
                                                                  backgroundColor: Colors.white.withOpacity(0.2),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors.white,
                                                                    size: 24.h,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 4.h),
                                                                Text(
                                                                  "Add",
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Text below person log
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 229.h + 10.h + 30.h + 10.h + 76.h + 10.h,
                                    child: Text(
                                      "Where were you?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Second person log SVG for location
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 229.h + 10.h + 30.h + 10.h + 76.h + 10.h + 30.h + 10.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/person_log.svg',
                                          width: 340.h,
                                          height: 76.h,
                                        ),
                                        if (_markers.isNotEmpty)
                                          Positioned.fill(
                                            child: GestureDetector(
                                              onTap: _showLocationPicker,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(32.h),
                                                child: Stack(
                                                  children: [
                                                    if (_mapScreenshot != null)
                                                      Container(
                                                        width: 340.h,
                                                        height: 76.h,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: MemoryImage(_mapScreenshot!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Container(
                                                        width: 340.h,
                                                        height: 76.h,
                                                        child: GoogleMap(
                                                          initialCameraPosition: CameraPosition(
                                                            target: _markers.first.position,
                                                            zoom: 15,
                                                          ),
                                                          markers: _markers,
                                                          mapType: MapType.normal,
                                                          zoomControlsEnabled: false,
                                                          mapToolbarEnabled: false,
                                                          myLocationButtonEnabled: false,
                                                          rotateGesturesEnabled: false,
                                                          scrollGesturesEnabled: false,
                                                          zoomGesturesEnabled: false,
                                                          tiltGesturesEnabled: false,
                                                          compassEnabled: false,
                                                          onMapCreated: (GoogleMapController controller) async {
                                                            try {
                                                              await controller.setMapStyle('''[
                                                                {
                                                                  "elementType": "geometry",
                                                                  "stylers": [{"color": "#242f3e"}]
                                                                },
                                                                {
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#746855"}]
                                                                },
                                                                {
                                                                  "elementType": "labels.text.stroke",
                                                                  "stylers": [{"color": "#242f3e"}]
                                                                },
                                                                {
                                                                  "featureType": "administrative.locality",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#d59563"}]
                                                                },
                                                                {
                                                                  "featureType": "poi",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#d59563"}]
                                                                },
                                                                {
                                                                  "featureType": "poi.park",
                                                                  "elementType": "geometry",
                                                                  "stylers": [{"color": "#263c3f"}]
                                                                },
                                                                {
                                                                  "featureType": "poi.park",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#6b9a76"}]
                                                                },
                                                                {
                                                                  "featureType": "road",
                                                                  "elementType": "geometry",
                                                                  "stylers": [{"color": "#38414e"}]
                                                                },
                                                                {
                                                                  "featureType": "road",
                                                                  "elementType": "geometry.stroke",
                                                                  "stylers": [{"color": "#212a37"}]
                                                                },
                                                                {
                                                                  "featureType": "road",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#9ca5b3"}]
                                                                },
                                                                {
                                                                  "featureType": "road.highway",
                                                                  "elementType": "geometry",
                                                                  "stylers": [{"color": "#746855"}]
                                                                },
                                                                {
                                                                  "featureType": "road.highway",
                                                                  "elementType": "geometry.stroke",
                                                                  "stylers": [{"color": "#1f2835"}]
                                                                },
                                                                {
                                                                  "featureType": "road.highway",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#f3d19c"}]
                                                                },
                                                                {
                                                                  "featureType": "transit",
                                                                  "elementType": "geometry",
                                                                  "stylers": [{"color": "#2f3948"}]
                                                                },
                                                                {
                                                                  "featureType": "transit.station",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#d59563"}]
                                                                },
                                                                {
                                                                  "featureType": "water",
                                                                  "elementType": "geometry",
                                                                  "stylers": [{"color": "#17263c"}]
                                                                },
                                                                {
                                                                  "featureType": "water",
                                                                  "elementType": "labels.text.fill",
                                                                  "stylers": [{"color": "#515c6d"}]
                                                                },
                                                                {
                                                                  "featureType": "water",
                                                                  "elementType": "labels.text.stroke",
                                                                  "stylers": [{"color": "#17263c"}]
                                                                }
                                                              ]''');
                                                              
                                                              // Ensure the camera is positioned at the selected location
                                                              if (_markers.isNotEmpty) {
                                                                controller.animateCamera(
                                                                  CameraUpdate.newLatLng(_markers.first.position),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              print('Error setting map style: $e');
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    // Add a transparent container to capture tap events
                                                    Positioned.fill(
                                                      child: Container(
                                                        color: Colors.transparent,
                                                      ),
                                                    ),
                                                    if (_locationName != null)
                                                      Positioned(
                                                        top: 45.h,
                                                        left: 0,
                                                        right: 0,
                                                        child: Center(
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFFBCBCBC).withOpacity(0.3),
                                                              borderRadius: BorderRadius.circular(32.h),
                                                            ),
                                                            child: Text(
                                                              _locationName!,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_markers.isEmpty)
                                          Positioned.fill(
                                            child: Center(
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 500),
                                                curve: Curves.easeInOutCubic,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    AnimatedSwitcher(
                                                      duration: Duration(milliseconds: 500),
                                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                                        return FadeTransition(
                                                          opacity: animation,
                                                          child: ScaleTransition(
                                                            scale: animation,
                                                            child: child,
                                                          ),
                                                        );
                                                      },
                                                      child: Padding(
                                                        key: ValueKey<bool>(true),
                                                        padding: EdgeInsets.symmetric(horizontal: 11.h),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: _showLocationPicker,
                                                              child: SvgPicture.asset(
                                                                'assets/images/plus_log_1.svg',
                                                                width: 35.h,
                                                                height: 34.h,
                                                              ),
                                                            ),
                                                            SizedBox(height: 2.h),
                                                            Text(
                                                              "Add Location",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily: 'Roboto',
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Next button
                                  Positioned(
                                    right: 2.h,
                                    top: 229.h + 10.h + 30.h + 10.h + 76.h + 10.h + 30.h + 10.h + 76.h + 15.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LogScreenStep2PositiveScreen.builder(context),
                                              ),
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/next_log.svg',
                                            width: 142.h,
                                            height: 42.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LogScreenStep2PositiveScreen.builder(context),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () async {
              print('🔍 Back button pressed with source: ${widget.source}');
              
              // Always check source parameter first
              if (widget.source == 'aiscreen') {
                print('✅ Navigating back to AI screen');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AiScreenText.builder(context),
                  ),
                );
                return;
              }
              
              // Only check saved mood source if not coming from AI screen
              final savedMoodSource = StorageService.getMoodSource();
              print('📝 Saved mood source: $savedMoodSource');
              
              if (widget.source == 'colorscreen') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogInputColorsScreen.builder(context),
                  ),
                );
              } else if (savedMoodSource != null) {
                switch (savedMoodSource) {
                  case 'emoji_one':
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmojiLogOneScreen.builder(context, source: widget.source),
                      ),
                    );
                    break;
                  case 'emoji_two':
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmojiLogTwoScreen.builder(context, source: widget.source),
                      ),
                    );
                    break;
                  case 'emoji_three':
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmojiLogThreeScreen.builder(context, source: widget.source),
                      ),
                    );
                    break;
                  case 'emoji_four':
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmojiLogFourScreen.builder(context, source: widget.source),
                      ),
                    );
                    break;
                  case 'emoji_five':
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmojiLogFiveScreen(source: widget.source),
                      ),
                    );
                    break;
                  default:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogInputScreen.builder(context, source: widget.source),
                      ),
                    );
                }
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogInputScreen.builder(context, source: widget.source),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, top: 10.h),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: 27.h,
                height: 27.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 34.h, vertical: 22.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<LogProvider>(
            builder: (context, provider, child) {
              return ResponsiveGridListBuilder(
                minItemWidth: 1,
                minItemsPerRow: 4,
                maxItemsPerRow: 4,
                horizontalGridSpacing: 32.h,
                verticalGridSpacing: 32.h,
                builder: (context, items) => ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: items,
                ),
                gridItems: List.generate(
                    provider.logModelObj.logScreenOneItemList.length, (index) {
                  final model =
                      provider.logModelObj.logScreenOneItemList[index];
                  return LogScreenOneItemWidget(model);
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAlertone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            height: 32.h,
            width: 32.h,
            padding: EdgeInsets.all(8.h),
            decoration: IconButtonStyleHelper.none,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloseOnprimary,
            ),
          ),
          Text(
            "lbl_add_people".tr(),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAlerttwo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            height: 32.h,
            width: 32.h,
            padding: EdgeInsets.all(8.h),
            decoration: IconButtonStyleHelper.none,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloseOnprimary,
            ),
          ),
          Text(
            "lbl_add_location".tr(),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(Duration(days: 365));
    
    if (_selectedDate.isBefore(oneYearAgo)) {
      _selectedDate = oneYearAgo;
    } else if (_selectedDate.isAfter(now)) {
      _selectedDate = now;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            // Save the selected date/time when done
                            await StorageService.saveSelectedDateTime(_selectedDate);
                            await _saveCurrentMood(); // Save mood again with new timestamp
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          pickerTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: _selectedDate,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        maximumDate: now,
                        minimumDate: oneYearAgo,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) async {
                          setState(() {
                            _selectedDate = newDateTime;
                          });
                          // Save the date/time whenever it changes
                          await StorageService.saveSelectedDateTime(newDateTime);
                          await _saveCurrentMood(); // Save mood again with new timestamp
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year && 
                    _selectedDate.month == now.month && 
                    _selectedDate.day == now.day;
    final isYesterday = _selectedDate.year == now.year && 
                       _selectedDate.month == now.month && 
                       _selectedDate.day == now.day - 1;
    
    String dayText;
    if (isToday) {
      dayText = "TODAY";
    } else if (isYesterday) {
      dayText = "YESTERDAY";
    } else {
      final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      dayText = days[_selectedDate.weekday - 1];
    }

    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');
    final hour = _selectedDate.hour.toString().padLeft(2, '0');
    final minute = _selectedDate.minute.toString().padLeft(2, '0');
    
    return "$dayText, ${_getMonthAbbreviation(_selectedDate.month)} $day, $hour:$minute";
  }

  String _getMonthAbbreviation(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }

  Future<void> _onContactSelected(Contact contact) async {
    setState(() {
      if (selectedContacts.any((c) => c.displayName == contact.displayName)) {
        selectedContacts.removeWhere((c) => c.displayName == contact.displayName);
      } else {
        selectedContacts.add(contact);
      }
    });
    await _saveSelectedContacts(); // Save contacts after selection change
  }

  void _onLocationSelected(String? location) {
    if (location == null) return;
    setState(() {
      selectedLocation = location;
    });
    StorageService.saveSelectedLocation(location);
  }

  Future<List<PlacePrediction>> _getPlaces(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final location = _currentPosition != null
          ? '&location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=50000'
          : '';
      final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedQuery$location&key=$_placesApiKey';
      print('Fetching places with URL: $url');
      
      final response = await http.get(Uri.parse(url));
      print('Places API response status: ${response.statusCode}');
      print('Places API response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List? ?? [];
          return predictions.map((p) => PlacePrediction.fromJson(p)).toList();
        } else {
          print('Places API error: ${data['status']}');
          return [];
        }
      } else {
        print('Places API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching places: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_placesApiKey',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'];
    }
    return null;
  }

  Future<void> _loadSavedData() async {
    // Load saved mood first
    final savedMood = StorageService.getCurrentMood();
    final savedMoodSource = StorageService.getMoodSource();
    print('Loaded saved mood: $savedMood from source: $savedMoodSource');
    
    if (savedMood != null && savedMoodSource != null) {
      setState(() {
        _currentMood = savedMood;
        _moodSource = savedMoodSource;
      });
    }

    // Load other saved data
    final savedDateTime = await StorageService.getSelectedDateTime();
    if (savedDateTime != null) {
      setState(() {
        _selectedDate = savedDateTime;
      });
    }

    final savedIcons = StorageService.getToggledIcons();
    setState(() {
      toggledIcons = savedIcons.map((e) => e.toString()).toSet();
    });

    final savedContacts = await StorageService.getSelectedContacts();
    setState(() {
      selectedContacts = savedContacts;
    });

    // Load saved map screenshot
    final savedScreenshot = await StorageService.getMapScreenshot();
    if (savedScreenshot != null) {
      setState(() {
        _mapScreenshot = savedScreenshot;
      });
    }

    // Only load saved location if it exists, don't request current location
    final savedLocation = await StorageService.getSelectedLocation();
    final savedCoords = await StorageService.getLocationCoordinates();
    if (savedCoords != null && savedLocation != null) {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('selected_location'),
            position: LatLng(savedCoords['lat']!, savedCoords['lng']!),
            infoWindow: InfoWindow(title: savedLocation),
          ),
        );
        _locationName = savedLocation;
      });
    }
  }

  Future<void> _loadSelectedContacts() async {
    try {
      final contacts = await StorageService.getSelectedContacts();
      if (contacts.isNotEmpty) {
        setState(() {
          selectedContacts = contacts;
        });
      }
    } catch (e) {
      print('Error loading contacts: $e');
      setState(() {
        selectedContacts = [];
      });
    }
  }

  Future<void> _saveSelectedContacts() async {
    try {
      await StorageService.saveSelectedContacts(selectedContacts);
    } catch (e) {
      print('Error saving contacts: $e');
    }
  }

  void _replaceContact(int index) {
    _pickContact().then((_) {
      if (selectedContacts.length > index) {
        setState(() {
          selectedContacts.removeAt(index);
        });
        _saveSelectedContacts();
      }
    });
  }
}
