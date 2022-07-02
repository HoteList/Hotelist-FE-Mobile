// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';
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
      image: json['user']['image'] == null ? "" : json['user']['image'],
      lat: json['user']['lat'],
      lot: json['user']['lot'],
      role: json['user']['role'] == null ? "" : json['user']['role'],
    );
  }

  factory User.fromJson2(Map<String, dynamic> json) {
    return User(
      token: "",
      id: json['id'],
      email: json['email'],
      full_name: json['full_name'],
      username: json['username'],
      image: json['image'] == null ? "" : json['user']['image'],
      lat: json['lat'],
      lot: json['lot'],
      role: json['role'],
    );
  }

}

Future<User> signup(String full_name, String username, String email, String password, String password_confirmation) async {
  final response = await http.post(
    Uri.parse('https://hotelist-be.herokuapp.com/api/register'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'full_name': full_name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation
    })
  );
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    print(jsonDecode(response.body));
    throw Exception('Failed to register User');
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

Future<User> getUser() async {
  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse("https://hotelist-be.herokuapp.com/api/auth/user"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    return User.fromJson2(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get User');
  }
}

Future<User> updateUser(String full_name, String email, String username, String image) async {
  final token = await UserSecureStorage.getToken();
  final id = await UserSecureStorage.getId();

  final response = await http.put(
    Uri.parse("https://hotelist-be.herokuapp.com/api/user"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    },
    body: jsonEncode(<String, String> {
      'id': id!,
      'username': username,
      'email': email,
      'full_name': full_name,
      'image': image
    })
  );

  if (response.statusCode == 200) {
    return User.fromJson2(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update User');
  }

}