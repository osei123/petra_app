import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/preferences_service.dart';

class FlowRateScreen extends StatefulWidget {
  const FlowRateScreen({super.key});

  @override
  State<FlowRateScreen> createState() => _FlowRateScreenState();
}

class _FlowRateScreenState extends State<FlowRateScreen> {
  final TextEditingController _inputController = TextEditingController();
  final _prefs = PreferencesService();
  String _fromUnit = 'bbl/d';
  String _toUnit = 'm3/d';
  String _result = '';

  final Map<String, double> _conversionRates = {
    'bbl/d': 1.0,           // Barrels per day
    'm3/d': 0.158987,       // Cubic meters per day
    'ft3/d': 5.61458,       // Cubic feet per day
    'gal/d': 42.0,          // Gallons per day
    'l/d': 158.987,         // Liters per day
    'bbl/h': 24.0,          // Barrels per hour
    'm3/h': 3.81577,        // Cubic meters per hour
    'ft3/h': 134.75,        // Cubic feet per hour
    'gal/h': 1008.0,        // Gallons per hour
    'l/h': 3815.77,         // Liters per hour
    'bbl/min': 1440.0,      // Barrels per minute
    'm3/min': 228.946,      // Cubic meters per minute
    'ft3/min': 8085.0,      // Cubic feet per minute
    'gal/min': 60480.0,     // Gallons per minute
    'l/min': 228946.0,      // Liters per minute
  };

  @override
  void initState() {
    super.initState();
    _fromUnit = _prefs.defaultFlowRateUnit;
    _toUnit = _prefs.defaultFlowRateUnit == 'bbl/d' ? 'm3/d' : 'bbl/d';
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
      double result = inputValue * _conversionRates[_toUnit]! / _conversionRates[_fromUnit]!;
      
      setState(() {
        _result = _prefs.showDecimalPlaces 
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
          'Flow Rate Converter',
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
            colors: [
              Colors.teal[900]!,
              Colors.teal[800]!,
            ],
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
                            items: _conversionRates.keys.map((String unit) {
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
                            items: _conversionRates.keys.map((String unit) {
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
                    'Common Flow Rate Units',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BBL/D (Barrels per day)\n'
                    'M³/D (Cubic meters per day)\n'
                    'FT³/D (Cubic feet per day)\n'
                    'GAL/D (Gallons per day)\n'
                    'L/D (Liters per day)\n'
                    'BBL/H (Barrels per hour)\n'
                    'M³/H (Cubic meters per hour)\n'
                    'FT³/H (Cubic feet per hour)\n'
                    'GAL/H (Gallons per hour)\n'
                    'L/H (Liters per hour)\n'
                    'BBL/MIN (Barrels per minute)\n'
                    'M³/MIN (Cubic meters per minute)\n'
                    'FT³/MIN (Cubic feet per minute)\n'
                    'GAL/MIN (Gallons per minute)\n'
                    'L/MIN (Liters per minute)',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Image.asset(
                    'assets/petra_logo.png',
                    height: 60,
                    width: 60,
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