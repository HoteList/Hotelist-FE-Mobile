import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocode/geocode.dart';
import 'package:google_geocoding/google_geocoding.dart';

class GeocodeLocation {
  // ignore: prefer_const_constructors
  static Future<String?> getAddress(double? lat, double? lot) async {
    if (lat == null || lot == null) return "";
    GeoCode geoCode = GeoCode();
    Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: lot);
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
    // await dotenv.load();
    // final googleGeocoding = await GoogleGeocoding(dotenv.get('GEOCODE_API', fallback: 'API_URL not found'));
    // print(await googleGeocoding.geocoding.getReverse(LatLon(lat, lot)));
    // return await googleGeocoding.geocoding.getReverse(LatLon(lat, lot));
  }
}