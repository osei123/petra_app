import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/preferences_service.dart';

class PressureScreen extends StatefulWidget {
  const PressureScreen({super.key});

  @override
  State<PressureScreen> createState() => _PressureScreenState();
}

class _PressureScreenState extends State<PressureScreen> {
  final TextEditingController _inputController = TextEditingController();
  final _prefs = PreferencesService();
  String _fromUnit = 'psi';
  String _toUnit = 'bar';
  String _result = '';

  final Map<String, double> _conversionRates = {
    'psi': 1.0,
    'bar': 0.0689476,
    'kPa': 6.89476,
    'MPa': 0.00689476,
    'atm': 0.068046,
    'inHg': 2.03602,
    'mmHg': 51.7149,
  };

  @override
  void initState() {
    super.initState();
    _fromUnit = _prefs.defaultPressureUnit;
    _toUnit = _prefs.defaultPressureUnit == 'psi' ? 'bar' : 'psi';
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
          'Pressure Converter',
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
                    'Common Pressure Units',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PSI (pounds per square inch)\n'
                    'Bar (bar)\n'
                    'kPa (kilopascal)\n'
                    'MPa (megapascal)\n'
                    'ATM (atmosphere)\n'
                    'inHg (inches of mercury)\n'
                    'mmHg (millimeters of mercury)',
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
