import 'package:country_picker/country_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class CountryHelper {
  /// Fetches the user's current country based on GPS
  static Future<Country?> getCurrentCountry() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null; // User denied
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null; // Permanently denied
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.low, // Low accuracy is enough for country
      );

      // Get placemark from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String? countryCode = placemarks.first.isoCountryCode;
        if (countryCode != null && countryCode.isNotEmpty) {
          // Find matching country from country_picker package
          return Country.parse(countryCode);
        }
      }
    } catch (e) {
      print('❌ Error getting location: $e');
    }

    return null; // Default return
  }
}
