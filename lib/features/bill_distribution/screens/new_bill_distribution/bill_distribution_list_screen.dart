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
  late Future<List<Bill>> _futureBills;
  String _searchQuery = '';
  bool _showSearchBar = false;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _refreshingBottom = false;

  // Pagination variables
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  // Store fetched bills
  List<Bill> _allBills = [];

  @override
  void initState() {
    super.initState();
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _futureBills = _fetchBills();
    _verticalScrollController.addListener(_onScroll);
  }

  Future<List<Bill>> _fetchBills() async {
    try {
      final data = await _repository.fetchCustomers(
          projectId: widget.projectId, sourceType: 'bill_distribution');
      setState(() {
        _allBills = data.map((item) => Bill.fromJson(item)).toList();
      });
      return _allBills;
    } catch (e) {
      throw Exception('Failed to load bills: $e');
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
      _futureBills = _fetchBills();
    });
    await _futureBills;
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

  List<Bill> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _allBills;
    }

    return _allBills.where((bill) {
      final query = _searchQuery.toLowerCase();
      return bill.customerName.toLowerCase().contains(query) ||
          bill.propertyDetails.toLowerCase().contains(query) ||
          bill.mobile.toLowerCase().contains(query) ||
          // bill.category.toLowerCase().contains(query) ||
          bill.colony.toLowerCase().contains(query) ||
          bill.municipality.toLowerCase().contains(query) ||
          bill.address.toLowerCase().contains(query);
    }).toList();
  }

  List<Bill> get _paginatedData {
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

  Future<void> _navigateToAddBill() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillFormScreen(
          isEditMode: false,
          projectId: widget.projectId, // Pass projectId from widget
        ),
      ),
    );

    if (result != null && result is Bill) {
      setState(() {
        // Add new bill to the beginning of the list
        _allBills.insert(0, result);
        _futureBills = Future.value(_allBills); // Update future
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill "${result.name}" created successfully'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navigateToEditBill(Bill bill) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillFormScreen(
          bill: bill,
          isEditMode: true,
          projectId: widget.projectId, // Pass projectId
        ),
      ),
    );

    if (result != null && result is Bill) {
      setState(() {
        final index = _allBills.indexWhere((b) => b.id == result.id);
        if (index != -1) {
          _allBills[index] = result;
          _futureBills = Future.value(_allBills); // Update future
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill "${result.name}" updated successfully'),
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
          'Are you sure you want to delete bill "${bill.id}"?',
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allBills.removeWhere((b) => b.id == bill.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bill "${bill.id}" deleted successfully'),
                  backgroundColor: Colors.red.shade600,
                  duration: const Duration(seconds: 2),
                ),
              );
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
                  hintText: 'Search by ID, Name, Mobile, Category...',
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
          SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Bill>>(
              future: _futureBills,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (_allBills.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 120),
                      child: Text('No bills found'),
                    ),
                  );
                }

                final paginatedBills = _paginatedData;

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
                    child: paginatedBills.isEmpty && _searchQuery.isNotEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 120),
                              child:
                                  Text('No bills found matching your search'),
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
                                            width: 120,
                                            child: Text(
                                              'Municipality Name',
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
                                              'Property ID',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3748),
                                                fontSize: 12,
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
                                            width: 100,
                                            child: Text(
                                              'Property Details',
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
                                            width: 150,
                                            child: Text(
                                              'Address',
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
                                    ...paginatedBills.map((bill) {
                                      return Container(
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
                                              width: 120,
                                              child: Text(
                                                bill.municipality,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                bill.propertyDetailsPropertyId ??
                                                    '-',
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 120,
                                              child: Text(
                                                bill.customerName,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                bill.propertyDetails,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                bill.mobile,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                bill.address.length > 20
                                                    ? '${bill.address.substring(0, 20)}...'
                                                    : bill.address,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                bill.category ?? '-',
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                bill.totalArea ?? '-',
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                bill.unit ?? '-',
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              width: 100,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      bill.authorizationStatus ==
                                                              'Approved'
                                                          ? Colors.green.shade50
                                                          : Colors.red.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  bill.authorizationStatus ??
                                                      '-',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        bill.authorizationStatus ==
                                                                'Approved'
                                                            ? Colors
                                                                .green.shade800
                                                            : Colors
                                                                .red.shade800,
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
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
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
                                                      padding: EdgeInsets.zero,
                                                      tooltip: 'Edit',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _showDeleteDialog(
                                                            context, bill);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete_rounded,
                                                        size: 14,
                                                        color:
                                                            Colors.red.shade700,
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      tooltip: 'Delete',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
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
                                    if (!_hasMore && paginatedBills.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Center(
                                          child: Text(
                                            'No more bills to load',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
