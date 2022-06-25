import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class Transaction {
  final int id;
  final int room_id;
  final String room_detail_name;
  final String hotel_name;
  final int user_id;
  final String book_date;

  const Transaction({
    required this.id,
    required this.room_id,
    required this.room_detail_name,
    required this.hotel_name,
    required this.user_id,
    required this.book_date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      room_id: json['room_id'],
      room_detail_name: json['room_detail_name'],
      hotel_name: json['hotel_name'],
      user_id: json['user_id'],
      book_date: json['book_date'],
    );
  }
}

Future<List<Transaction>> getTransactionsByUserId() async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse('https://hotelist-be.herokuapp.com/api/transaction/user'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    List<Transaction> transactions = 
      (jsonDecode(response.body) as List)
      .map((data) => Transaction.fromJson(data)).toList();

    return transactions;
  } else {
    throw Exception('Failed to get Transaction');
  }
}

Future<List<Transaction>> getTransactionByRoomId(String room_id) async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse("https://hotelist-be.herokuapp.com/api/transaction/room/${room_id}"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    List<Transaction> transactions = 
      (jsonDecode(response.body) as List)
      .map((data) => Transaction.fromJson(data)).toList();

    return transactions;
  } else {
    throw Exception('Failed to get Transaction');
  }
}

Future<List<Transaction>> getTransactionByRoomIdAtTime(String room_id, String date) async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse("https://hotelist-be.herokuapp.com/api/transaction/room/${room_id}/time/${date}"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    List<Transaction> transactions = 
      (jsonDecode(response.body) as List)
      .map((data) => Transaction.fromJson(data)).toList();

    return transactions;
  } else {
    throw Exception('Failed to get Transaction');
  }
}

Future<Transaction> getTransactionById(String id) async {

  final token = await UserSecureStorage.getToken();

  final response = await http.get(
    Uri.parse("https://hotelist-be.herokuapp.com/api/transaction/id/${id}"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    }
  );

  if (response.statusCode == 200) {
    return Transaction.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get Transaction');
  }
}

Future<Transaction> addTransaction(String room_id, String book_date) async {
  final token = await UserSecureStorage.getToken();

  final response = await http.post(
    Uri.parse("https://hotelist-be.herokuapp.com/api/transaction"),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token.toString()
    },
    body: <String, String> {
      'room_id': room_id,
      'book_date': book_date
    }
  );

  if (response.statusCode == 200) {
    return Transaction.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(jsonDecode(response.body).errors);
  }
}