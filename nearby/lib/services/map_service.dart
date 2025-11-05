import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/logger.dart';

class MapService {
  static Future<void> launchMap({
    required double latitude,
    required double longitude,
    required String venueName,
  }) async {
    try {
      if (kIsWeb) {
        await _launchWebMap(latitude, longitude, venueName);
      } else {
        await _launchNativeMap(latitude, longitude, venueName);
      }
    } catch (e) {
      Logger.error('Failed to launch map', error: e);
      // Fallback to web map
      await _launchWebMap(latitude, longitude, venueName);
    }
  }

  static Future<void> _launchNativeMap(double latitude, double longitude, String venueName) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      // Check if we're in simulator/emulator environment
      final isSimulator = await _isRunningInSimulator();

      if (availableMaps.isEmpty || isSimulator) {
        // No maps installed or running in simulator, fallback to web
        Logger.info('No native maps available or running in simulator, using web maps');
        await _launchWebMap(latitude, longitude, venueName);
        return;
      }

      // Prefer Google Maps on Android, Apple Maps on iOS
      AvailableMap preferredMap;
      if (Platform.isAndroid) {
        final googleMap = availableMaps.where((map) => map.mapType == MapType.google).firstOrNull;
        preferredMap = googleMap ?? availableMaps.first;
      } else if (Platform.isIOS) {
        final appleMap = availableMaps.where((map) => map.mapType == MapType.apple).firstOrNull;
        preferredMap = appleMap ?? availableMaps.first;
      } else {
        // Use first available map as fallback
        preferredMap = availableMaps.first;
      }

      await MapLauncher.showMarker(
        mapType: preferredMap.mapType,
        coords: Coords(latitude, longitude),
        title: venueName,
        description: venueName,
      );

      Logger.info('Launched ${preferredMap.mapName} with location: $venueName');
    } catch (e) {
      Logger.error('Failed to launch native map, falling back to web', error: e);
      await _launchWebMap(latitude, longitude, venueName);
    }
  }

  static Future<bool> _isRunningInSimulator() async {
    if (kIsWeb) return true;

    // iOS Simulator detection
    if (Platform.isIOS) {
      // In simulator, map_launcher often returns empty or limited results
      try {
        final availableMaps = await MapLauncher.installedMaps;
        // If no maps are available, likely running in simulator
        return availableMaps.isEmpty;
      } catch (e) {
        Logger.info('Could not check for maps, assuming simulator environment');
        return true;
      }
    }

    // Android Emulator detection
    if (Platform.isAndroid) {
      try {
        final availableMaps = await MapLauncher.installedMaps;
        // Many emulators don't have Google Maps pre-installed
        return !availableMaps.any((map) => map.mapType == MapType.google);
      } catch (e) {
        Logger.info('Could not check for maps, assuming emulator environment');
        return true;
      }
    }

    return false;
  }

  static Future<void> _launchWebMap(double latitude, double longitude, String venueName) async {
    try {
      final encodedVenue = Uri.encodeComponent(venueName);
      // Use directions URL which works better in simulator environments
      final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude+$encodedVenue';

      final uri = Uri.parse(url);

      if (kIsWeb) {
        // On web, launch in same tab
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
          Logger.info('Launched web map (web) with location: $venueName');
        } else {
          Logger.error('Could not launch web map URL: $url');
          throw Exception('Could not launch map');
        }
      } else {
        // On desktop/simulator, try external application first
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          Logger.info('Launched web map (external) with location: $venueName');
        } else {
          // Fallback: try in-app launch
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
          Logger.info('Launched web map (in-app) with location: $venueName');
        }
      }
    } catch (e) {
      Logger.error('Failed to launch web map', error: e);
      throw Exception('Could not launch map: ${e.toString()}');
    }
  }

  static Future<bool> hasMapsInstalled() async {
    if (kIsWeb) return true; // Web always has web maps available

    try {
      final availableMaps = await MapLauncher.installedMaps;
      return availableMaps.isNotEmpty;
    } catch (e) {
      Logger.error('Error checking for installed maps', error: e);
      return false;
    }
  }

  static Future<List<AvailableMap>> getAvailableMaps() async {
    if (kIsWeb) return []; // Web uses web maps

    try {
      return await MapLauncher.installedMaps;
    } catch (e) {
      Logger.error('Error getting available maps', error: e);
      return [];
    }
  }
}