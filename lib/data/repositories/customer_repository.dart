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
    int? projectId,
  }) async {
    final response = await apiClient.getJson(
      '${ApiEndpoints.customers}/$projectId/$sourceType',
      query: {
        'source_type': sourceType,
        if (projectId != null) 'project_id': projectId.toString(),
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
    // Handle Laravel pagination response structure.
    if (response.containsKey('data')) {
      final data = response['data'];
      if (data is List) {
        return data
            .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
            .toList();
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchCustomer(int id) async {
    final response = await apiClient.getJson('${ApiEndpoints.customers}/$id');
    // API returns customer directly or wrapped in 'data'
    if (response.containsKey('data')) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  // Future<Map<String, dynamic>> updateCustomer(
  //   int id,
  //   Map<String, dynamic> data,
  // ) async {
  //   final response =
  //       await apiClient.putJson('${ApiEndpoints.customers}/$id', body: data);
  //   // API returns {'message': ..., 'data': ...}
  //   if (response.containsKey('data')) {
  //     return response['data'] as Map<String, dynamic>;
  //   }
  //   return response;
  // }

  // Future<Map<String, dynamic>> createCustomer(
  //   int projectId,
  //   Map<String, dynamic> data,
  // ) async {
  //   final response = await apiClient
  //       .postJson('${ApiEndpoints.customers}/$projectId', body: data);
  //   // API returns {'message': ..., 'data': ...}
  //   log('Creating customer at: $response');
  //   if (response.containsKey('data')) {
  //     return response['data'] as Map<String, dynamic>;
  //   }
  //   return response;
  // }

  // Future<Map<String, dynamic>> syncUpdates(
  //   List<Map<String, dynamic>> updates,
  // ) async {
  //   return apiClient.postJson(ApiEndpoints.sync, body: {'updates': updates});
  // }
  Future<Map<String, dynamic>> createCustomer({
    required int projectId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Note: Yeh /survey endpoint nahi hai, direct /customers/{projectId}
      final endpoint = '${ApiEndpoints.customers}/$projectId';

      log('Creating survey at: $endpoint');
      log('Survey data: $data');

      // Ensure source_type is included

      final response = await apiClient.postJson(
        endpoint,
        body: data,
      );

      log('Create survey response: $response');

      // Handle response
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
      return response;
    } catch (e, stackTrace) {
      log('Error creating survey: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Generic update customer method (works for both bill and survey)
  Future<Map<String, dynamic>> updateCustomer(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.putJson(
      '${ApiEndpoints.customers}/$id',
      body: data,
    );

    log('Update customer response: $response');

    if (response.containsKey('data')) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  // Generic delete customer method (works for both bill and survey)
  // Future<Map<String, dynamic>> deleteCustomer(int id) async {
  //   final response = await apiClient.deleteJson('${ApiEndpoints.customers}/$id');

  //   log('Delete customer response: $response');

  //   return response;
  // }
}
