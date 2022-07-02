import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';

class GeocodeLocation {
  static Future<String?> getAddress(double? lat, double? lot) async {
    if (lat == null || lot == null) return null;
    
    await dotenv.load();
    final googleGeocoding = GoogleGeocoding(dotenv.get('GEOCODE_API', fallback: 'API_URL not found'));
    
    final res = await googleGeocoding.geocoding.getReverse(LatLon(lat, lot));

    final result = res?.results;

    int? length = result?[0].addressComponents?.length;

    late String? city;

    for (int i = 0; i < length!; i++) {
      int? len = result?[0].addressComponents?[i].types?.length;
      for (int j = 0; j < len!; j++) {
        var selected = result?[0].addressComponents?[i].types?[j];
        switch (selected) {
          case "administrative_area_level_2" :
            city = result?[0].addressComponents?[i].longName;
          break;
        }
      }
    }

    return city;
  }
}