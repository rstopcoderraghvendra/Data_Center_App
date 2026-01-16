import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

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
    }
    return response;
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
    await apiClient.postJson(ApiEndpoints.logout);
    await apiClient.clearToken();
  }
}
