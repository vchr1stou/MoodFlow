import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  static Future<void> saveToggledIcons(Set<int> icons) async {
    final List<String> iconList = icons.map((e) => e.toString()).toList();
    await _prefs.setStringList(_toggledIconsKey, iconList);
  }

  static Set<int> getToggledIcons() {
    final List<String>? iconList = _prefs.getStringList(_toggledIconsKey);
    return iconList?.map((e) => int.parse(e)).toSet() ?? {};
  }

  // Selected Contacts
  static Future<void> saveSelectedContacts(List<String> contacts) async {
    await _prefs.setStringList(_selectedContactsKey, contacts);
  }

  static List<String> getSelectedContacts() {
    return _prefs.getStringList(_selectedContactsKey) ?? [];
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
  }
} 