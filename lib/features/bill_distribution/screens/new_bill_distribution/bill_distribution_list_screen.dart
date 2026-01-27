import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bill_form_screen.dart';

class BillDistributorScreen extends StatefulWidget {
  const BillDistributorScreen({super.key});

  @override
  State<BillDistributorScreen> createState() => _BillDistributorScreenState();
}

class _BillDistributorScreenState extends State<BillDistributorScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSearchBar = false;
  bool _isLoading = false;
  bool _hasMore = true;

  // Pagination variables
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  // Bill data list (status removed from data)
  List<Bill> _allBillData = [
    Bill(
      id: 'BILL001',
      title: 'Electricity Bill - January',
      description: 'Monthly electricity bill for main building',
      amount: 12500.00,
      date: DateTime(2024, 1, 15),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL002',
      title: 'Water Supply Bill',
      description: 'Quarterly water supply charges',
      amount: 8500.00,
      date: DateTime(2024, 1, 20),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL003',
      title: 'Maintenance Charges',
      description: 'Monthly maintenance for common areas',
      amount: 25000.00,
      date: DateTime(2024, 1, 10),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL004',
      title: 'Security Services',
      description: 'Monthly security service charges',
      amount: 18000.00,
      date: DateTime(2024, 2, 5),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL005',
      title: 'Internet Bill',
      description: 'Office internet connection charges',
      amount: 6500.00,
      date: DateTime(2024, 2, 10),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL006',
      title: 'Cleaning Services',
      description: 'Monthly cleaning service charges',
      amount: 12000.00,
      date: DateTime(2024, 2, 15),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL007',
      title: 'Property Tax',
      description: 'Annual property tax payment',
      amount: 45000.00,
      date: DateTime(2024, 2, 20),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL008',
      title: 'Elevator Maintenance',
      description: 'Quarterly elevator maintenance',
      amount: 32000.00,
      date: DateTime(2024, 3, 1),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL009',
      title: 'Generator Fuel',
      description: 'Monthly generator fuel charges',
      amount: 18500.00,
      date: DateTime(2024, 3, 5),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL010',
      title: 'Garden Maintenance',
      description: 'Monthly garden maintenance charges',
      amount: 9500.00,
      date: DateTime(2024, 3, 10),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL011',
      title: 'Swimming Pool Maintenance',
      description: 'Monthly pool maintenance charges',
      amount: 15000.00,
      date: DateTime(2024, 3, 15),
      customerName: '',
      propertyDetails: '',
    ),
    Bill(
      id: 'BILL012',
      title: 'Parking Charges',
      description: 'Monthly parking maintenance',
      amount: 22000.00,
      date: DateTime(2024, 3, 20),
      customerName: '',
      propertyDetails: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _currentPage++;
      _isLoading = false;

      // Check if there's more data to load
      final totalItemsLoaded = (_currentPage + 1) * _itemsPerPage;
      _hasMore = totalItemsLoaded < _filteredData.length;
    });
  }

  List<Bill> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _allBillData;
    }
    return _allBillData.where((bill) {
      final title = bill.title.toLowerCase();
      final id = bill.id.toLowerCase();
      final description = bill.description.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) ||
          id.contains(query) ||
          description.contains(query);
    }).toList();
  }

  List<Bill> get _paginatedData {
    final filtered = _filteredData;
    final endIndex =
        ((_currentPage + 1) * _itemsPerPage).clamp(0, filtered.length);

    return filtered.sublist(0, endIndex);
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
        _hasMore = (_itemsPerPage < _allBillData.length);
      }
    });
  }

  Future<void> _navigateToAddBill() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BillFormScreen(isEditMode: false),
      ),
    );

    if (result != null && result is Bill) {
      setState(() {
        _allBillData.insert(0, result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill "${result.title}" created successfully'),
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
        ),
      ),
    );

    if (result != null && result is Bill) {
      setState(() {
        final index = _allBillData.indexWhere((b) => b.id == result.id);
        if (index != -1) {
          _allBillData[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill "${result.title}" updated successfully'),
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
          'Are you sure you want to delete bill "${bill.title}"?',
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
                _allBillData.removeWhere((b) => b.id == bill.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bill "${bill.title}" deleted successfully'),
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
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final paginatedData = _paginatedData;
    final totalItems = _filteredData.length;

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
          // Search Icon
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
          // Animated Search Bar
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
                  hintText: 'Search by ID, Title or Description...',
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

          // Header Card
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(12),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: const Color(0xFF667eea),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bill Records',
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w700)),
                      Text(
                        'Showing ${paginatedData.length} of $totalItems bills',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (totalItems > 10)
                  Text(
                    'Scroll down to load more',
                    style: TextStyle(
                      color: const Color(0xFF667eea),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                child: paginatedData.isEmpty
                    ? ListView(
                        controller: _scrollController,
                        children: const [
                          SizedBox(height: 120),
                          Center(child: Text('No bills found')),
                        ],
                      )
                    : Column(
                        children: [
                          // Table Header (Fixed) - STATUS COLUMN REMOVED
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
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Actions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Scrollable Table Body
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              itemCount:
                                  paginatedData.length + (_isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                // Loading indicator at the bottom
                                if (index >= paginatedData.length) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Center(
                                      child: _hasMore
                                          ? const CircularProgressIndicator()
                                          : Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                'No more bills to load',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                                }

                                final bill = paginatedData[index];
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
                                      Expanded(
                                        child: Text(
                                          bill.id,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bill.title,
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 11,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              bill.description.length > 30
                                                  ? '${bill.description.substring(0, 30)}...'
                                                  : bill.description,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 9,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '₹${bill.amount.toStringAsFixed(2)}',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize: 11,
                                            color: const Color(0xFF2D3748),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Edit Button
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                onPressed: () =>
                                                    _navigateToEditBill(bill),
                                                icon: Icon(
                                                  Icons.edit_rounded,
                                                  size: 14,
                                                  color: Colors.blue.shade700,
                                                ),
                                                padding: EdgeInsets.zero,
                                                tooltip: 'Edit',
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Delete Button
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _showDeleteDialog(
                                                      context, bill);
                                                },
                                                icon: Icon(
                                                  Icons.delete_rounded,
                                                  size: 14,
                                                  color: Colors.red.shade700,
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
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      // FAB Button
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
            onTap: _navigateToAddBill,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add New Bill',
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
