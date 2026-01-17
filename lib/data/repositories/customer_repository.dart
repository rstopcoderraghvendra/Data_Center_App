import 'dart:developer';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class CustomerRepository {
  final ApiClient apiClient;

  CustomerRepository(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchCustomers({
    required String sourceType,
    String? search,
    String? municipalityName,
    String? colonyName,
    String? category,
    String? authorizationStatus,
    String? updatedAfter,
  }) async {
    final response = await apiClient.getJson(
      ApiEndpoints.customers,
      query: {
        'source_type': sourceType,
        if (search != null && search.isNotEmpty) 'search': search,
        if (municipalityName != null && municipalityName.isNotEmpty)
          'municipality_name': municipalityName,
        if (colonyName != null && colonyName.isNotEmpty)
          'colony_name': colonyName,
        if (category != null && category.isNotEmpty) 'category': category,
        if (authorizationStatus != null && authorizationStatus.isNotEmpty)
          'authorization_status': authorizationStatus,
        if (updatedAfter != null && updatedAfter.isNotEmpty)
          'updated_after': updatedAfter,
      },
    );
    log('Fetched customers: $response');
    // Handle Laravel pagination response
    final data = response['data'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    // Fallback: if response is directly a list
    if (response is List) {
      return (response as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchCustomer(int id) async {
    return apiClient.getJson('${ApiEndpoints.customers}/$id');
  }

  Future<Map<String, dynamic>> updateCustomer(
    int id,
    Map<String, dynamic> data,
  ) async {
    return apiClient.putJson('${ApiEndpoints.customers}/$id', body: data);
  }

  Future<Map<String, dynamic>> createCustomer(
    Map<String, dynamic> data,
  ) async {
    return apiClient.postJson(ApiEndpoints.customers, body: data);
  }

  Future<Map<String, dynamic>> syncUpdates(
    List<Map<String, dynamic>> updates,
  ) async {
    return apiClient.postJson(ApiEndpoints.sync, body: {'updates': updates});
  }
}
