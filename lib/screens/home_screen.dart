import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> conversionOptions = [
      {
        'title': 'Pressure',
        'icon': Icons.speed,
        'color': Colors.blue,
        'route': '/pressure',
      },
      {
        'title': 'Volume',
        'icon': Icons.water_drop,
        'color': Colors.green,
        'route': '/volume',
      },
      {
        'title': 'Flow Rate',
        'icon': Icons.waves,
        'color': Colors.orange,
        'route': '/flow-rate',
      },
      {
        'title': 'Settings',
        'icon': Icons.settings,
        'color': Colors.purple,
        'route': '/settings',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Petra',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unit Converter',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a conversion type',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: conversionOptions.length,
                  itemBuilder: (context, index) {
                    final option = conversionOptions[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, option['route']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              option['icon'],
                              size: 48,
                              color: option['color'],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              option['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
