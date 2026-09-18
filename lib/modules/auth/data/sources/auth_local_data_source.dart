import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user_model.dart';
import '../../../../core/constants/api_constants.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(AuthUserModel user);
  Future<AuthUserModel?> getUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveAadhar(String aadhar);
  Future<String?> getAadhar();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveUser(AuthUserModel user) async {
    await _prefs.setString(ApiConstants.userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<AuthUserModel?> getUser() async {
    final userJson = _prefs.getString(ApiConstants.userKey);
    if (userJson != null) {
      try {
        return AuthUserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(ApiConstants.tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(ApiConstants.tokenKey);
  }

  /// Cache the student's Aadhar number after dashboard bootstrap
  @override
  Future<void> saveAadhar(String aadhar) async {
    await _prefs.setString(ApiConstants.aadharKey, aadhar);
  }

  @override
  Future<String?> getAadhar() async {
    return _prefs.getString(ApiConstants.aadharKey);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(ApiConstants.userKey);
    await _prefs.remove(ApiConstants.tokenKey);
    await _prefs.remove(ApiConstants.aadharKey);
  }
}
