// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String token;
  final int id;
  final String email;
  final String full_name;
  final String username;
  final String image;
  final String lat;
  final String lot;
  final String role;

  const User({
    required this.token,
    required this.id,
    required this.email,
    required this.full_name,
    required this.username,
    required this.image,
    required this.lat,
    required this.lot,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      id: json['user']['id'],
      email: json['user']['email'],
      full_name: json['user']['full_name'],
      username: json['user']['username'],
      image: json['user']['image'],
      lat: json['user']['lat'],
      lot: json['user']['lot'],
      role: json['user']['role'],
    );
  }

}

Future<User> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('https://hotelist-be.herokuapp.com/api/login'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'username': username,
      'password': password
    })
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get User');
  }
}