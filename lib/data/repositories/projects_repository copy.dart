import 'dart:convert';
import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/constants/api_endpoints.dart';
import 'package:data_care_app/data/models/projects_model.dart';

class ProjectRepository {
  final ApiClient _apiClient;

  ProjectRepository(this._apiClient);

  // Get all projects
  Future<List<Project>> getProjects() async {
    try {
      final response = await _apiClient.getJson(ApiEndpoints.projects);
      final projectResponse = ProjectResponse.fromJson(response);
      return projectResponse.data;
    } catch (e) {
      throw Exception('Failed to fetch projects: $e');
    }
  }

  // Get single project by ID
  Future<Project> getProjectById(int id) async {
    try {
      final response = await _apiClient.getJson(ApiEndpoints.projectById(id));
      return Project.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to fetch project: $e');
    }
  }

  // Create new project
  Future<Project> createProject(Project project) async {
    try {
      final response = await _apiClient.postJson(
        ApiEndpoints.projects,
        body: project.toRequestJson(),
      );

      // Check if response has 'data' field
      final responseData = response['data'] ?? response;
      return Project.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  // Update project
  Future<Project> updateProject(int id, Project project) async {
    try {
      final response = await _apiClient.putJson(
        ApiEndpoints.projectById(id),
        body: project.toRequestJson(),
      );

      final responseData = response['data'] ?? response;
      return Project.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  // Delete project
  // Future<void> deleteProject(int id) async {
  //   try {
  //     await _apiClient.deleteJson(ApiEndpoints.projectById(id));
  //   } catch (e) {
  //     throw Exception('Failed to delete project: $e');
  //   }
  // }

  // Update project status
  Future<Project> updateProjectStatus(int id, String status) async {
    try {
      final response = await _apiClient.putJson(
        ApiEndpoints.projectById(id),
        body: {'status': status},
      );

      final responseData = response['data'] ?? response;
      return Project.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to update project status: $e');
    }
  }
}
