// import 'dart:developer';
// import 'dart:io';

// import '../../core/constants/api_endpoints.dart';
// import '../../core/network/api_client.dart';

// class CustomerRepository {
//   final ApiClient apiClient;

//   CustomerRepository(this.apiClient);

//   Future<List<Map<String, dynamic>>> fetchCustomers({
//     required String sourceType,
//     String? search,
//     String? municipalityName,
//     String? colonyName,
//     String? category,
//     String? authorizationStatus,
//     String? updatedAfter,
//     int? projectId,
//   }) async {
//     final response = await apiClient.getJson(
//       '${ApiEndpoints.customers}/$projectId/$sourceType',
//       query: {
//         'source_type': sourceType,
//         if (projectId != null) 'project_id': projectId.toString(),
//         if (search != null && search.isNotEmpty) 'search': search,
//         if (municipalityName != null && municipalityName.isNotEmpty)
//           'municipality_name': municipalityName,
//         if (colonyName != null && colonyName.isNotEmpty)
//           'colony_name': colonyName,
//         if (category != null && category.isNotEmpty) 'category': category,
//         if (authorizationStatus != null && authorizationStatus.isNotEmpty)
//           'authorization_status': authorizationStatus,
//         if (updatedAfter != null && updatedAfter.isNotEmpty)
//           'updated_after': updatedAfter,
//       },
//     );
//     log('Fetched customers: $response');
//     // Handle Laravel pagination response structure.
//     if (response.containsKey('data')) {
//       final data = response['data'];
//       if (data is List) {
//         return data
//             .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
//             .toList();
//       }
//     }
//     return [];
//   }

//   Future<Map<String, dynamic>> fetchCustomer(int id) async {
//     final response = await apiClient.getJson('${ApiEndpoints.customers}/$id');
//     // API returns customer directly or wrapped in 'data'
//     if (response.containsKey('data')) {
//       return response['data'] as Map<String, dynamic>;
//     }
//     return response;
//   }

//   // UPDATED: createCustomer with optional image files
//   Future<Map<String, dynamic>> createCustomer({
//     required int projectId,
//     required Map<String, dynamic> data,
//     Map<String, File>? imageFiles, // NEW: optional image files parameter
//   }) async {
//     try {
//       final endpoint = '${ApiEndpoints.customers}/$projectId';

//       log('=== CREATE CUSTOMER ===');
//       log('Endpoint: $endpoint');
//       log('Project ID: $projectId');
//       log('Data: $data');

//       if (imageFiles != null && imageFiles.isNotEmpty) {
//         log('Uploading ${imageFiles.length} images with customer');
//         log('Image fields: ${imageFiles.keys.toList()}');

//         // Use multipart request for images
//         final response = await apiClient.postMultipart(
//           endpoint,
//           data,
//           imageFiles,
//         );

//         log('Create customer (with images) response: $response');

//         // Handle response
//         if (response.containsKey('data')) {
//           return response['data'] as Map<String, dynamic>;
//         }
//         return response;
//       } else {
//         // Use regular POST for no images
//         log('Creating customer without images');
//         final response = await apiClient.postJson(
//           endpoint,
//           body: data,
//         );

//         log('Create customer response: $response');

//         // Handle response
//         if (response.containsKey('data')) {
//           return response['data'] as Map<String, dynamic>;
//         }
//         return response;
//       }
//     } catch (e, stackTrace) {
//       log('Error creating customer: $e');
//       log('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // UPDATED: updateCustomer with optional image files
//   Future<Map<String, dynamic>> updateCustomer(
//     int id,
//     Map<String, dynamic> data, {
//     Map<String, File>? imageFiles, // NEW: optional image files parameter
//   }) async {
//     try {
//       final endpoint = '${ApiEndpoints.customers}/$id';

//       log('=== UPDATE CUSTOMER ===');
//       log('Endpoint: $endpoint');
//       log('Customer ID: $id');
//       log('Update data: $data');

//       if (imageFiles != null && imageFiles.isNotEmpty) {
//         log('Uploading ${imageFiles.length} images with update');
//         log('Image fields: ${imageFiles.keys.toList()}');

//         // Use multipart request for images
//         final response = await apiClient.postMultipart(
//           endpoint,
//           data,
//           imageFiles,
//         );

//         log('Update customer (with images) response: $response');

//         if (response.containsKey('data')) {
//           return response['data'] as Map<String, dynamic>;
//         }
//         return response;
//       } else {
//         // Use regular POST for no images
//         log('Updating customer without images');
//         final response = await apiClient.postJson(
//           endpoint,
//           body: data,
//         );

//         log('Update customer response: $response');

//         if (response.containsKey('data')) {
//           return response['data'] as Map<String, dynamic>;
//         }
//         return response;
//       }
//     } catch (e, stackTrace) {
//       log('Error updating customer: $e');
//       log('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // Generic delete customer method (works for both bill and survey)
//   Future<Map<String, dynamic>> deleteCustomer(int id) async {
//     final response =
//         await apiClient.deleteJson('${ApiEndpoints.customers}/$id');

//     log('Delete customer response: $response');

//     return response;
//   }
// }

import 'dart:developer';
import 'dart:io';

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

  // UPDATED: createCustomer with optional image files
  Future<Map<String, dynamic>> createCustomer({
    required int projectId,
    required Map<String, dynamic> data,
    Map<String, File>? imageFiles, // NEW: optional image files parameter
  }) async {
    try {
      final endpoint = '${ApiEndpoints.customers}/$projectId';

      log('=== CREATE CUSTOMER ===');
      log('Endpoint: $endpoint');
      log('Project ID: $projectId');
      log('Data: $data');

      if (imageFiles != null && imageFiles.isNotEmpty) {
        log('Uploading ${imageFiles.length} images with customer');
        log('Image fields: ${imageFiles.keys.toList()}');

        // Use multipart request for images
        final response = await apiClient.postMultipart(
          endpoint,
          data,
          imageFiles,
        );

        log('Create customer (with images) response: $response');

        // Handle response
        if (response.containsKey('data')) {
          return response['data'] as Map<String, dynamic>;
        }
        return response;
      } else {
        // Use regular POST for no images
        log('Creating customer without images');
        final response = await apiClient.postJson(
          endpoint,
          body: data,
        );

        log('Create customer response: $response');

        // Handle response
        if (response.containsKey('data')) {
          return response['data'] as Map<String, dynamic>;
        }
        return response;
      }
    } catch (e, stackTrace) {
      log('Error creating customer: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // UPDATED: updateCustomer with optional image files
  Future<Map<String, dynamic>> updateCustomer(
    int id,
    Map<String, dynamic> data, {
    Map<String, File>? imageFiles, // NEW: optional image files parameter
  }) async {
    try {
      final endpoint = '${ApiEndpoints.customers}/$id';

      log('=== UPDATE CUSTOMER ===');
      log('Endpoint: $endpoint');
      log('Customer ID: $id');
      log('Update data (before): $data');

      if (imageFiles != null && imageFiles.isNotEmpty) {
        log('Uploading ${imageFiles.length} images with update');
        log('Image fields: ${imageFiles.keys.toList()}');

        // ✅ IMPORTANT FIX: Add _method for Laravel multipart PUT
        // Laravel multipart requests mein PUT method directly support nahi karta
        // Isliye _method field add karna zaroori hai
        data['_method'] = 'PUT';
        log('Added _method: PUT for Laravel multipart request');
        log('Update data (after): $data');

        // Use multipart request for images
        final response = await apiClient.postMultipart(
          endpoint,
          data,
          imageFiles,
        );

        log('Update customer (with images) response: $response');

        if (response.containsKey('data')) {
          return response['data'] as Map<String, dynamic>;
        }
        return response;
      } else {
        // Use regular PUT for no images (PUT method works fine without multipart)
        log('Updating customer without images (using PUT method)');
        final response = await apiClient.putJson(
          endpoint,
          body: data,
        );

        log('Update customer response: $response');

        if (response.containsKey('data')) {
          return response['data'] as Map<String, dynamic>;
        }
        return response;
      }
    } catch (e, stackTrace) {
      log('Error updating customer: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Alternative update method with different endpoint if needed
  Future<Map<String, dynamic>> updateCustomerWithImages(
    int id,
    Map<String, dynamic> data,
    Map<String, File> imageFiles,
  ) async {
    try {
      // Try different endpoint if main one doesn't work
      final endpoint = '${ApiEndpoints.customers}/$id/update';

      log('=== UPDATE CUSTOMER WITH IMAGES (ALTERNATIVE) ===');
      log('Endpoint: $endpoint');
      log('Customer ID: $id');
      log('Image count: ${imageFiles.length}');

      // Still need _method for Laravel
      data['_method'] = 'PUT';

      final response = await apiClient.postMultipart(
        endpoint,
        data,
        imageFiles,
      );

      log('Alternative update response: $response');

      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
      return response;
    } catch (e, stackTrace) {
      log('Error in alternative update: $e');
      rethrow;
    }
  }

  // Separate method for image-only upload
  Future<Map<String, dynamic>> uploadCustomerImages(
    int id,
    Map<String, File> imageFiles,
  ) async {
    try {
      final endpoint = '${ApiEndpoints.customers}/$id/images';

      log('=== UPLOAD CUSTOMER IMAGES ===');
      log('Endpoint: $endpoint');
      log('Customer ID: $id');
      log('Images: ${imageFiles.keys.toList()}');

      final data = {
        '_method': 'POST',
        'source_type': 'survey',
      };

      final response = await apiClient.postMultipart(
        endpoint,
        data,
        imageFiles,
      );

      log('Image upload response: $response');

      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
      return response;
    } catch (e, stackTrace) {
      log('Error uploading images: $e');
      rethrow;
    }
  }

  // Generic delete customer method (works for both bill and survey)
  Future<Map<String, dynamic>> deleteCustomer(int id) async {
    final response =
        await apiClient.deleteJson('${ApiEndpoints.customers}/$id');

    log('Delete customer response: $response');

    return response;
  }
}
