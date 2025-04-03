import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  static SharedPreferences? _prefs;

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Display Settings
  bool get isDarkMode => _prefs?.getBool('isDarkMode') ?? false;
  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('isDarkMode', value);
  }

  bool get showDecimalPlaces => _prefs?.getBool('showDecimalPlaces') ?? true;
  Future<void> setShowDecimalPlaces(bool value) async {
    await _prefs?.setBool('showDecimalPlaces', value);
  }

  int get decimalPlaces => _prefs?.getInt('decimalPlaces') ?? 4;
  Future<void> setDecimalPlaces(int value) async {
    await _prefs?.setInt('decimalPlaces', value);
  }

  // Default Units
  String get defaultPressureUnit => _prefs?.getString('defaultPressureUnit') ?? 'psi';
  Future<void> setDefaultPressureUnit(String value) async {
    await _prefs?.setString('defaultPressureUnit', value);
  }

  String get defaultVolumeUnit => _prefs?.getString('defaultVolumeUnit') ?? 'bbl';
  Future<void> setDefaultVolumeUnit(String value) async {
    await _prefs?.setString('defaultVolumeUnit', value);
  }

  String get defaultFlowRateUnit => _prefs?.getString('defaultFlowRateUnit') ?? 'bbl/d';
  Future<void> setDefaultFlowRateUnit(String value) async {
    await _prefs?.setString('defaultFlowRateUnit', value);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
} 