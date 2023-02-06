import 'dart:convert';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../global/environment.dart';

class AuthServices with ChangeNotifier {
  late Usuario usuario;
  bool _authenticating = false;
  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;

  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final data = {'email': email, 'password': password};

    try {
      final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'}).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      authenticating = false;

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _saveToken(loginResponse.token);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    final data = {'nombre': name, 'email': email, 'password': password};

    try {
      final resp = await http.post(Uri.parse('${Environment.apiUrl}/new'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'}).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      authenticating = false;

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _saveToken(loginResponse.token);

        return true;
      } else {
        final respBody = jsonDecode(resp.body);
        return respBody['msg'];
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/renew'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': token.toString()
          }).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _saveToken(loginResponse.token);

        print(token);

        return true;
      } else {
        logout();
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
