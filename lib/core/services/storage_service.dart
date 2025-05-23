import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:io';

class StorageService {
  static const String _dateTimeKey = 'selected_date_time';
  static const String _toggledIconsKey = 'toggled_icons';
  static const String _selectedContactsKey = 'selected_contacts';
  static const String _locationNameKey = 'location_name';
  static const String _locationCoordsKey = 'location_coords';
  static const String _positiveFeelingKey = 'positive_feelings';
  static const String _negativeFeelingKey = 'negative_feelings';
  static const String _positiveIntensityKey = 'positive_intensity';
  static const String _negativeIntensityKey = 'negative_intensity';
  static const String _currentMoodKey = 'current_mood';
  static const String _moodSourceKey = 'mood_source';
  static const String _mapScreenshotKey = 'map_screenshot';
  static const String _selectedPhotosKey = 'selected_photos';
  static const String _selectedPhotoPathsKey = 'selected_photo_paths';
  static const String _selectedPhotoBase64Key = 'selected_photo_base64';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Date/Time
  static Future<void> saveSelectedDateTime(DateTime dateTime) async {
    await _prefs.setString(_dateTimeKey, dateTime.toIso8601String());
  }

  static Future<DateTime?> getSelectedDateTime() async {
    final String? dateStr = _prefs.getString(_dateTimeKey);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // Toggled Icons
  static Future<void> saveToggledIcons(Set<String> icons) async {
    final List<String> iconList = icons.toList();
    await _prefs.setStringList(_toggledIconsKey, iconList);
  }

  static Set<String> getToggledIcons() {
    final List<String>? iconList = _prefs.getStringList(_toggledIconsKey);
    return iconList?.map((e) => e.toString()).toSet() ?? <String>{};
  }

  // Selected Contacts
  static Future<void> saveSelectedContacts(List<Contact> contacts) async {
    final List<Map<String, dynamic>> contactData = contacts.map((contact) {
      return {
        'displayName': contact.displayName ?? '',
        'avatar': contact.avatar != null ? base64Encode(contact.avatar!) : null,
        'phones': contact.phones?.map((phone) => phone.value).toList() ?? [],
        'emails': contact.emails?.map((email) => email.value).toList() ?? [],
      };
    }).toList();
    await _prefs.setString(_selectedContactsKey, jsonEncode(contactData));
  }

  static Future<List<Contact>> getSelectedContacts() async {
    final String? contactsJson = _prefs.getString(_selectedContactsKey);
    if (contactsJson == null) return [];
    
    try {
      final List<dynamic> contactData = jsonDecode(contactsJson);
      return contactData.map((data) {
        final Map<String, dynamic> contactMap = data as Map<String, dynamic>;
        final Contact contact = Contact(
          displayName: contactMap['displayName'] as String?,
          phones: (contactMap['phones'] as List<dynamic>?)?.map((phone) => 
            Item(label: 'mobile', value: phone.toString())).toList(),
          emails: (contactMap['emails'] as List<dynamic>?)?.map((email) => 
            Item(label: 'email', value: email.toString())).toList(),
        );
        if (contactMap['avatar'] != null) {
          contact.avatar = base64Decode(contactMap['avatar'] as String);
        }
        return contact;
      }).toList();
    } catch (e) {
      print('Error loading contacts: $e');
      return [];
    }
  }

  // Location
  static Future<void> saveSelectedLocation(String location) async {
    await _prefs.setString(_locationNameKey, location);
  }

  static String? getSelectedLocation() {
    return _prefs.getString(_locationNameKey);
  }

  static Future<void> saveLocationCoordinates(double lat, double lng) async {
    final Map<String, double> coords = {'lat': lat, 'lng': lng};
    await _prefs.setString(_locationCoordsKey, jsonEncode(coords));
  }

  static Map<String, double>? getLocationCoordinates() {
    final String? coordsStr = _prefs.getString(_locationCoordsKey);
    if (coordsStr == null) return null;
    
    final Map<String, dynamic> coords = jsonDecode(coordsStr);
    return {
      'lat': coords['lat'] as double,
      'lng': coords['lng'] as double,
    };
  }

  // Feelings
  static Future<void> savePositiveFeelings(List<String> feelings) async {
    await _prefs.setStringList(_positiveFeelingKey, feelings);
  }

  static List<String> getPositiveFeelings() {
    return _prefs.getStringList(_positiveFeelingKey) ?? [];
  }

  static Future<void> saveNegativeFeelings(List<String> feelings) async {
    await _prefs.setStringList(_negativeFeelingKey, feelings);
  }

  static List<String> getNegativeFeelings() {
    return _prefs.getStringList(_negativeFeelingKey) ?? [];
  }

  // Feeling Intensities
  static Future<void> savePositiveIntensities(Map<String, double> intensities) async {
    await _prefs.setString(_positiveIntensityKey, jsonEncode(intensities));
  }

  static Map<String, double> getPositiveIntensities() {
    final String? intensitiesStr = _prefs.getString(_positiveIntensityKey);
    if (intensitiesStr == null) return {};
    
    final Map<String, dynamic> intensities = jsonDecode(intensitiesStr);
    return intensities.map((key, value) => MapEntry(key, value as double));
  }

  static Future<void> saveNegativeIntensities(Map<String, double> intensities) async {
    await _prefs.setString(_negativeIntensityKey, jsonEncode(intensities));
  }

  static Map<String, double> getNegativeIntensities() {
    final String? intensitiesStr = _prefs.getString(_negativeIntensityKey);
    if (intensitiesStr == null) return {};
    
    final Map<String, dynamic> intensities = jsonDecode(intensitiesStr);
    return intensities.map((key, value) => MapEntry(key, value as double));
  }

  // Current Mood
  static Future<void> saveCurrentMood(String mood, String source) async {
    await _prefs.setString(_currentMoodKey, mood);
    await _prefs.setString(_moodSourceKey, source);
  }

  static String? getCurrentMood() {
    return _prefs.getString(_currentMoodKey);
  }

  static String? getMoodSource() {
    return _prefs.getString(_moodSourceKey);
  }

  // Selected Track
  static Future<void> saveSelectedTrack(Map<String, dynamic> track) async {
    print('Saving track to storage: $track'); // Debug log
    await _prefs.setString('selected_track', jsonEncode(track));
  }

  static Future<Map<String, dynamic>?> getSelectedTrack() async {
    final trackJson = _prefs.getString('selected_track');
    print('Getting track from storage: $trackJson'); // Debug log
    if (trackJson != null) {
      return jsonDecode(trackJson) as Map<String, dynamic>;
    }
    return null;
  }

  // Map Screenshot
  static Future<void> saveMapScreenshot(Uint8List screenshot) async {
    await _prefs.setString(_mapScreenshotKey, base64Encode(screenshot));
  }

  static Future<Uint8List?> getMapScreenshot() async {
    final String? screenshotStr = _prefs.getString(_mapScreenshotKey);
    if (screenshotStr == null) return null;
    try {
      return base64Decode(screenshotStr);
    } catch (e) {
      print('Error decoding map screenshot: $e');
      return null;
    }
  }

  // Journal Text
  static Future<String?> getJournalText() async {
    return _prefs.getString('journal_text');
  }

  static Future<void> saveJournalText(String text) async {
    await _prefs.setString('journal_text', text);
  }

  // Selected Photos
  static Future<void> saveSelectedPhotos(List<File> photos) async {
    final List<String> photoPaths = photos.map((photo) => photo.path).toList();
    await _prefs.setStringList(_selectedPhotosKey, photoPaths);
  }

  static Future<List<File>> getSelectedPhotos() async {
    final List<String>? photoPaths = _prefs.getStringList(_selectedPhotosKey);
    if (photoPaths == null) return [];
    return photoPaths.map((path) => File(path)).toList();
  }

  // Selected Photo Paths
  static Future<void> saveSelectedPhotoPaths(List<String> paths) async {
    await _prefs.setStringList(_selectedPhotoPathsKey, paths);
  }

  static Future<List<String>> getSelectedPhotoPaths() async {
    return _prefs.getStringList(_selectedPhotoPathsKey) ?? [];
  }

  // Selected Photo Base64
  static Future<void> saveSelectedPhotoBase64(List<String> base64Photos) async {
    await _prefs.setStringList(_selectedPhotoBase64Key, base64Photos);
  }

  static Future<List<String>> getSelectedPhotoBase64() async {
    return _prefs.getStringList(_selectedPhotoBase64Key) ?? [];
  }

  // Maps Link
  static Future<void> saveMapsLink(String mapsLink) async {
    await _prefs.setString('maps_link', mapsLink);
  }

  static Future<String?> getMapsLink() async {
    return _prefs.getString('maps_link');
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _prefs.remove(_dateTimeKey);
    await _prefs.remove(_toggledIconsKey);
    await _prefs.remove(_selectedContactsKey);
    await _prefs.remove(_locationNameKey);
    await _prefs.remove(_locationCoordsKey);
    await _prefs.remove(_positiveFeelingKey);
    await _prefs.remove(_negativeFeelingKey);
    await _prefs.remove(_positiveIntensityKey);
    await _prefs.remove(_negativeIntensityKey);
    await _prefs.remove(_currentMoodKey);
    await _prefs.remove(_moodSourceKey);
    await _prefs.remove(_mapScreenshotKey);
    await _prefs.remove(_selectedPhotosKey);
    await _prefs.remove(_selectedPhotoPathsKey);
    await _prefs.remove(_selectedPhotoBase64Key);
    await _prefs.remove('maps_link');
  }
} 