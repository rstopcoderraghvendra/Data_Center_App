import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userTokenKey = 'user_token';
  static const String _userEmailKey = 'user_email';

  AuthRepository(this.apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiClient.postJson(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );
    final token = response['token']?.toString() ?? '';
    if (token.isNotEmpty) {
      await apiClient.setToken(token);
      await _saveLoginState(email, token);
    }
    return response;
  }

  Future<void> _saveLoginState(String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userTokenKey, token);
    await prefs.setString(_userEmailKey, email);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (isLoggedIn) {
      final token = prefs.getString(_userTokenKey);
      if (token != null && token.isNotEmpty) {
        // Set token in apiClient for future requests
        await apiClient.setToken(token);
        return true;
      }
    }

    return false;
  }

  Future<Map<String, dynamic>> me() async {
    return apiClient.getJson(ApiEndpoints.me);
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    return apiClient.putJson(ApiEndpoints.profile, body: data);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    await apiClient.postJson(
      ApiEndpoints.changePassword,
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }

  // Future<void> logout() async {
  //   await apiClient.postJson(ApiEndpoints.logout);
  //   await apiClient.clearToken();
  // }

  Future<void> logout() async {
    try {
      await apiClient.postJson(ApiEndpoints.logout);
    } catch (e) {
      // Even if logout API fails, clear local data
      print('Logout API error: $e');
    } finally {
      await apiClient.clearToken();
      await _clearLoginState();
    }
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userTokenKey);
    await prefs.remove(_userEmailKey);
  }
}
