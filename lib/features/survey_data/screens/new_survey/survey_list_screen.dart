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

  // ✅ Server-side pagination variables - 10 items per page (Bill jaisa)
  List<Survey> _allSurveys = [];
  bool _isLoading = false;
  bool _isInitialLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10; // ✅ Changed from 50 to 10 (Bill jaisa)
  int _totalRecords = 0;

  String _searchQuery = '';
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    print('🔄 Initializing Survey List Screen...');
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _fetchSurveys(page: _currentPage, isInitial: true);
    _verticalScrollController.addListener(_onScroll);
  }

  // ✅ Server-side pagination with List response - 10 records per page (Bill jaisa)
  Future<void> _fetchSurveys(
      {required int page, String? search, bool isInitial = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isInitial) {
        _isInitialLoading = true;
      }
    });

    try {
      print(
          '📡 Fetching surveys from API - Page: $page, Search: $search, Limit: $_itemsPerPage');

      final response = await _repository.fetchCustomers(
        projectId: widget.projectId,
        sourceType: 'survey',
        search: search,
        page: page, // ✅ Page parameter add kiya
        limit: _itemsPerPage, // ✅ Limit parameter add kiya (10 records)
      );

      print('✅ API Response received: ${response.length} items');

      final newSurveys = response.map((item) => Survey.fromJson(item)).toList();

      setState(() {
        if (page == 1) {
          _allSurveys = newSurveys;
        } else {
          _allSurveys.addAll(newSurveys);
        }

        // ✅ Agar 10 records aaye toh aur honge, nahi toh khatam
        _hasMore = newSurveys.length >= _itemsPerPage;
        _totalRecords =
            page == 1 ? newSurveys.length : _totalRecords + newSurveys.length;
        _currentPage = page;
        _isLoading = false;
        _isInitialLoading = false;
      });

      print('✅ Loaded ${newSurveys.length} surveys');
      print(
          '📊 Total loaded: $_totalRecords, Has more: $_hasMore, Next page: ${page + 1}');
    } catch (e) {
      print('❌ Error fetching surveys: $e');
      setState(() {
        _isLoading = false;
        _isInitialLoading = false;
        _hasMore = false;
      });
    }
  }

  void _onScroll() {
    if (_verticalScrollController.position.pixels >=
            _verticalScrollController.position.maxScrollExtent -
                200 && // ✅ Reduced threshold (Bill jaisa)
        _hasMore &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _refresh() async {
    print('🔄 Refreshing survey list...');
    setState(() {
      _currentPage = 1;
      _allSurveys = [];
      _hasMore = true;
    });
    await _fetchSurveys(
        page: 1,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        isInitial: true);
    print('✅ Survey list refreshed');
  }

  Future<void> _loadMoreData() async {
    if (!_hasMore || _isLoading) return;

    final nextPage = _currentPage + 1;
    print('📦 Loading more data - Page $nextPage (${_itemsPerPage} items)');
    await _fetchSurveys(
        page: nextPage, search: _searchQuery.isEmpty ? null : _searchQuery);
  }

  void _onSearchChanged(String value) {
    print('🔍 Searching: $value');
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
      _allSurveys = [];
      _hasMore = true;
    });
    _fetchSurveys(
        page: 1, search: value.isEmpty ? null : value, isInitial: true);
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        _searchQuery = '';
        _currentPage = 1;
        _allSurveys = [];
        _hasMore = true;
        _fetchSurveys(page: 1, isInitial: true);
      }
    });
  }

  // ✅ Method to get background color based on verify_by (Bill jaisa)
  Color _getRowBackgroundColor(Survey survey) {
    if (survey.verify_by == "yes") {
      return Colors.green.shade50;
    }
    return Colors.white;
  }

  Future<void> _navigateToAddSurvey() async {
    print('🆕 Navigating to add survey form...');

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          isEditMode: false,
          projectId: widget.projectId,
          onSaveSuccess: () {
            print('📞 Form saved callback received');
            _refresh();
          },
        ),
      ),
    );

    if (result != null) {
      print('✅ Survey form completed, refreshing list...');
      await _refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Survey created successfully'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navigateToEditSurvey(Survey survey) async {
    print('✏️ Navigating to edit survey form for ID: ${survey.id}');

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          survey: survey,
          isEditMode: true,
          projectId: widget.projectId,
          onSaveSuccess: () {
            print('📞 Form update callback received');
            _refresh();
          },
        ),
      ),
    );

    if (result != null) {
      print('✅ Survey updated, refreshing list...');
      await _refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Survey updated successfully'),
          backgroundColor: Colors.blue.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
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
                print('🗑️ Deleting survey ID: ${survey.id}');

                setState(() {
                  _allSurveys.removeWhere((s) => s.id == survey.id);
                  _totalRecords--;
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
          // ✅ Search Bar (Bill jaisa)
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

          // ✅ Main Content - Server Side Pagination (10 per page - Bill jaisa)
          Expanded(
            child: _isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : _allSurveys.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 120),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.list_alt,
                                  color: Colors.grey[400], size: 60),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No surveys found'
                                    : 'No matching surveys found',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF718096),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Click the + button to add a new survey'
                                    : 'Try a different search term',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFA0AEC0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
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
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            scrollDirection: Axis.vertical,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _horizontalScrollController,
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ✅ Table Header (Bill jaisa)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          _buildHeaderCell('Municipality', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Property ID', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Owner Name', 120),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell(
                                              'Integrated PID', 120),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell(
                                              'Owner/Occupier', 120),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell(
                                              'Area of Authority', 120),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Colony Name', 120),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Address', 150),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Mobile No.', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Category', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Total Area', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Unit', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Status', 100),
                                          const SizedBox(width: 20),
                                          _buildHeaderCell('Actions', 80,
                                              center: true),
                                        ],
                                      ),
                                    ),

                                    // ✅ Table Rows - All records from server (Bill jaisa UI)
                                    ..._allSurveys.map((survey) {
                                      return GestureDetector(
                                        onTap: () =>
                                            _navigateToEditSurvey(survey),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            color:
                                                _getRowBackgroundColor(survey),
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                  width: 1),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Municipality
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.municipalityName ??
                                                      '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Property ID
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.propertyDetailsPropertyId ??
                                                      '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Owner Name
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.name ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Integrated PID
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.integratedPidPropertyId ??
                                                      '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Integrated Owner/Occupier
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.integratedPidOwnerOccupierName ??
                                                      '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Area of Authority
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.areaOfAuthority ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Colony Name
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  survey.colonyName ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Address
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  (survey.addressOfProperty
                                                                  ?.length ??
                                                              0) >
                                                          25
                                                      ? '${survey.addressOfProperty?.substring(0, 25)}...'
                                                      : survey.addressOfProperty ??
                                                          '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Mobile No
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.mobileNo ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Category
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.category ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Total Area
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.totalArea ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Unit
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  survey.unit ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Status
                                              SizedBox(
                                                width: 100,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: survey.isActive ==
                                                            true
                                                        ? Colors.green.shade50
                                                        : Colors.red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    survey.isActive == true
                                                        ? 'Active'
                                                        : 'Inactive',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: survey.isActive ==
                                                              true
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

                                              // Actions
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
                                                          Icons.edit_rounded,
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

                                    // ✅ Loading indicator for more data (Bill jaisa)
                                    if (_isLoading &&
                                        !_isInitialLoading &&
                                        _allSurveys.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),

                                    // ✅ NO MORE DATA - Simple centered text (Bill jaisa - 10 ke bad show hoga)
                                    if (!_hasMore && _allSurveys.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24, horizontal: 16),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'no more data',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 18),
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

  // ✅ Helper method for header cells
  Widget _buildHeaderCell(String text, double width, {bool center = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
          fontSize: 11,
        ),
        textAlign: center ? TextAlign.center : TextAlign.left,
      ),
    );
  }

  // ✅ Cell text style
  TextStyle get _cellTextStyle => TextStyle(
        fontSize: 11,
        color: const Color(0xFF4A5568),
        fontFamily: GoogleFonts.poppins().fontFamily,
      );
}
