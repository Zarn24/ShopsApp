import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBhoWyfbAWnj0k8KSqHsARw3f9jS6ygAK4');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(response.body);
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
  // Get an instance of SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Check if the 'userData' key exists in SharedPreferences
  if (!prefs.containsKey('userData')) {
    // If 'userData' key doesn't exist, return false
    return false;
  }
  
  // Retrieve the userDataString from SharedPreferences
  final userDataString = prefs.getString('userData');
  
  // Check if userDataString is null
  if (userDataString == null) {
    // If userDataString is null, return false
    return false;
  }
  
  // Decode the userDataString into a Map<String, dynamic>
  final extractedUserData = json.decode(userDataString) as Map<String, dynamic>;
  
  // Retrieve the expiryDate from the decoded userData
  final expiryDateString = extractedUserData['expiryDate'] as String?;
  
  // Check if expiryDateString is null
  if (expiryDateString == null) {
    // If expiryDateString is null, return false
    return false;
  }
  
  // Parse the expiryDate string into a DateTime object
  final expiryDate = DateTime.parse(expiryDateString);
  
  // Check if the expiryDate is before the current time
  if (expiryDate.isBefore(DateTime.now())) {
    // If the expiryDate is before the current time, return false
    return false;
  }
  
  // Extract the token and userId from the userData
  _token = extractedUserData['token'] as String?;
  _userId = extractedUserData['userId'] as String?;
  
  // Set the expiryDate and start auto logout timer
  _expiryDate = expiryDate;
  notifyListeners();
  _autoLogout();
  
  // Return true indicating successful auto login
  return true;
}


  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}


