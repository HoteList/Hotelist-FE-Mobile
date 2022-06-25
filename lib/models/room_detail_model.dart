import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class RoomDetail {
  final int id;
  final String? name;
  final String? price;
  final int? capacity;
  final String? description;
  final String? image;
  final int hotel_id;

  const RoomDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.capacity,
    required this.description,
    required this.image,
    required this.hotel_id
  });

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    return RoomDetail(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      capacity: json['capacity'],
      description: json['description'],
      image: json['image'],
      hotel_id: json['hotel_id'],
    );
  }

}

Future<List<RoomDetail>> getRoomDetailsByHotelId(int hotelId) async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse('https://hotelist-be.herokuapp.com/api/roomDetails/hotel/${hotelId}'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    List<RoomDetail> roomDetails = 
      (jsonDecode(response.body) as List)
      .map((data) => RoomDetail.fromJson(data)).toList();

    return roomDetails;
  } else {
    throw Exception('Failed to get Room Details');
  }
}

Future<RoomDetail> getRoomDetailsById(String id) async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse("https://hotelist-be.herokuapp.com/api/roomDetails/${id}"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    return RoomDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get Room Details');
  }
}