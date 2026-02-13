import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/model/survey_model/survey_model.dart';
import 'package:data_care_app/features/survey_data/screens/new_survey/survey_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyListScreen extends StatefulWidget {
  final int? projectId;
  const SurveyListScreen({super.key, this.projectId});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _searchController = TextEditingController();
  late final CustomerRepository _repository;
  late Future<List<Survey>> _futureSurveys;
  String _searchQuery = '';
  bool _showSearchBar = false;
  bool _isLoading = false;
  bool _hasMore = true;

  // Pagination variables
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  // Store fetched surveys
  List<Survey> _allSurveys = [];

  @override
  void initState() {
    super.initState();
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _futureSurveys = _fetchSurveys();
    _verticalScrollController.addListener(_onScroll);
  }

  Future<List<Survey>> _fetchSurveys() async {
    try {
      final data = await _repository.fetchCustomers(
          projectId: widget.projectId, sourceType: 'survey');
      setState(() {
        _allSurveys = data.map((item) => Survey.fromJson(item)).toList();
      });
      return _allSurveys;
    } catch (e) {
      throw Exception('Failed to load surveys: $e');
    }
  }

  void _onScroll() {
    if (_verticalScrollController.position.pixels >=
            _verticalScrollController.position.maxScrollExtent - 50 &&
        _hasMore &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 0;
      _futureSurveys = _fetchSurveys();
    });
    await _futureSurveys;
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentPage++;
      _isLoading = false;
      final totalItemsLoaded = (_currentPage + 1) * _itemsPerPage;
      _hasMore = totalItemsLoaded < _filteredData.length;
    });
  }

  List<Survey> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _allSurveys;
    }

    return _allSurveys.where((survey) {
      final query = _searchQuery.toLowerCase();
      return (survey.name?.toLowerCase() ?? '').contains(query) ||
          (survey.mobileNo?.toLowerCase() ?? '').contains(query) ||
          (survey.category?.toLowerCase() ?? '').contains(query) ||
          (survey.colonyName?.toLowerCase() ?? '').contains(query) ||
          (survey.municipalityName?.toLowerCase() ?? '').contains(query) ||
          (survey.addressOfProperty?.toLowerCase() ?? '').contains(query);
    }).toList();
  }

  List<Survey> get _paginatedData {
    final filtered = _filteredData;
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex =
        ((_currentPage + 1) * _itemsPerPage).clamp(0, filtered.length);

    if (startIndex >= endIndex) return [];
    return filtered.sublist(startIndex, endIndex);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 0;
      _hasMore = (_itemsPerPage < _filteredData.length);
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        _searchQuery = '';
        _currentPage = 0;
        _hasMore = true;
      }
    });
  }

  Future<void> _navigateToAddSurvey() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          isEditMode: false,
          projectId: widget.projectId,
        ),
      ),
    );

    if (result != null && result is Survey) {
      try {
        // Prepare data for API - Add mode
        final surveyData = {
          'name': result.name,
          'municipality_name': result.municipalityName,
          'property_details_property_id': result.propertyDetailsPropertyId,
          'integrated_pid_property_id': result.integratedPidPropertyId,
          'integrated_pid_owner_occupier_name':
              result.integratedPidOwnerOccupierName,
          'area_of_authority': result.areaOfAuthority,
          'colony_name': result.colonyName,
          'address_of_property': result.addressOfProperty,
          'mobile_no': result.mobileNo,
          'category': result.category,
          'total_area': result.totalArea,
          'unit': result.unit,
          'authorization_status': result.authorizationStatus,
          'source_type': 'survey', // Important: Yeh survey hai
          'is_active': true, // New surveys are active by default
        };

        // API call - Generic createCustomer method use karenge
        final response = await _repository.createCustomer(
          projectId: widget.projectId!,
          data: surveyData,
        );
        // Convert response to Survey object
        final createdSurvey = Survey.fromJson(response);

        setState(() {
          _allSurveys.insert(0, createdSurvey);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Survey "${createdSurvey.name}" created successfully'),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create survey: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  Future<void> _navigateToEditSurvey(Survey survey) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          survey: survey,
          isEditMode: true,
          projectId: widget.projectId,
        ),
      ),
    );

    if (result != null && result is Survey) {
      try {
        // Prepare data for API - Edit mode
        final surveyData = {
          'name': result.name,
          'municipality_name': result.municipalityName,
          'property_details_property_id': result.propertyDetailsPropertyId,
          'integrated_pid_property_id': result.integratedPidPropertyId,
          'integrated_pid_owner_occupier_name':
              result.integratedPidOwnerOccupierName,
          'area_of_authority': result.areaOfAuthority,
          'colony_name': result.colonyName,
          'address_of_property': result.addressOfProperty,
          'mobile_no': result.mobileNo,
          'category': result.category,
          'total_area': result.totalArea,
          'unit': result.unit,
          'authorization_status': result.authorizationStatus,
          'is_active': result.isActive,
          'source_type': 'survey',
          // source_type update nahi karenge kyunki woh pehle se set hai
        };

        // API call - Generic updateCustomer method use karenge
        final response = await _repository.updateCustomer(
          result.id, // Survey ID
          surveyData,
        );

        // Convert response to Survey object
        final updatedSurvey = Survey.fromJson(response);

        setState(() {
          final index = _allSurveys.indexWhere((s) => s.id == updatedSurvey.id);
          if (index != -1) {
            _allSurveys[index] = updatedSurvey;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Survey "${updatedSurvey.name}" updated successfully'),
            backgroundColor: Colors.blue.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update survey: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, Survey survey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Survey',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete survey "${survey.name}"?',
          style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                // API call - Generic deleteCustomer method use karenge
                //await _repository.deleteCustomer(survey.id);

                setState(() {
                  _allSurveys.removeWhere((s) => s.id == survey.id);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Survey "${survey.name}" deleted successfully'),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete survey: $e'),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
        title: const Text(
          'Survey Distribution',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleSearchBar,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _showSearchBar ? Icons.close : Icons.search,
                color: const Color(0xFF2D3748),
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSearchBar ? 70 : 0,
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by Survey ID, Name, Mobile...',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: Color(0xFF718096)),
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: Color(0xFF667eea)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          icon: const Icon(Icons.clear, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF7FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF667eea), width: 1.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Survey>>(
              future: _futureSurveys,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (_allSurveys.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 120),
                      child: Text('No surveys found'),
                    ),
                  );
                }

                final paginatedSurveys = _paginatedData;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: paginatedSurveys.isEmpty && _searchQuery.isNotEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 120),
                              child:
                                  Text('No surveys found matching your search'),
                            ),
                          )
                        : Scrollbar(
                            thumbVisibility: true,
                            controller: _horizontalScrollController,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Table Header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Municipality',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Property ID',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              'Owner Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              'Property ID ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              'Owner/  Occupier Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              'Area Of the  Authority',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              'Name Of the Colony',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              'Address   of Property',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Mobile No.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Category',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Total Area',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Unit',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Actions',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Table Rows
                                    ...paginatedSurveys.map((survey) {
                                      return GestureDetector(
                                        onTap: () =>
                                            _navigateToEditSurvey(survey),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.municipalityName ??
                                                      '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.propertyDetailsPropertyId ??
                                                      '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.name.toString() ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.integratedPidPropertyId ??
                                                      '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.integratedPidOwnerOccupierName ??
                                                      '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.areaOfAuthority ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.colonyName ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  (survey.addressOfProperty
                                                                  ?.length ??
                                                              0) >
                                                          20
                                                      ? '${survey.addressOfProperty?.substring(0, 20)}...'
                                                      : survey.addressOfProperty ??
                                                          '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.mobileNo ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.category ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xFF2D3748),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.totalArea ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xFF2D3748),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.unit ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xFF2D3748),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 100,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: survey.isActive
                                                        ? Colors.green.shade50
                                                        : Colors.red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    survey.isActive
                                                        ? 'Active'
                                                        : 'Inactive',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: survey.isActive
                                                          ? Colors
                                                              .green.shade800
                                                          : Colors.red.shade800,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 80,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Edit Button
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.blue.shade50,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () =>
                                                            _navigateToEditSurvey(
                                                                survey),
                                                        icon: Icon(
                                                          Icons.menu,
                                                          size: 14,
                                                          color: Colors
                                                              .blue.shade700,
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        tooltip: 'Edit',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    // Delete Button
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade50,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          _showDeleteDialog(
                                                              context, survey);
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_rounded,
                                                          size: 14,
                                                          color: Colors
                                                              .red.shade700,
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        tooltip: 'Delete',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),

                                    // Loading indicator
                                    if (_isLoading)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),

                                    // No more data indicator
                                    if (!_hasMore &&
                                        paginatedSurveys.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Center(
                                          child: Text(
                                            'No more surveys to load',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF667eea),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _navigateToAddSurvey,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add New Survey',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
