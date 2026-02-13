import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/bill_distribution/screens/new_bill_distribution/bill_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:google_fonts/google_fonts.dart';

class BillDistributorScreen extends StatefulWidget {
  final int? projectId;
  const BillDistributorScreen({super.key, this.projectId});

  @override
  State<BillDistributorScreen> createState() => _BillDistributorScreenState();
}

class _BillDistributorScreenState extends State<BillDistributorScreen> {
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _searchController = TextEditingController();
  late final CustomerRepository _repository;

  // ✅ Server-side pagination variables - 10 items per page
  List<Bill> _allBills = [];
  bool _isLoading = false;
  bool _isInitialLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10; // ✅ 10 items per page
  int _totalRecords = 0;

  String _searchQuery = '';
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    print('🔄 Initializing Bill Distribution Screen...');
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _fetchBills(page: _currentPage, isInitial: true);
    _verticalScrollController.addListener(_onScroll);
  }

  // ✅ Server-side pagination with List response - 10 records per page
  Future<void> _fetchBills(
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
          '📡 Fetching bills from API - Page: $page, Search: $search, Limit: $_itemsPerPage');

      final response = await _repository.fetchCustomers(
        projectId: widget.projectId,
        sourceType: 'bill_distribution',
        search: search,
        page: page,
        limit: _itemsPerPage,
      );

      print('✅ API Response received: ${response.length} items');

      final newBills = response.map((item) => Bill.fromJson(item)).toList();

      setState(() {
        if (page == 1) {
          _allBills = newBills;
        } else {
          _allBills.addAll(newBills);
        }

        // ✅ Agar 10 records aaye toh aur honge, nahi toh khatam
        _hasMore = newBills.length >= _itemsPerPage;
        _totalRecords =
            page == 1 ? newBills.length : _totalRecords + newBills.length;
        _currentPage = page;
        _isLoading = false;
        _isInitialLoading = false;
      });

      print('✅ Loaded ${newBills.length} bills');
      print(
          '📊 Total loaded: $_totalRecords, Has more: $_hasMore, Next page: ${page + 1}');
    } catch (e) {
      print('❌ Error fetching bills: $e');
      setState(() {
        _isLoading = false;
        _isInitialLoading = false;
        _hasMore = false;
      });
    }
  }

  void _onScroll() {
    if (_verticalScrollController.position.pixels >=
            _verticalScrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _refresh() async {
    print('🔄 Refreshing bill list...');
    setState(() {
      _currentPage = 1;
      _allBills = [];
      _hasMore = true;
    });
    await _fetchBills(
        page: 1,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        isInitial: true);
    print('✅ Bill list refreshed');
  }

  Future<void> _loadMoreData() async {
    if (!_hasMore || _isLoading) return;

    final nextPage = _currentPage + 1;
    print('📦 Loading more data - Page $nextPage (${_itemsPerPage} items)');
    await _fetchBills(
        page: nextPage, search: _searchQuery.isEmpty ? null : _searchQuery);
  }

  void _onSearchChanged(String value) {
    print('🔍 Searching: $value');
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
      _allBills = [];
      _hasMore = true;
    });
    _fetchBills(page: 1, search: value.isEmpty ? null : value, isInitial: true);
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        _searchQuery = '';
        _currentPage = 1;
        _allBills = [];
        _hasMore = true;
        _fetchBills(page: 1, isInitial: true);
      }
    });
  }

  // ✅ Method to get background color based on verify_by
  Color _getRowBackgroundColor(Bill bill) {
    if (bill.verifyBy == "yes") {
      return Colors.green.shade50;
    }
    return Colors.white;
  }

  Future<void> _navigateToEditBill(Bill bill) async {
    print('✏️ Navigating to edit bill form for ID: ${bill.id}');

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillFormScreen(
          bill: bill,
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
      print('✅ Bill updated, refreshing list...');
      await _refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bill updated successfully'),
          backgroundColor: Colors.blue.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Bill',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete bill "${bill.name}"?',
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
                print('🗑️ Deleting bill ID: ${bill.id}');

                setState(() {
                  _allBills.removeWhere((b) => b.id == bill.id);
                  _totalRecords--;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bill "${bill.name}" deleted successfully'),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete bill: $e'),
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
          'Bill Distribution',
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
          // ✅ Search Bar
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
                  hintText: 'Search by Bill ID, Name, Mobile...',
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

          // ✅ Main Content - Server Side Pagination with 10 items per page
          Expanded(
            child: _isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : _allBills.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 120),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long,
                                  color: Colors.grey[400], size: 60),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No bills found'
                                    : 'No matching bills found',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF718096),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Bill records will appear here'
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
                                    // ✅ Table Header (S.No removed)
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

                                    // ✅ Table Rows (S.No removed)
                                    ..._allBills.map((bill) {
                                      return GestureDetector(
                                        onTap: () => _navigateToEditBill(bill),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _getRowBackgroundColor(bill),
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
                                                  bill.municipalityName ?? '-',
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
                                                  bill.propertyDetailsPropertyId ??
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
                                                  bill.name ?? '-',
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
                                                  bill.integratedPidPropertyId ??
                                                      '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),

                                              // Integrated Owner/Occupier
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  bill.integratedPidOwnerOccupierName ??
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
                                                  bill.areaOfAuthority ?? '-',
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
                                                  bill.colonyName ?? '-',
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
                                                  (bill.addressOfProperty
                                                                  ?.length ??
                                                              0) >
                                                          25
                                                      ? '${bill.addressOfProperty?.substring(0, 25)}...'
                                                      : bill.addressOfProperty ??
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
                                                  bill.mobileNo ?? '-',
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
                                                  bill.category ?? '-',
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
                                                  bill.totalArea ?? '-',
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
                                                  bill.unit ?? '-',
                                                  style: _cellTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // Authorization Status
                                              SizedBox(
                                                width: 100,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        bill.authorizationStatus ==
                                                                'Approved'
                                                            ? Colors
                                                                .green.shade50
                                                            : Colors
                                                                .red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    bill.authorizationStatus ??
                                                        '-',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          bill.authorizationStatus ==
                                                                  'Approved'
                                                              ? Colors.green
                                                                  .shade800
                                                              : Colors
                                                                  .red.shade800,
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
                                                            _navigateToEditBill(
                                                                bill),
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
                                                              context, bill);
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

                                    // ✅ Loading indicator for more data
                                    if (_isLoading &&
                                        !_isInitialLoading &&
                                        _allBills.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),

                                    // ✅ NO MORE DATA - Simple centered text (10 ke bad show hoga)
                                    if (!_hasMore && _allBills.isNotEmpty)
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
