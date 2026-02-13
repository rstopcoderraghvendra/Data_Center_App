import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userTokenKey = 'user_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userTypeKey = 'user_type';
  static const String _userIdKey = 'user_id';
  static const String _isAccessKey = 'is_access';

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
    final userData = response['user'] as Map<String, dynamic>? ?? {};
    final userName = userData['name']?.toString() ?? '';
    final userType = userData['user_type']?.toString() ?? '';
    final userId = userData['id']?.toString() ?? '';
    final isAccess = userData['is_access']?.toString()?.toLowerCase() ?? 'user';

    if (token.isNotEmpty) {
      await apiClient.setToken(token);
      await _saveLoginState(email, token, userName, userType, userId, isAccess);
    }

    return response;
  }

  Future<void> _saveLoginState(String email, String token, String userName,
      String userType, String userId, String isAccess) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userTokenKey, token);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userTypeKey, userType);
    await prefs.setString(_isAccessKey, isAccess);
    await prefs.setString(_userIdKey, userId);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? '';
  }

  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? '';
  }

  Future<String> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey) ?? '';
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey) ?? '';
    return int.tryParse(userId) ?? 0;
  }

  Future<String> getIsAccess() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isAccessKey) ?? 'user';
  }

  // Check if user is admin based on is_access field
  Future<bool> isAdmin() async {
    final isAccess = await getIsAccess();
    return isAccess.toLowerCase() == 'admin';
  }

  Future<bool> isUser() async {
    final isAccess = await getIsAccess();
    return isAccess.toLowerCase() == 'user';
  }

  Future<bool> isManager() async {
    final isAccess = await getIsAccess();
    return isAccess.toLowerCase() == 'manager';
  }

  Future<bool> hasPermission(String requiredAccess) async {
    final isAccess = await getIsAccess();
    return isAccess.toLowerCase() == requiredAccess.toLowerCase();
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

  Future<Map<String, dynamic>> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey) ?? '',
      'email': prefs.getString(_userEmailKey) ?? '',
      'user_type': prefs.getString(_userTypeKey) ?? '',
      'user_id': prefs.getString(_userIdKey) ?? '',
      'is_access': prefs.getString(_isAccessKey) ?? 'user',
    };
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
    await prefs.remove(_userNameKey);
    await prefs.remove(_userTypeKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_isAccessKey);
  }

  // Get user token for API calls
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTokenKey);
  }
}
