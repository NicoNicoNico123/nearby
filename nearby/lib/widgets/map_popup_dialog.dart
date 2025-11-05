import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import '../services/map_service.dart';
import '../theme/app_theme.dart';
import '../utils/logger.dart';

class MapPopupDialog extends StatelessWidget {
  final String venueName;
  final double latitude;
  final double longitude;

  const MapPopupDialog({
    super.key,
    required this.venueName,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Open in Maps',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),

            // Venue info
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Venue',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    venueName,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSM),
                  Row(
                    children: [
                      Icon(
                        Icons.gps_fixed,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMD),

            // Map options
            FutureBuilder<List<AvailableMap>>(
              future: MapService.getAvailableMaps(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildWebMapOption(context);
                }

                final availableMaps = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Choose a map app:',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSM),
                    ...availableMaps.map((map) => _buildMapOption(context, map)),
                    const SizedBox(height: AppTheme.spacingSM),
                    _buildWebMapOption(context),
                  ],
                );
              },
            ),

            const SizedBox(height: AppTheme.spacingMD),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapOption(BuildContext context, AvailableMap map) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
      child: ElevatedButton.icon(
        onPressed: () async {
          Navigator.of(context).pop();
          try {
            await MapLauncher.showMarker(
              mapType: map.mapType,
              coords: Coords(latitude, longitude),
              title: venueName,
              description: venueName,
            );
            Logger.info('Opened ${map.mapName} with location: $venueName');
          } catch (e) {
            Logger.error('Failed to open ${map.mapName}', error: e);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Could not open ${map.mapName}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        icon: Icon(
          map.mapType == MapType.google ? Icons.map : Icons.map_outlined,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          map.mapName,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildWebMapOption(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        Navigator.of(context).pop();
        try {
          await MapService.launchMap(
            latitude: latitude,
            longitude: longitude,
            venueName: venueName,
          );
        } catch (e) {
          Logger.error('Failed to open web map', error: e);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open map'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      icon: const Icon(
        Icons.language,
        color: Colors.white,
        size: 20,
      ),
      label: const Text(
        'Open in Web Map',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Helper function to show the map popup dialog
Future<void> showMapPopupDialog({
  required BuildContext context,
  required String venueName,
  required double latitude,
  required double longitude,
}) {
  return showDialog(
    context: context,
    builder: (context) => MapPopupDialog(
      venueName: venueName,
      latitude: latitude,
      longitude: longitude,
    ),
  );
}