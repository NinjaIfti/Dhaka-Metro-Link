// lib/presentation/pages/scan_card_page.dart
import 'package:flutter/material.dart';
import 'package:metro_link/core/theme/app_theme.dart';
import 'package:metro_link/core/utils/nfc_service.dart';

class ScanCardPage extends StatefulWidget {
  const ScanCardPage({Key? key}) : super(key: key);

  @override
  State<ScanCardPage> createState() => _ScanCardPageState();
}

class _ScanCardPageState extends State<ScanCardPage> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  String _scanResult = '';
  bool _hasError = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResult = '';
      _hasError = false;
    });

    try {
      final isNfcAvailable = await NfcService.checkNfcAvailability();
      if (!isNfcAvailable) {
        setState(() {
          _hasError = true;
          _scanResult = 'NFC is not available on this device.';
          _isScanning = false;
        });
        return;
      }

      final cardId = await NfcService.scanCardId();
      if (cardId != null) {
        setState(() {
          _scanResult = 'Card scanned successfully!\nCard ID: $cardId';
          _isScanning = false;
        });

        // Here you would typically process the card data
        // For example, look up the card in your database
        // or register a new card if it's not found
      } else {
        setState(() {
          _hasError = true;
          _scanResult = 'Failed to scan card. Please try again.';
          _isScanning = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _scanResult = 'Error: ${e.toString()}';
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Card'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isScanning) ...[
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            border: Border.all(
                              color: AppTheme.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.contactless,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Scanning for NFC card...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Hold your metro card near the back of your device.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ] else ...[
                Icon(
                  _hasError ? Icons.error_outline : Icons.contactless,
                  size: 80,
                  color: _hasError ? Colors.red : AppTheme.primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  _scanResult.isEmpty
                      ? 'Ready to scan your metro card'
                      : _scanResult,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _hasError ? Colors.red : null,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _startScan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Scan Card'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}