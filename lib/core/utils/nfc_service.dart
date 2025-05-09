// lib/core/utils/nfc_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcService {
  // Check if device has NFC capability
  static Future<bool> checkNfcAvailability() async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      return availability == NFCAvailability.available;
    } catch (e) {
      debugPrint('Error checking NFC availability: $e');
      return false;
    }
  }

  // Start NFC scan session
  static Future<String?> scanCardId() async {
    try {
      final tag = await FlutterNfcKit.poll();
      await FlutterNfcKit.finish();
      return tag.id; // Just return the basic ID
    } catch (e) {
      debugPrint('Error scanning NFC tag: $e');
      await FlutterNfcKit.finish();
      return null;
    }
  }
}