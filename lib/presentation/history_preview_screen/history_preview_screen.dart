import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/app_export.dart';
import '../homescreen_screen/homescreen_screen.dart';
import 'provider/history_preview_provider.dart';
import 'models/history_preview_model.dart';
import '../history_empty_screen/history_empty_screen.dart';

class HistoryPreviewScreen extends StatefulWidget {
  final Map<String, dynamic>? logData;
  
  const HistoryPreviewScreen({
    Key? key,
    this.logData,
  }) : super(key: key);

  @override
  HistoryPreviewScreenState createState() => HistoryPreviewScreenState();

  static Widget builder(BuildContext context, {Map<String, dynamic>? logData}) {
    return ChangeNotifierProvider.value(
      value: HistoryPreviewProvider()..updateLogData(logData ?? {}),
      child: HistoryPreviewScreen(logData: logData),
    );
  }
}

class HistoryPreviewScreenState extends State<HistoryPreviewScreen> {
  late final HistoryPreviewProvider _provider;
  bool isLoading = true;
  String? maxIntensityFeeling;
  int? maxIntensity;
  List<MapEntry<String, int>> otherFeelings = [];
  String? maxNegativeIntensityFeeling;
  int? maxNegativeIntensity;
  List<MapEntry<String, int>> otherNegativeFeelings = [];
  Set<Marker> _markers = {};
  Uint8List? _mapScreenshot;
  GoogleMapController? _mapController;
  Map<String, dynamic>? _mapData;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<HistoryPreviewProvider>(context, listen: false);
    if (widget.logData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _initializeData();
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    
    // Run all data fetching operations in parallel
    await Future.wait([
      _fetchMaxIntensityFeeling(),
      _fetchMapData(),
    ]);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMaxIntensityFeeling() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null || widget.logData == null) {
      return;
    }

    try {
      final documentId = widget.logData!['documentId'] ?? widget.logData!['id'];
      if (documentId == null) return;

      // Fetch positive and negative feelings in parallel
      final futures = await Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(documentId)
            .collection('positive_feelings')
            .get(),
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('logs')
            .doc(documentId)
            .collection('negative_feelings')
            .get(),
      ]);

      final positiveFeelingsSnapshot = futures[0];
      final negativeFeelingsSnapshot = futures[1];

      // Process positive feelings
      if (positiveFeelingsSnapshot.docs.isNotEmpty) {
        List<MapEntry<String, int>> allFeelings = [];
        
        for (var doc in positiveFeelingsSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            var intensity = 0;
            final rawIntensity = data['intensity'];
            
            if (rawIntensity is int) {
              intensity = rawIntensity;
            } else if (rawIntensity is double) {
              intensity = rawIntensity.round();
            } else if (rawIntensity is String) {
              intensity = int.tryParse(rawIntensity) ?? 0;
            } else if (rawIntensity is num) {
              intensity = rawIntensity.toInt();
            }
            
            allFeelings.add(MapEntry(doc.id, intensity));
          }
        }

        allFeelings.sort((a, b) => b.value.compareTo(a.value));

        if (allFeelings.isNotEmpty) {
          final maxFeeling = allFeelings.first;
          final otherFeelingsList = allFeelings.skip(1).take(3).toList();

          if (mounted) {
            setState(() {
              maxIntensityFeeling = maxFeeling.key;
              maxIntensity = maxFeeling.value;
              otherFeelings = otherFeelingsList;
            });
          }
        }
      }

      // Process negative feelings
      if (negativeFeelingsSnapshot.docs.isNotEmpty) {
        List<MapEntry<String, int>> allNegativeFeelings = [];
        
        for (var doc in negativeFeelingsSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            var intensity = 0;
            final rawIntensity = data['intensity'];
            
            if (rawIntensity is int) {
              intensity = rawIntensity;
            } else if (rawIntensity is double) {
              intensity = rawIntensity.round();
            } else if (rawIntensity is String) {
              intensity = int.tryParse(rawIntensity) ?? 0;
            } else if (rawIntensity is num) {
              intensity = rawIntensity.toInt();
            }
            
            allNegativeFeelings.add(MapEntry(doc.id, intensity));
          }
        }

        allNegativeFeelings.sort((a, b) => b.value.compareTo(a.value));

        if (allNegativeFeelings.isNotEmpty) {
          final maxFeeling = allNegativeFeelings.first;
          final otherFeelingsList = allNegativeFeelings.skip(1).take(3).toList();

          if (mounted) {
            setState(() {
              maxNegativeIntensityFeeling = maxFeeling.key;
              maxNegativeIntensity = maxFeeling.value;
              otherNegativeFeelings = otherFeelingsList;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching feelings: $e');
    }
  }

  Future<void> _fetchMapData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null || widget.logData == null) {
      return;
    }

    try {
      final documentId = widget.logData!['documentId'] ?? widget.logData!['id'];
      if (documentId == null) return;

      final mapSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('logs')
          .doc(documentId)
          .collection('map')
          .doc('location')
          .get();

      if (mapSnapshot.exists) {
        final mapData = mapSnapshot.data();
        if (mapData != null) {
          final latitude = double.tryParse(mapData['latitude'].toString()) ?? 0.0;
          final longitude = double.tryParse(mapData['longitude'].toString()) ?? 0.0;
          
          if (mounted) {
            setState(() {
              _mapData = mapData;
              _markers = {
                Marker(
                  markerId: MarkerId('selected_location'),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(title: mapData['name'] ?? 'Selected Location'),
                ),
              };
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching map data: $e');
    }
  }

  String _getIconPath(String iconName) {
    // Special handling for music icon
    if (iconName == 'Music') {
      return 'assets/images/music_2.svg';
    }
    // For other icons, use the lowercase version
    return 'assets/images/${iconName.toLowerCase()}.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                HistoryEmptyScreen.builder(context),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/chevron.backward.svg',
                            width: 9,
                            height: 17,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'History',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 11),
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/history_preview_box.svg',
                        width: 340,
                        height: 720,
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/log_1_mood.svg',
                              width: 267,
                              height: 74,
                            ),
                            Positioned(
                              top: 5,
                              child: Column(
                                children: [
                                  Consumer<HistoryPreviewProvider>(
                                    builder: (context, provider, child) {
                                      final model = provider.historyPreviewModelObj;
                                      final mood = model.mood ?? '';
                                      final moodParts = mood.split(' ');
                                      return RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: (moodParts.isNotEmpty ? moodParts.first : '') + '\u2009',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: moodParts.length > 1 ? moodParts.last : '',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 29,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 2),
                                  Transform.translate(
                                    offset: Offset(-4, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Consumer<HistoryPreviewProvider>(
                                          builder: (context, provider, child) {
                                            final model = provider.historyPreviewModelObj;
                                            final date = model.date ?? '';
                                            final time = model.time ?? '';
                                            return Row(
                                              children: [
                                                Text(
                                                  date,
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.08,
                                                    height: 16/13,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  time,
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.08,
                                                    height: 16/13,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(width: 1.5),
                                        SvgPicture.asset(
                                          'assets/images/chevron_log.svg',
                                          width: 7,
                                          height: 10.92,
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
                    // Icons from whats_happening subcollection
                    Positioned(
                      top: 108,
                      left: 50,
                      child: Consumer<HistoryPreviewProvider>(
                        builder: (context, provider, child) {
                          final model = provider.historyPreviewModelObj;
                          final toggledIcons = model.toggledIcons ?? [];
                          final contacts = model.contacts ?? [];
                          
                          return Column(
                            children: [
                              Row(
                                children: [
                                  ...toggledIcons.take(3).map((icon) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            _getIconPath(icon),
                                            width: 43,
                                            height: 42,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            icon,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  ...contacts.take(3).map((contact) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 43,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.2),
                                            ),
                                            child: ClipOval(
                                              child: contact['avatar'] != null 
                                                ? Image.memory(
                                                    contact['avatar'] as Uint8List,
                                                    width: 43,
                                                    height: 42,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child: Text(
                                                      contact['displayName'].substring(0, 1).toUpperCase(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            contact['displayName'].split(' ')[0],
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // Spotify log
                    Positioned(
                      top: 108 + 42 + 5 + 42 + 2 + 10 + 33,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/spotify_log.svg',
                            width: 300,
                            height: 31,
                          ),
                          Positioned(
                            left: 125,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/spotify_small.svg',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(width: 4),
                                Consumer<HistoryPreviewProvider>(
                                  builder: (context, provider, child) {
                                    final model = provider.historyPreviewModelObj;
                                    final spotifyTrack = model.spotifyTrack;
                                    if (spotifyTrack != null) {
                                      return Text(
                                        '${spotifyTrack['name']} · ${spotifyTrack['artist']}',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // First positive log
                    Positioned(
                      top: 108 + 42 + 5 + 42 + 2 + 10 + 33 + 31 + 10,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/positive_log.svg',
                            width: 300,
                            height: 60,
                          ),
                          if (!isLoading && maxIntensityFeeling != null)
                            Positioned(
                              top: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Maximum intensity feeling
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        maxIntensityFeeling!,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '(${maxIntensity ?? 0}%)',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white.withOpacity(1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Other feelings
                                  if (otherFeelings.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ...otherFeelings.map((feeling) => Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4),
                                            child: Text(
                                              '${feeling.key} (${feeling.value}%)',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )).toList(),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )
                          else if (isLoading)
                            Positioned(
                              top: 10,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Photos grid
                    Positioned(
                      top: 108 + 2, // Icons + spacing + text + spacing + avatars + spacing + text
                      left: 45 + (46 + 10) * 3,
                      child: Consumer<HistoryPreviewProvider>(
                        builder: (context, provider, child) {
                          final model = provider.historyPreviewModelObj;
                          final photos = model.photos ?? [];
                          
                          return Column(
                            children: [
                              Row(
                                children: [
                                  if (photos.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        photos[0],
                                        width: 59,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 59,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(Icons.error, color: Colors.grey[600]),
                                          );
                                        },
                                      ),
                                    ),
                                  SizedBox(width: 1),
                                  if (photos.length > 1)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        photos[1],
                                        width: 59,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 59,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(Icons.error, color: Colors.grey[600]),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 1),
                              Row(
                                children: [
                                  if (photos.length > 2)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        photos[2],
                                        width: 59,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 59,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(Icons.error, color: Colors.grey[600]),
                                          );
                                        },
                                      ),
                                    ),
                                  SizedBox(width: 1),
                                  if (photos.length > 3)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        photos[3],
                                        width: 59,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 59,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(Icons.error, color: Colors.grey[600]),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // Second positive log with negative feelings
                    Positioned(
                      top: 108 + 42 + 5 + 42 + 2 + 10 + 33 + 31 + 10 + 60 + 10,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/positive_log.svg',
                            width: 300,
                            height: 60,
                          ),
                          if (!isLoading && maxNegativeIntensityFeeling != null)
                            Positioned(
                              top: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Maximum intensity negative feeling
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        maxNegativeIntensityFeeling!,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '(${maxNegativeIntensity ?? 0}%)',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white.withOpacity(1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Other negative feelings
                                  if (otherNegativeFeelings.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ...otherNegativeFeelings.map((feeling) => Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4),
                                            child: Text(
                                              '${feeling.key} (${feeling.value}%)',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )).toList(),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Third positive log
                    Positioned(
                      top: 108 + 42 + 5 + 42 + 2 + 10 + 33 + 31 + 10 + 60 + 10 + 60 + 10,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/positive_log.svg',
                                width: 300,
                                height: 60,
                              ),
                              if (_mapData != null && _markers.isNotEmpty)
                                Positioned.fill(
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: Stack(
                                        children: [
                                          if (_mapScreenshot != null)
                                            Container(
                                              width: 300,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(32),
                                                image: DecorationImage(
                                                  image: MemoryImage(_mapScreenshot!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(32),
                                                  color: Colors.white.withOpacity(0.1),
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              width: 300,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(32),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(32),
                                                child: Stack(
                                                  children: [
                                                    GoogleMap(
                                                      initialCameraPosition: CameraPosition(
                                                        target: _markers.first.position,
                                                        zoom: 13,
                                                        tilt: 0,
                                                        bearing: 0,
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
                                                        print('Debug: Map created successfully');
                                                        try {
                                                          // Set camera position with offset to center the pin
                                                          await controller.animateCamera(
                                                            CameraUpdate.newCameraPosition(
                                                              CameraPosition(
                                                                target: _markers.first.position,
                                                                zoom: 13,
                                                                tilt: 0,
                                                                bearing: 0,
                                                              ),
                                                            ),
                                                          );
                                                          
                                                          // Wait for the camera animation to complete
                                                          await Future.delayed(Duration(milliseconds: 500));
                                                          
                                                          // Move camera up slightly
                                                          await controller.moveCamera(
                                                            CameraUpdate.scrollBy(0, -20),
                                                          );
                                                          
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
                                                          print('Debug: Map style set successfully');
                                                          
                                                          _mapController = controller;
                                                          
                                                          // Take a screenshot of the map
                                                          await Future.delayed(Duration(milliseconds: 500));
                                                          print('Debug: Taking map screenshot');
                                                          final screenshot = await controller.takeSnapshot();
                                                          if (screenshot != null) {
                                                            print('Debug: Screenshot taken successfully');
                                                            setState(() {
                                                              _mapScreenshot = screenshot;
                                                            });
                                                          } else {
                                                            print('Debug: Failed to take screenshot');
                                                          }
                                                        } catch (e) {
                                                          print('Error setting map style: $e');
                                                          print('Error stack trace: ${StackTrace.current}');
                                                        }
                                                      },
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.1),
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
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              final doc = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.email)
                                  .collection('logs')
                                  .doc(widget.logData?['documentId'] ?? widget.logData?['id'])
                                  .collection('Journal')
                                  .doc('text')
                                  .get();
                              final journalText = doc.exists ? (doc.get('text') as String? ?? '') : '';
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                  height: MediaQuery.of(context).size.height * 0.75,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFBCBCBC).withOpacity(0.08),
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBCBCBC).withOpacity(0.08),
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 16),
                                            Container(
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                            SizedBox(height: 24),
                                            Text(
                                              "Journal Entry",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                                child: Text(
                                                  journalText,
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.85),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.7,
                                                  ),
                                                  textAlign: TextAlign.justify,
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
                            },
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/box_journal.svg',
                                  width: 300,
                                  height: 190,
                                ),
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: CustomPaint(
                                      painter: WritingLinesPainter(
                                        lineColor: Colors.white.withOpacity(0.2),
                                        lineSpacing: 24.0,
                                        horizontalInset: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 3,
                                  left: 14,
                                  right: 20,
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth.instance.currentUser?.email)
                                        .collection('logs')
                                        .doc(widget.logData?['documentId'] ?? widget.logData?['id'])
                                        .collection('Journal')
                                        .doc('text')
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData && snapshot.data?.exists == true) {
                                        final journalText = snapshot.data?.get('text') as String? ?? '';
                                        return Text(
                                          journalText,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.85),
                                            fontSize: 11.7,
                                            fontWeight: FontWeight.w500,
                                            height: 2.05,
                                          ),
                                          maxLines: 7,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: CupertinoActivityIndicator(
                              radius: 12,
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
      ),
    );
  }
}

class WritingLinesPainter extends CustomPainter {
  final Color lineColor;
  final double lineSpacing;
  final double horizontalInset;

  WritingLinesPainter({
    required this.lineColor,
    required this.lineSpacing,
    this.horizontalInset = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5;

    double y = lineSpacing;
    while (y < size.height) {
      canvas.drawLine(
        Offset(horizontalInset, y),
        Offset(size.width - horizontalInset, y),
        paint,
      );
      y += lineSpacing;
    }
  }

  @override
  bool shouldRepaint(WritingLinesPainter oldDelegate) =>
      lineColor != oldDelegate.lineColor ||
      lineSpacing != oldDelegate.lineSpacing ||
      horizontalInset != oldDelegate.horizontalInset;
}
