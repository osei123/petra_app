import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/preferences_service.dart';

class VolumeScreen extends StatefulWidget {
  const VolumeScreen({super.key});

  @override
  State<VolumeScreen> createState() => _VolumeScreenState();
}

class _VolumeScreenState extends State<VolumeScreen> {
  final TextEditingController _inputController = TextEditingController();
  final _prefs = PreferencesService();
  String _fromUnit = 'bbl';
  String _toUnit = 'm3';
  String _result = '';

  final Map<String, double> _conversionRates = {
    'bbl': 1.0, // Barrel (US)
    'm3': 0.158987, // Cubic meter
    'ft3': 5.61458, // Cubic foot
    'gal': 42.0, // US Gallon
    'l': 158.987, // Liter
    'cm3': 158987.0, // Cubic centimeter
    'in3': 9702.0, // Cubic inch
    'yd3': 0.207947, // Cubic yard
    'mm3': 158987000.0, // Cubic millimeter
  };

  @override
  void initState() {
    super.initState();
    _fromUnit = _prefs.defaultVolumeUnit;
    _toUnit = _prefs.defaultVolumeUnit == 'bbl' ? 'm3' : 'bbl';
  }

  void _convert() {
    if (_inputController.text.isEmpty) {
      setState(() {
        _result = '';
      });
      return;
    }

    try {
      double inputValue = double.parse(_inputController.text);
      double result =
          inputValue *
          _conversionRates[_toUnit]! /
          _conversionRates[_fromUnit]!;

      setState(() {
        _result =
            _prefs.showDecimalPlaces
                ? result.toStringAsFixed(_prefs.decimalPlaces)
                : result.toStringAsFixed(0);
      });
    } catch (e) {
      setState(() {
        _result = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Volume Converter',
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
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [Colors.teal[900]!, Colors.teal[800]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter value',
                              border: const OutlineInputBorder(),
                              suffixText: _fromUnit,
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            onChanged: (value) => _convert(),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _fromUnit,
                            decoration: const InputDecoration(
                              labelText: 'From Unit',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                _conversionRates.keys.map((String unit) {
                                  return DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit.toUpperCase()),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _fromUnit = newValue;
                                });
                                _convert();
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
                        children: [
                          Text(
                            _result.isEmpty ? '0.0000' : _result,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _toUnit,
                            decoration: const InputDecoration(
                              labelText: 'To Unit',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                _conversionRates.keys.map((String unit) {
                                  return DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit.toUpperCase()),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _toUnit = newValue;
                                });
                                _convert();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Common Volume Units',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BBL (US Barrel)\n'
                    'M³ (Cubic Meter)\n'
                    'FT³ (Cubic Foot)\n'
                    'GAL (US Gallon)\n'
                    'L (Liter)\n'
                    'CM³ (Cubic Centimeter)\n'
                    'IN³ (Cubic Inch)\n'
                    'YD³ (Cubic Yard)\n'
                    'MM³ (Cubic Millimeter)',
                    style: GoogleFonts.poppins(color: Colors.white70),
                    textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
