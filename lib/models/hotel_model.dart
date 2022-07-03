import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class Hotel {
  final int id;
  final String? name;
  final String? description;
  final String? lat;
  final String? lot;
  final String? image;
  final int capacity;

  const Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.lat,
    required this.lot,
    required this.image,
    required this.capacity
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      lat: json['lat'],
      lot: json['lot'],
      capacity: json['capacity'],
    );
  }

}

Future<List<Hotel>> getHotels(String query) async {
  
  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse('https://hotelist-be.herokuapp.com/api/hotel'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    final List hotels = jsonDecode(response.body);

    return hotels.map((json) => Hotel.fromJson(json)).where((hotel) {
      final nameLower = hotel.name!.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();
  } else {
    throw Exception('Failed to get Hotel');
  }
}

Future<Hotel> getHotelById(String id) async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse("https://hotelist-be.herokuapp.com/api/hotel/"+id),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    return Hotel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get Hotel');
  }
}