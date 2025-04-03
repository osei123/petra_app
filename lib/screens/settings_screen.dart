import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/preferences_service.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _prefs = PreferencesService();
  bool _showDecimalPlaces = true;
  int _decimalPlaces = 4;
  String _defaultPressureUnit = 'psi';
  String _defaultVolumeUnit = 'bbl';
  String _defaultFlowRateUnit = 'bbl/d';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _showDecimalPlaces = _prefs.showDecimalPlaces;
      _decimalPlaces = _prefs.decimalPlaces;
      _defaultPressureUnit = _prefs.defaultPressureUnit;
      _defaultVolumeUnit = _prefs.defaultVolumeUnit;
      _defaultFlowRateUnit = _prefs.defaultFlowRateUnit;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setShowDecimalPlaces(_showDecimalPlaces);
    await _prefs.setDecimalPlaces(_decimalPlaces);
    await _prefs.setDefaultPressureUnit(_defaultPressureUnit);
    await _prefs.setDefaultVolumeUnit(_defaultVolumeUnit);
    await _prefs.setDefaultFlowRateUnit(_defaultFlowRateUnit);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[900],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[900]!, Colors.teal[800]!],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Display Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Dark Mode', style: GoogleFonts.poppins()),
                      value: isDarkMode,
                      onChanged: (bool value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                    SwitchListTile(
                      title: Text(
                        'Show Decimal Places',
                        style: GoogleFonts.poppins(),
                      ),
                      value: _showDecimalPlaces,
                      onChanged: (bool value) {
                        setState(() {
                          _showDecimalPlaces = value;
                        });
                        _saveSettings();
                      },
                    ),
                    if (_showDecimalPlaces)
                      ListTile(
                        title: Text(
                          'Decimal Places',
                          style: GoogleFonts.poppins(),
                        ),
                        subtitle: Slider(
                          value: _decimalPlaces.toDouble(),
                          min: 0,
                          max: 8,
                          divisions: 8,
                          label: _decimalPlaces.toString(),
                          onChanged: (double value) {
                            setState(() {
                              _decimalPlaces = value.round();
                            });
                            _saveSettings();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Default Units',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _defaultPressureUnit,
                      decoration: const InputDecoration(
                        labelText: 'Default Pressure Unit',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          [
                            'psi',
                            'bar',
                            'kPa',
                            'MPa',
                            'atm',
                            'inHg',
                            'mmHg',
                          ].map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit.toUpperCase()),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _defaultPressureUnit = newValue;
                          });
                          _saveSettings();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _defaultVolumeUnit,
                      decoration: const InputDecoration(
                        labelText: 'Default Volume Unit',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          [
                            'bbl',
                            'm3',
                            'ft3',
                            'gal',
                            'l',
                            'cm3',
                            'in3',
                            'yd3',
                            'mm3',
                          ].map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit.toUpperCase()),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _defaultVolumeUnit = newValue;
                          });
                          _saveSettings();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _defaultFlowRateUnit,
                      decoration: const InputDecoration(
                        labelText: 'Default Flow Rate Unit',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          [
                            'bbl/d',
                            'm3/d',
                            'ft3/d',
                            'gal/d',
                            'l/d',
                            'bbl/h',
                            'm3/h',
                            'ft3/h',
                            'gal/h',
                            'l/h',
                          ].map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit.toUpperCase()),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _defaultFlowRateUnit = newValue;
                          });
                          _saveSettings();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Petra - Oil & Gas Unit Converter\n'
                      'Version 1.0.0\n\n'
                      'A simple and efficient tool for converting common oil and gas units.',
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/petra_logo.png',
              height: 130,
              width: 130,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
