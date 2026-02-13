import 'dart:math';

import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/bill_distribution/screens/new_bill_distribution/bill_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BillDistributorScreen extends StatefulWidget {
  final int? projectId;
  const BillDistributorScreen({super.key, this.projectId});

  @override
  State<BillDistributorScreen> createState() => _BillDistributorScreenState();
}

class _BillDistributorScreenState extends State<BillDistributorScreen> {
  final _verticalScrollController = ScrollController();
  final _searchController = TextEditingController();
  late final CustomerRepository _repository;

  // ✅ Server-side pagination variables - 10 items per page
  List<Bill> _allBills = [];
  bool _isLoading = false;
  bool _isInitialLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
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

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A),
              size: 14,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bill Distribution',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _toggleSearchBar,
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _showSearchBar ? Icons.close : Icons.search,
                  color: const Color(0xFF0F172A),
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Search Bar - Smaller
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSearchBar ? 70 : 0,
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.poppins(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Search by Bill ID, Name, Mobile...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(Icons.search,
                        size: 16, color: Color(0xFF6366F1)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            icon: const Icon(Icons.clear, size: 16),
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
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
                          const BorderSide(color: Color(0xFF6366F1), width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ✅ Main Content - Beautiful List (No Total Bills)
          Expanded(
            child: _isInitialLoading
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6366F1)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Loading bills...',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _allBills.isEmpty
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 16,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.receipt_long,
                                  color: Colors.grey[600],
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No bills found'
                                    : 'No matching bills found',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Bill records will appear here'
                                    : 'Try a different search term',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        color: const Color(0xFF6366F1),
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          controller: _verticalScrollController,
                          padding: const EdgeInsets.all(10),
                          itemCount: _allBills.length +
                              (_isLoading ? 1 : 0) +
                              (!_hasMore && _allBills.isNotEmpty ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Loading indicator at the end
                            if (index == _allBills.length && _isLoading) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFF6366F1)),
                                        strokeWidth: 1.5,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Loading more...',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF64748B),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // No more data indicator
                            if (index == _allBills.length &&
                                !_hasMore &&
                                _allBills.isNotEmpty &&
                                !_isLoading) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '✓ All bills loaded',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF64748B),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Normal bill item
                            final bill = _allBills[index];
                            return _buildBillListItem(bill);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  // ✅ Compact Beautiful List Item Design - No Delete Button
  Widget _buildBillListItem(Bill bill) {
    final isVerified = bill.verifyBy == "yes";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _getRowBackgroundColor(bill),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: isVerified ? Colors.green.shade100 : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToEditBill(bill),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // ✅ Row 1: Municipality and Status - Smaller
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.location_city,
                        size: 12,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MUNICIPALITY',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            bill.municipalityName ?? '-',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: bill.authorizationStatus == 'Approved'
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: bill.authorizationStatus == 'Approved'
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          width: 0.3,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bill.authorizationStatus == 'Approved'
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bill.authorizationStatus ?? '-',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: bill.authorizationStatus == 'Approved'
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        String lat = bill.latitude.toString();
                        String lng = bill.longitude.toString();

                        print(
                            'Opening map with lat: $lat, lng: $lng'); // Debug log
                        _openMap(lat, lng);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.directions,
                              size: 20,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ✅ Row 2: Property ID and Owner Name - Smaller
                Row(
                  children: [
                    // Property ID
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.confirmation_number,
                              size: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PROPERTY ID',
                                  style: GoogleFonts.poppins(
                                    fontSize: 8,
                                    color: const Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  bill.propertyDetailsPropertyId ?? '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Owner Name
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OWNER',
                                  style: GoogleFonts.poppins(
                                    fontSize: 8,
                                    color: const Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  bill.name ?? '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ✅ Row 3: Only Edit Button (Delete Removed)
                Row(
                  children: [
                    // Edit Button - Full Width
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _navigateToEditBill(bill),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.shade100,
                                width: 0.3,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  size: 13,
                                  color: Colors.blue.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Edit Bill',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Future<void> _openMap(String destLat, String destLng) async {
    Position position = await _getCurrentLocation();

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=$destLat,$destLng&travelmode=driving';

    await launchUrl(Uri.parse(url));
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
