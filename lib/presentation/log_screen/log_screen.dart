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
import '../emoji_log_one_screen/emoji_log_one_screen.dart';
import '../emoji_log_two_screen/emoji_log_two_screen.dart';
import '../emoji_log_three_screen/emoji_log_three_screen.dart';
import '../emoji_log_four_screen/emoji_log_four_screen.dart';
import '../emoji_log_five_screen/emoji_log_five_screen.dart';
import '../log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';

import 'models/log_model.dart';
import 'models/log_screen_one_item_model.dart';
import 'provider/log_provider.dart';
import 'widgets/log_screen_one_item_widget.dart';
import 'services/storage_service.dart';

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

  static Widget builder(BuildContext context, {String source = 'homescreen', String emojiSource = 'emoji_one', String feeling = ''}) {
    return LogScreen(source: source, emojiSource: emojiSource, feeling: feeling);
  }
}

class LogScreenState extends State<LogScreen> {
  late DateTime _selectedDate;
  Set<int> toggledIcons = {};
  List<String> selectedContacts = [];
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
  final String _placesApiKey = 'AIzaSyDohu3J9jw0lUyUswNP3PxiKzXKJJQJvNk';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _requestContactPermission();
    _requestLocationPermission();
    _loadSavedData();
  }

  Future<void> _requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact permission is required to add people')),
      );
    }
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show dialog to enable them
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
      return;
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
        return;
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
      return;
    }

    // If we get here, permissions are granted and we can proceed
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('Getting current location...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Got position: ${position.latitude}, ${position.longitude}');
      setState(() {
        _currentPosition = position;
      });
      if (_mapController != null) {
        print('Animating camera to position');
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Current Location'),
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

  void _showLocationPicker() {
    if (_currentPosition == null) {
      print('Current position is null, requesting permission');
      _requestLocationPermission();
      return;
    }

    // Add current location marker by default
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

    print('Showing location picker with position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
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
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFBCBCBC).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(32.h),
                      ),
                      child: TypeAheadField<PlacePrediction>(
                        controller: _searchController,
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Search for a place...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.h),
                            ),
                          );
                        },
                        suggestionsCallback: (String pattern) async {
                          if (pattern.length > 2) {
                            return await _getPlaces(pattern);
                          }
                          return [];
                        },
                        itemBuilder: (context, PlacePrediction prediction) {
                          return ListTile(
                            leading: Icon(Icons.location_on, color: Colors.white.withOpacity(0.5)),
                            title: Text(
                              prediction.description,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
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
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLng(
                                    LatLng(location['lat'] ?? 0, location['lng'] ?? 0),
                                  ),
                                );
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Enter Location Name input
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFBCBCBC).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(32.h),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Enter location name',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.h),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _locationName = value;
                          });
                        },
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
                          onPressed: () {
                            if (_markers.isNotEmpty) {
                              print('Location confirmed: \\${_markers.first.position.latitude}, \\${_markers.first.position.longitude}');
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
                                  if (!selectedContacts.contains(contact.displayName)) {
                                    setState(() {
                                      selectedContacts.add(contact.displayName);
                                    });
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

  void _toggleIcon(int index) {
    setState(() {
      if (toggledIcons.contains(index)) {
        toggledIcons.remove(index);
      } else {
        toggledIcons.add(index);
      }
      // Save toggled icons
      StorageService.saveToggledIcons(toggledIcons);
    });
  }

  String _getIconPath(String basePath, int index) {
    if (toggledIcons.contains(index)) {
      // Replace .svg with _2.svg
      return basePath.replaceAll('.svg', '_2.svg');
    }
    return basePath;
  }

  Widget _buildIconWithText(int index, double left, double top, String iconPath, String text) {
    return Positioned(
      left: left,
      top: top,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleIcon(index),
            child: SvgPicture.asset(
              _getIconPath(iconPath, index),
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
                                              text: widget.feeling.split(' ').first + '\u2009',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.feeling.split(' ').last,
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
                                  _buildIconWithText(0, 35.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/work.svg', 'Work'),
                                  _buildIconWithText(1, 36.h + 43.h + 32.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/family.svg', 'Family'),
                                  _buildIconWithText(2, 36.h + (43.h + 32.h) * 2, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/study.svg', 'Study'),
                                  _buildIconWithText(3, 19.h + (43.h + 32.h) * 3, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 1.5, 'assets/images/relationship.svg', 'Relationship'),
                                  // Second row
                                  _buildIconWithText(4, 30.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/exercise.svg', 'Exercise'),
                                  _buildIconWithText(5, 36.h + 43.h + 32.h, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/party.svg', 'Party'),
                                  _buildIconWithText(6, 27.h + (43.h + 32.h) * 2, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/travelling.svg', 'Travelling'),
                                  _buildIconWithText(7, 32.h + (43.h + 32.h) * 3, 229.h / 2 - (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/weather.svg', 'Weather'),
                                  // Third row
                                  _buildIconWithText(8, 35.h, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/music_log.svg', 'Music'),
                                  _buildIconWithText(9, 36.h + 43.h + 32.h, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/hobby.svg', 'Hobby'),
                                  _buildIconWithText(10, 29.h + (43.h + 32.h) * 2, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/shopping.svg', 'Shopping'),
                                  _buildIconWithText(11, 36.h + (43.h + 32.h) * 3, 229.h / 2 + (42.h + 2.h + 12.h + 8.h) * 0.5, 'assets/images/beauty.svg', 'Beauty'),
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
                                                                key: Key(contact),
                                                                direction: DismissDirection.up,
                                                                dismissThresholds: const {
                                                                  DismissDirection.up: 0.15,
                                                                },
                                                                movementDuration: Duration(milliseconds: 150),
                                                                crossAxisEndOffset: 0.3,
                                                                background: Container(
                                                                  alignment: Alignment.topCenter,
                                                                  padding: EdgeInsets.only(top: 8.h),
                                                                  child: AnimatedContainer(
                                                                    duration: Duration(milliseconds: 100),
                                                                    curve: Curves.easeOut,
                                                                    child: Icon(
                                                                      Icons.delete,
                                                                      color: Colors.white,
                                                                      size: 24.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                                confirmDismiss: (direction) async {
                                                                  // Faster confirmation
                                                                  await Future.delayed(Duration(milliseconds: 50));
                                                                  if (!mounted) return false;
                                                                  return true;
                                                                },
                                                                onDismissed: (direction) {
                                                                  setState(() {
                                                                    selectedContacts.remove(contact);
                                                                  });
                                                                },
                                                                child: AnimatedContainer(
                                                                  duration: Duration(milliseconds: 150),
                                                                  curve: Curves.easeOut,
                                                                  child: GestureDetector(
                                                                    onTap: () => _onContactSelected(contact),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        AnimatedContainer(
                                                                          duration: Duration(milliseconds: 300),
                                                                          curve: Curves.easeInOutCubic,
                                                                          child: Text(
                                                                            contact,
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          AnimatedContainer(
                                                            duration: Duration(milliseconds: 300),
                                                            curve: Curves.easeInOutCubic,
                                                            child: GestureDetector(
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
                                                        onMapCreated: (GoogleMapController controller) {
                                                          controller.setMapStyle('''[
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
                                                        },
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
            onTap: () {
              switch (widget.emojiSource) {
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
                      builder: (context) => const EmojiLogFiveScreen(),
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
                          onPressed: () {
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
                          await StorageService.saveSelectedDateTime(newDateTime);
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

  Future<void> _onContactSelected(String contact) async {
    setState(() {
      if (selectedContacts.contains(contact)) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
    });
    await StorageService.saveSelectedContacts(selectedContacts);
  }

  void _onLocationSelected(String? location) {
    if (location == null) return;
    setState(() {
      selectedLocation = location;
    });
    StorageService.saveSelectedLocation(location);
  }

  Future<List<PlacePrediction>> _getPlaces(String query) async {
    final location = _currentPosition != null
        ? '&location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=50000'
        : '';
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query$location&key=$_placesApiKey',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List? ?? [];
      return predictions.map((p) => PlacePrediction.fromJson(p)).toList();
    }
    return [];
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
    // Load saved date/time
    final savedDateTime = await StorageService.getSelectedDateTime();
    if (savedDateTime != null) {
      setState(() {
        _selectedDate = savedDateTime;
      });
    }

    // Load saved toggled icons
    final savedIcons = await StorageService.getToggledIcons();
    setState(() {
      toggledIcons = savedIcons;
    });

    // Load saved contacts
    final savedContacts = await StorageService.getSelectedContacts();
    setState(() {
      selectedContacts = savedContacts;
    });

    // Load saved location
    final savedLocation = await StorageService.getSelectedLocation();
    final savedCoords = await StorageService.getLocationCoordinates();
    if (savedCoords != null) {
      setState(() {
        _currentPosition = Position(
          latitude: savedCoords['lat']!,
          longitude: savedCoords['lng']!,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        _locationName = savedLocation;
      });
    }
  }
}
