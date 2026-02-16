import 'package:data_care_app/data/models/projects_model.dart';
import 'package:data_care_app/data/repositories/projects_repository%20copy.dart';
import 'package:data_care_app/core/constants/api_endpoints.dart';
import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/features/bill_distribution/screens/new_bill_distribution/bill_distribution_map_screen.dart';
import 'package:data_care_app/features/survey_data/screens/new_survey/survey_list_screen.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  final ProjectRepository projectRepository;
  final Function(Project)? onProjectUpdated;

  const ProjectDetailScreen({
    Key? key,
    required this.project,
    required this.projectRepository,
    this.onProjectUpdated,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Project _currentProject;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late ApiClient _apiClient;
  bool _isLoading = false;
  bool _isUpdating = false;
  bool _isColoniesLoading = false;
  bool _isSettingDefaultColony = false;
  String _colonySearchQuery = '';
  String? _coloniesError;
  List<_Colony> _colonies = [];
  _Colony? _selectedColony;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
    _apiClient = ApiClient(storage: LocalStorage());
    _nameController = TextEditingController(text: _currentProject.name);
    _descriptionController = TextEditingController(
      text: _currentProject.description,
    );
    _loadColonies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProject() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorDialog('Project name cannot be empty');
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      // Create updated project object for API
      final updatedProjectData = _currentProject.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      // Call API to update project
      final updatedProject = await widget.projectRepository.updateProject(
        _currentProject.id,
        updatedProjectData,
      );

      // Update local state with API response
      setState(() {
        _currentProject = updatedProject;
      });

      // Update controllers with new values
      _nameController.text = updatedProject.name;
      _descriptionController.text = updatedProject.description;

      // Notify parent if callback is provided
      if (widget.onProjectUpdated != null) {
        widget.onProjectUpdated!(updatedProject);
      }

      Navigator.pop(context); // Close edit dialog
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Failed to update project: ${e.toString()}');
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  void _showEditDialog(BuildContext context) {
    // Update controllers with current values
    _nameController.text = _currentProject.name;
    _descriptionController.text = _currentProject.description;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Edit Project',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              Text(
                                'ID: ${_currentProject.id}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_isUpdating)
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF718096),
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Form Fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Project Name *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter project name',
                            filled: true,
                            fillColor: const Color(0xFFF7FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF667eea),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter project description (optional)',
                            filled: true,
                            fillColor: const Color(0xFFF7FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF667eea),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '* Required field',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF718096),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Loading Indicator
                    if (_isUpdating)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
                        ),
                      ),

                    // Action Buttons
                    if (!_isUpdating)
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF718096),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _updateProject,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF667eea),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF48BB78),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Project updated successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF56565).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFF56565),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF56565),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadColonies({bool keepSelection = true}) async {
    setState(() {
      _isColoniesLoading = true;
      _coloniesError = null;
    });

    try {
      final response = await _apiClient.getJson(ApiEndpoints.colonies);
      final coloniesData = response['data'];
      if (coloniesData is! List) {
        throw Exception('Invalid colonies response format');
      }

      final colonies = coloniesData
          .whereType<Map<String, dynamic>>()
          .map(_Colony.fromJson)
          .toList();

      _Colony? nextSelectedColony;
      if (keepSelection && _selectedColony != null) {
        nextSelectedColony = _findColonyById(colonies, _selectedColony!.id);
      }
      nextSelectedColony ??= colonies.where((c) => c.isDefault).isNotEmpty
          ? colonies.firstWhere((c) => c.isDefault)
          : null;

      if (!mounted) return;
      setState(() {
        _colonies = colonies;
        _selectedColony = nextSelectedColony;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _coloniesError = 'Failed to load colonies';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load colonies: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isColoniesLoading = false;
      });
    }
  }

  _Colony? _findColonyById(List<_Colony> list, int id) {
    for (final colony in list) {
      if (colony.id == id) return colony;
    }
    return null;
  }

  Future<_Colony?> _showColonyPicker() async {
    _colonySearchQuery = '';
    return showModalBottomSheet<_Colony>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            final filteredColonies = _colonies.where((colony) {
              final query = _colonySearchQuery.trim().toLowerCase();
              if (query.isEmpty) return true;
              return colony.name.toLowerCase().contains(query) ||
                  colony.code.toLowerCase().contains(query);
            }).toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Colony',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        modalSetState(() {
                          _colonySearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by colony name or code',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFF667eea)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: filteredColonies.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'No colonies found',
                                  style: TextStyle(color: Color(0xFF718096)),
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: filteredColonies.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final colony = filteredColonies[index];
                                final isSelected =
                                    _selectedColony?.id == colony.id;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () => Navigator.pop(context, colony),
                                  title: Text(
                                    colony.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  subtitle: Text(
                                    colony.code,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (colony.isDefault)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF48BB78)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Default',
                                            style: TextStyle(
                                              color: Color(0xFF48BB78),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF667eea),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectColony() async {
    if (_isColoniesLoading || _colonies.isEmpty) return;
    final selected = await _showColonyPicker();
    if (selected == null || !mounted) return;
    setState(() {
      _selectedColony = selected;
    });
  }

  Future<void> _setSelectedColonyAsDefault() async {
    final selected = _selectedColony;
    if (selected == null || _isSettingDefaultColony) return;

    setState(() {
      _isSettingDefaultColony = true;
    });

    try {
      await _apiClient.postJson(
        ApiEndpoints.setDefaultColony,
        body: {'colony_id': selected.id},
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selected.name} marked as default colony'),
          backgroundColor: Colors.green.shade600,
        ),
      );
      await _loadColonies();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set default colony: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSettingDefaultColony = false;
      });
    }
  }

  Widget _buildColonySelectorSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Colony',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _isColoniesLoading ? null : _selectColony,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                color: const Color(0xFFF7FAFC),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _isColoniesLoading
                        ? const Text(
                            'Loading colonies...',
                            style: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            _selectedColony == null
                                ? 'Select a colony'
                                : '${_selectedColony!.name} (${_selectedColony!.code})',
                            style: TextStyle(
                              color: _selectedColony == null
                                  ? const Color(0xFF718096)
                                  : const Color(0xFF2D3748),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  if (_isColoniesLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else ...[
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF667eea),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF667eea),
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_coloniesError != null) ...[
            const SizedBox(height: 8),
            Text(
              _coloniesError!,
              style: const TextStyle(
                color: Color(0xFFF56565),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (_selectedColony != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _selectedColony!.isDefault,
                  onChanged:
                      (_selectedColony!.isDefault || _isSettingDefaultColony)
                          ? null
                          : (value) {
                              if (value == true) {
                                _setSelectedColonyAsDefault();
                              }
                            },
                ),
                Expanded(
                  child: Text(
                    _selectedColony!.isDefault
                        ? 'This is the default colony'
                        : _isSettingDefaultColony
                            ? 'Setting default colony...'
                            : 'Mark selected colony as default',
                    style: const TextStyle(
                      color: Color(0xFF4A5568),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            const Text(
              'Please select a colony first. Then Bill Distribution and Survey Data will be enabled.',
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2D3748),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentProject.name,
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'ID: ${_currentProject.id}',
              style: const TextStyle(
                color: Color(0xFF718096),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
            ),
            onPressed: () {
              _showEditDialog(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Project Info Card
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.folder_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Project Information',
                                style: TextStyle(
                                  color: Color(0xFF718096),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _currentProject.name,
                                style: const TextStyle(
                                  color: Color(0xFF2D3748),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (_currentProject.description.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  _currentProject.description,
                                  style: const TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildColonySelectorSection(),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          context,
                          'Bill Distribution',
                          'Manage bills and invoices',
                          Icons.receipt_long_rounded,
                          const Color(0xFF667eea),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillDistributionMapScreen(
                                  projectId: _currentProject.id,
                                  colonyId: _selectedColony?.id,
                                  colonyName: _selectedColony?.name,
                                ),
                              ),
                            );
                          },
                          isEnabled: _selectedColony != null,
                        ),
                        const SizedBox(height: 10),
                        _buildActionButton(
                          context,
                          'Survey Data',
                          'View and analyze surveys',
                          Icons.poll_rounded,
                          const Color(0xFF48BB78),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurveyListScreen(
                                    projectId: _currentProject.id),
                              ),
                            );
                          },
                          isEnabled: _selectedColony != null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isEnabled = true,
  }) {
    final buttonColor = isEnabled ? color : const Color(0xFFA0AEC0);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: buttonColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isEnabled
                              ? const Color(0xFF2D3748)
                              : const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: buttonColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Colony {
  final int id;
  final String code;
  final String name;
  final bool isDefault;

  const _Colony({
    required this.id,
    required this.code,
    required this.name,
    required this.isDefault,
  });

  factory _Colony.fromJson(Map<String, dynamic> json) {
    return _Colony(
      id: int.tryParse(json['id'].toString()) ?? 0,
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      isDefault: json['is_default'] == true,
    );
  }
}
