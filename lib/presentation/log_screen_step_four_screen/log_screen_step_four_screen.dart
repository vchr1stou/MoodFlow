import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../core/services/storage_service.dart';
import '../log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';
import '../log_screen_step_five_screen/log_screen_step_five_screen.dart';
import '../spotify_music_selection_screen/spotify_music_selection_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogScreenStepFourScreen extends StatefulWidget {
  const LogScreenStepFourScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogScreenStepFourScreenState createState() => LogScreenStepFourScreenState();
  static Widget builder(BuildContext context) {
    return LogScreenStepFourScreen();
  }
}

class LogScreenStepFourScreenState extends State<LogScreenStepFourScreen> {
  final TextEditingController _journalController = TextEditingController();
  String _journalPreview = '';
  List<File> _selectedPhotos = [];
  List<String> _selectedPhotoBase64 = [];
  Map<String, dynamic>? _selectedTrack;
  bool _isSaving = false;
  
  // Add position adjustment variables
  double _trackVerticalOffset = 0.0;
  double _trackHorizontalOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Clear any previous track and journal text when opening the screen
    StorageService.saveSelectedTrack({});
    StorageService.saveJournalText('');
    _journalPreview = '';
    _loadSelectedTrack();
    _loadSelectedPhotos();
  }

  Future<void> _loadSelectedTrack() async {
    final track = await StorageService.getSelectedTrack();
    print('Loading selected track: $track'); // Debug log
    if (track != null && track.isNotEmpty && track['name'] != null) {
      setState(() {
        _selectedTrack = track;
      });
    } else {
      setState(() {
        _selectedTrack = null;
      });
      // Clear any empty track data
      await StorageService.saveSelectedTrack({});
    }
  }

  Future<void> _loadSelectedPhotos() async {
    final photos = await StorageService.getSelectedPhotos();
    if (photos.isNotEmpty) {
      setState(() {
        _selectedPhotos = photos;
        // Convert loaded photos to base64
        _selectedPhotoBase64 = photos.map((file) {
          final bytes = file.readAsBytesSync();
          return base64Encode(bytes);
        }).toList();
      });
    }
  }

  Future<String> _convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  void _showWritingOverlay() {
    // Set the controller text to current preview when opening
    _journalController.text = _journalPreview;
    
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
                    "Write in your journal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.h),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.h,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Writing lines
                          Positioned.fill(
                            child: CustomPaint(
                              painter: WritingLinesPainter(
                                lineColor: Colors.white.withOpacity(0.1),
                                lineSpacing: 24.h,
                              ),
                            ),
                          ),
                          // Text input
                          Padding(
                            padding: EdgeInsets.all(16.h),
                            child: TextField(
                              controller: _journalController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                              maxLines: null,
                              expands: true,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                // Only hide keyboard
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Start writing...",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 16.h, top: 0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            // If text was deleted, reset preview and clear storage
                            if (_journalController.text.isEmpty) {
                              setState(() {
                                _journalPreview = '';
                              });
                              StorageService.saveJournalText('');
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Save the journal entry only if it's not empty
                            if (_journalController.text.isNotEmpty) {
                              setState(() {
                                _journalPreview = _journalController.text;
                              });
                              // Save to StorageService
                              StorageService.saveJournalText(_journalController.text);
                            } else {
                              // If text is empty, reset preview and clear storage
                              setState(() {
                                _journalPreview = '';
                              });
                              StorageService.saveJournalText('');
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Save',
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

  Future<void> _pickPhoto({int? replaceIndex, bool allowMulti = false}) async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo library permission is required.')),
      );
      return;
    }
    final picker = ImagePicker();
    if (replaceIndex != null && !allowMulti) {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Adjust quality to balance size and quality
      );
      if (picked != null) {
        final file = File(picked.path);
        final base64String = await _convertImageToBase64(file);
        setState(() {
          _selectedPhotos[replaceIndex] = file;
          _selectedPhotoBase64[replaceIndex] = base64String;
        });
        // Save both the File objects and their base64 strings
        await StorageService.saveSelectedPhotos(_selectedPhotos);
        await StorageService.saveSelectedPhotoBase64(_selectedPhotoBase64);
      }
    } else {
      final picked = await picker.pickMultiImage();
      if (picked != null && picked.isNotEmpty) {
        setState(() {
          final availableSlots = 4 - _selectedPhotos.length;
          final newPhotos = picked.take(availableSlots).map((x) => File(x.path)).toList();
          
          if (_selectedPhotos.length == 1 && allowMulti) {
            // Merge the existing photo with the new ones, avoiding duplicates
            final allPhotos = [_selectedPhotos[0], ...newPhotos];
            final uniquePhotos = <String, File>{};
            for (final photo in allPhotos) {
              uniquePhotos[photo.path] = photo;
            }
            _selectedPhotos = uniquePhotos.values.take(4).toList();
          } else {
            final existingPaths = _selectedPhotos.map((f) => f.path).toSet();
            final filteredNewPhotos = newPhotos.where((f) => !existingPaths.contains(f.path)).toList();
            _selectedPhotos.addAll(filteredNewPhotos);
          }
        });

        // Convert new photos to base64
        for (var photo in _selectedPhotos) {
          if (!_selectedPhotoBase64.contains(photo.path)) {
            final base64String = await _convertImageToBase64(photo);
            _selectedPhotoBase64.add(base64String);
          }
        }

        // Save both the File objects and their base64 strings
        await StorageService.saveSelectedPhotos(_selectedPhotos);
        await StorageService.saveSelectedPhotoBase64(_selectedPhotoBase64);
      }
    }
  }

  void _adjustTrackPosition(DragUpdateDetails details) {
    setState(() {
      _trackVerticalOffset += details.delta.dy;
      _trackHorizontalOffset += details.delta.dx;
    });
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 96.h),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Add to Journal",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              width: 300.h,
                              child: Text(
                                "Spill the tea. It's just between you and your app.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 11.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Base writing box
                                GestureDetector(
                                  onTap: _journalPreview.isNotEmpty ? _showWritingOverlay : null,
                                  child: SvgPicture.asset(
                                    'assets/images/writing_box.svg',
                                    width: 364.h,
                                    height: 199.h,
                                  ),
                                ),
                                if (_journalPreview.isEmpty)
                                  Positioned(
                                    top: 58.h,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: _showWritingOverlay,
                                          child: SvgPicture.asset(
                                            'assets/images/writing_plus.svg',
                                            width: 45.h,
                                            height: 44.h,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "Press to start writing",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  // Content when there's text
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: _showWritingOverlay,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
                                        child: Stack(
                                          children: [
                                            // Writing lines overlay
                                            Positioned.fill(
                                              child: IgnorePointer(
                                                child: CustomPaint(
                                                  painter: WritingLinesPainter(
                                                    lineColor: Colors.white.withOpacity(0.2),
                                                    lineSpacing: 24.h,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Text content
                                            Padding(
                                              padding: EdgeInsets.only(top: 4.h),
                                              child: Text(
                                                _journalPreview,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  height: 24.h / 14,
                                                ),
                                                maxLines: 6,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 11.h),
                            Text(
                              "Add Photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "Save the scene that shaped your feeling.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 11.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => _pickPhoto(),
                                  child: SvgPicture.asset(
                                    'assets/images/photo_box.svg',
                                    width: 364.h,
                                    height: 111.h,
                                  ),
                                ),
                                if (_selectedPhotos.isEmpty)
                                  Positioned(
                                    top: 25.h,
                                    child: GestureDetector(
                                      onTap: () => _pickPhoto(),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/photo_icon.svg',
                                              width: 37.h,
                                              height: 31.h,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              "Add Photo",
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
                                  )
                                else
                                  (_selectedPhotos.length == 1)
                                    ? Positioned.fill(
                                        child: Dismissible(
                                          key: ValueKey(_selectedPhotos[0].path),
                                          direction: DismissDirection.up,
                                          onDismissed: (direction) {
                                            setState(() {
                                              _selectedPhotos.clear();
                                            });
                                          },
                                          background: Container(
                                            alignment: Alignment.topCenter,
                                            padding: EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: [
                                                Icon(Icons.delete, color: Colors.white, size: 22),
                                                SizedBox(height: 2),
                                                Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () => _pickPhoto(replaceIndex: 0, allowMulti: true),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(24.h),
                                              child: Image.file(
                                                _selectedPhotos[0],
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Positioned.fill(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ...List.generate(_selectedPhotos.length, (index) {
                                              final photo = _selectedPhotos[index];
                                              return Center(
                                                child: Dismissible(
                                                  key: ValueKey(photo.path),
                                                  direction: DismissDirection.up,
                                                  onDismissed: (direction) {
                                                    setState(() {
                                                      _selectedPhotos.removeAt(index);
                                                    });
                                                  },
                                                  background: Container(
                                                    alignment: Alignment.topCenter,
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons.delete, color: Colors.white, size: 22),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () => _pickPhoto(replaceIndex: index),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.file(
                                                        photo,
                                                        width: 75,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                            if (_selectedPhotos.length < 4)
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () => _pickPhoto(),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/photo_icon.svg',
                                                        width: 37,
                                                        height: 31,
                                                        fit: BoxFit.contain,
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        "Add Photo",
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
                              ],
                            ),
                            SizedBox(height: 11.h),
                            Text(
                              "Add Music Track",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "Every feeling has a soundtrack. What's yours?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 11.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) => SpotifyMusicSelectionScreen.builder(context),
                                    );
                                    _loadSelectedTrack();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/music_box.svg',
                                    width: 364.h,
                                    height: 111.h,
                                  ),
                                ),
                                if (_selectedTrack == null)
                                  Positioned(
                                    top: 25.h,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) => SpotifyMusicSelectionScreen.builder(context),
                                        );
                                        _loadSelectedTrack();
                                      },
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/spotify_small.svg',
                                              width: 29.h,
                                              height: 29.h,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              "Add Music",
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
                                  )
                                else
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) => SpotifyMusicSelectionScreen.builder(context),
                                        );
                                        _loadSelectedTrack();
                                      },
                                      child: Dismissible(
                                        key: ValueKey(_selectedTrack!['id']),
                                        direction: DismissDirection.up,
                                        onDismissed: (direction) {
                                          setState(() {
                                            _selectedTrack = null;
                                            _trackVerticalOffset = 0.0;
                                            _trackHorizontalOffset = 0.0;
                                          });
                                          StorageService.saveSelectedTrack({});
                                        },
                                        background: Container(
                                          alignment: Alignment.topCenter,
                                          padding: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(24.h),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(Icons.delete, color: Colors.white, size: 22),
                                              SizedBox(height: 2),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onPanUpdate: _adjustTrackPosition,
                                            child: Transform.translate(
                                              offset: Offset(_trackHorizontalOffset, _trackVerticalOffset),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 16.h),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    if (_selectedTrack!['imageUrl'] != null)
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.h),
                                                        child: Image.network(
                                                          _selectedTrack!['imageUrl'],
                                                          width: 60.h,
                                                          height: 60.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    SizedBox(width: 12.h),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            _selectedTrack!['name'] ?? '',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                            '${_selectedTrack!['artist'] ?? ''} · ${_selectedTrack!['album'] is Map ? _selectedTrack!['album']['name'] : _selectedTrack!['album']}',
                                                            style: TextStyle(
                                                              color: Colors.white.withOpacity(0.7),
                                                              fontSize: 12,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
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
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Next button with absolute positioning
            Positioned(
              right: 12.h,
              bottom: 50.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (_isSaving) return;
                      
                      // Save journal text to StorageService only
                      if (_journalPreview.isNotEmpty) {
                        setState(() {
                          _isSaving = true;
                        });
                        
                        try {
                          // Save to StorageService
                          await StorageService.saveJournalText(_journalPreview);
                          print('Successfully saved journal text to StorageService');
                        } catch (e) {
                          print('Error saving journal text: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save journal entry: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          setState(() {
                            _isSaving = false;
                          });
                        }
                      } else {
                        print('No journal text to save');
                      }
                      
                      if (!_isSaving) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LogScreenStepFiveScreen.builder(context),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              );
                              var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              );
                              return FadeTransition(
                                opacity: fadeAnimation,
                                child: ScaleTransition(
                                  scale: scaleAnimation,
                                  child: child,
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 400),
                          ),
                        );
                      }
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
                      onTap: () async {
                        if (_isSaving) return;
                        
                        // Save journal text to StorageService only
                        if (_journalPreview.isNotEmpty) {
                          setState(() {
                            _isSaving = true;
                          });
                          
                          try {
                            // Save to StorageService
                            await StorageService.saveJournalText(_journalPreview);
                            print('Successfully saved journal text to StorageService');
                          } catch (e) {
                            print('Error saving journal text: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to save journal entry: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() {
                              _isSaving = false;
                            });
                          }
                        } else {
                          print('No journal text to save');
                        }
                        
                        if (!_isSaving) {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => LogScreenStepFiveScreen.builder(context),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  ),
                                );
                                var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  ),
                                );
                                return FadeTransition(
                                  opacity: fadeAnimation,
                                  child: ScaleTransition(
                                    scale: scaleAnimation,
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: Duration(milliseconds: 400),
                            ),
                          );
                        }
                      },
                      child: Text(
                        _isSaving ? "Saving..." : "Next",
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
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep3PositiveScreen.builder(context),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    );
                    var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    );
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 400),
                ),
              );
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
}

class WritingLinesPainter extends CustomPainter {
  final Color lineColor;
  final double lineSpacing;

  WritingLinesPainter({
    required this.lineColor,
    required this.lineSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withOpacity(0.35)
      ..strokeWidth = 1;

    double y = lineSpacing;
    while (y < size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
      y += lineSpacing;
    }
  }

  @override
  bool shouldRepaint(WritingLinesPainter oldDelegate) =>
      lineColor != oldDelegate.lineColor || lineSpacing != oldDelegate.lineSpacing;
}
