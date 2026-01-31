// import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'bill_form_screen.dart';

// class BillDistributorScreen extends StatefulWidget {
//   const BillDistributorScreen({super.key});

//   @override
//   State<BillDistributorScreen> createState() => _BillDistributorScreenState();
// }

// class _BillDistributorScreenState extends State<BillDistributorScreen> {
//   final _verticalScrollController = ScrollController();
//   final _horizontalScrollController = ScrollController();
//   final _searchController = TextEditingController();
//   String _searchQuery = '';
//   bool _showSearchBar = false;
//   bool _isLoading = false;
//   bool _hasMore = true;

//   // Pagination variables
//   int _currentPage = 0;
//   final int _itemsPerPage = 10;

//   // Bill data list with all fields from screenshot
//   List<Bill> _allBillData = [
//     Bill(
//       id: 'BILL001',
//       date: DateTime(2024, 1, 15),
//       customerName: 'Anita Rathore',
//       propertyDetails: 'BGR/W19/394',
//       municipality: 'MURATI',
//       integratedPid: '',
//       integratedOwner: 'Anita Rathore',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address: 'AGGARWAL COLONY, BAHADURGARH - 124507',
//       mobile: '8814000555',
//       category: 'Commercial',
//       totalArea: '95.25',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL002',
//       date: DateTime(2024, 1, 20),
//       customerName: 'Parvinder Rathore',
//       propertyDetails: 'NA',
//       municipality: 'NA',
//       integratedPid: '',
//       integratedOwner: 'Parvinder Rathore',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address:
//           '115, Ramesh Auto Works, Aggarwal Colony, Railway Station, Railway Station, 124507',
//       mobile: '4117',
//       category: 'Mixed Use',
//       totalArea: '427.87',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL003',
//       date: DateTime(2024, 1, 10),
//       customerName: 'N/A',
//       propertyDetails: 'BGR/W13/3391',
//       municipality: 'SARJEET SAHU',
//       integratedPid: '',
//       integratedOwner: 'N/A',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '368, Anya Nagar 2, Hardyal School, Hardyal School, 124507',
//       mobile: '',
//       category: 'Residential',
//       totalArea: '100.61',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL004',
//       date: DateTime(2024, 2, 5),
//       customerName: 'Dev Singh Rawat',
//       propertyDetails: 'BGR/W13/3400',
//       municipality: 'MANJU W/O SANDHY KUMAR',
//       integratedPid: '',
//       integratedOwner: 'Dev Singh Rawat',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '383, Anya Nagar 2, 124507, 124507',
//       mobile: '9729800252',
//       category: 'Residential',
//       totalArea: '52.48',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL005',
//       date: DateTime(2024, 2, 10),
//       customerName: 'Rajesh Kumar',
//       propertyDetails: 'BGR/W14/3450',
//       municipality: 'MURATI',
//       integratedPid: '',
//       integratedOwner: 'Rajesh Kumar',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address: 'Plot 45, Aggarwal Colony, Bahadurgarh',
//       mobile: '9876543210',
//       category: 'Commercial',
//       totalArea: '85.50',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL006',
//       date: DateTime(2024, 2, 15),
//       customerName: 'Sunita Sharma',
//       propertyDetails: 'BGR/W15/3500',
//       municipality: 'SARJEET SAHU',
//       integratedPid: '',
//       integratedOwner: 'Sunita Sharma',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '289, Anya Nagar 2, Bahadurgarh',
//       mobile: '8765432109',
//       category: 'Residential',
//       totalArea: '120.75',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL007',
//       date: DateTime(2024, 2, 20),
//       customerName: 'Mohan Singh',
//       propertyDetails: 'BGR/W16/3550',
//       municipality: 'MURATI',
//       integratedPid: '',
//       integratedOwner: 'Mohan Singh',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address: 'Plot 67, Aggarwal Colony, Bahadurgarh',
//       mobile: '7654321098',
//       category: 'Mixed Use',
//       totalArea: '300.25',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL008',
//       date: DateTime(2024, 3, 1),
//       customerName: 'Preeti Verma',
//       propertyDetails: 'BGR/W17/3600',
//       municipality: 'MANJU W/O SANDHY KUMAR',
//       integratedPid: '',
//       integratedOwner: 'Preeti Verma',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '412, Anya Nagar 2, Bahadurgarh',
//       mobile: '6543210987',
//       category: 'Residential',
//       totalArea: '150.00',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL009',
//       date: DateTime(2024, 3, 5),
//       customerName: 'Ramesh Gupta',
//       propertyDetails: 'BGR/W18/3650',
//       municipality: 'MURATI',
//       integratedPid: '',
//       integratedOwner: 'Ramesh Gupta',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address: 'Plot 89, Aggarwal Colony, Bahadurgarh',
//       mobile: '5432109876',
//       category: 'Commercial',
//       totalArea: '200.50',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Bill(
//       id: 'BILL010',
//       date: DateTime(2024, 3, 10),
//       customerName: 'Sita Devi',
//       propertyDetails: 'BGR/W19/3700',
//       municipality: 'SARJEET SAHU',
//       integratedPid: '',
//       integratedOwner: 'Sita Devi',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '523, Anya Nagar 2, Bahadurgarh',
//       mobile: '4321098765',
//       category: 'Residential',
//       totalArea: '75.30',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _verticalScrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_verticalScrollController.position.pixels ==
//             _verticalScrollController.position.maxScrollExtent &&
//         _hasMore &&
//         !_isLoading) {
//       _loadMoreData();
//     }
//   }

//   Future<void> _loadMoreData() async {
//     if (_isLoading || !_hasMore) return;

//     setState(() {
//       _isLoading = true;
//     });

//     // Simulate network delay
//     await Future.delayed(const Duration(seconds: 1));

//     setState(() {
//       _currentPage++;
//       _isLoading = false;

//       // Check if there's more data to load
//       final totalItemsLoaded = (_currentPage + 1) * _itemsPerPage;
//       _hasMore = totalItemsLoaded < _filteredData.length;
//     });
//   }

//   List<Bill> get _filteredData {
//     if (_searchQuery.isEmpty) {
//       return _allBillData;
//     }
//     return _allBillData.where((bill) {
//       final id = bill.id.toLowerCase();

//       final customerName = bill.customerName.toLowerCase();
//       final propertyId = bill.propertyDetails.toLowerCase();
//       final mobile = bill.mobile.toLowerCase();
//       final category = bill.category.toLowerCase();
//       final colony = bill.colony.toLowerCase();
//       final query = _searchQuery.toLowerCase();

//       return id.contains(query) ||
//           customerName.contains(query) ||
//           propertyId.contains(query) ||
//           mobile.contains(query) ||
//           category.contains(query) ||
//           colony.contains(query);
//     }).toList();
//   }

//   List<Bill> get _paginatedData {
//     final filtered = _filteredData;
//     final endIndex =
//         ((_currentPage + 1) * _itemsPerPage).clamp(0, filtered.length);

//     return filtered.sublist(0, endIndex);
//   }

//   void _onSearchChanged(String value) {
//     setState(() {
//       _searchQuery = value;
//       _currentPage = 0;
//       _hasMore = (_itemsPerPage < _filteredData.length);
//     });
//   }

//   void _toggleSearchBar() {
//     setState(() {
//       _showSearchBar = !_showSearchBar;
//       if (!_showSearchBar) {
//         _searchController.clear();
//         _searchQuery = '';
//         _currentPage = 0;
//         _hasMore = (_itemsPerPage < _allBillData.length);
//       }
//     });
//   }

//   Future<void> _navigateToAddBill() async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const BillFormScreen(isEditMode: false),
//       ),
//     );

//     if (result != null && result is Bill) {
//       setState(() {
//         _allBillData.insert(0, result);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Bill "${result.id}" created successfully'),
//           backgroundColor: Colors.green.shade600,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _navigateToEditBill(Bill bill) async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => BillFormScreen(
//           bill: bill,
//           isEditMode: true,
//         ),
//       ),
//     );

//     if (result != null && result is Bill) {
//       setState(() {
//         final index = _allBillData.indexWhere((b) => b.id == result.id);
//         if (index != -1) {
//           _allBillData[index] = result;
//         }
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Bill "${result.id}" updated successfully'),
//           backgroundColor: Colors.blue.shade600,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   void _showDeleteDialog(BuildContext context, Bill bill) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Text(
//           'Delete Bill',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         content: Text(
//           'Are you sure you want to delete bill "${bill.id}"?',
//           style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() {
//                 _allBillData.removeWhere((b) => b.id == bill.id);
//               });

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Bill "${bill.id}" deleted successfully'),
//                   backgroundColor: Colors.red.shade600,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade600,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//             child: const Text(
//               'Delete',
//               style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _verticalScrollController.dispose();
//     _horizontalScrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final paginatedData = _paginatedData;
//     final totalItems = _filteredData.length;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFEDF2F7),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: Color(0xFF2D3748),
//               size: 18,
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Bill Distribution',
//           style: TextStyle(
//             color: Color(0xFF2D3748),
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         actions: [
//           // Search Icon
//           IconButton(
//             onPressed: _toggleSearchBar,
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEDF2F7),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 _showSearchBar ? Icons.close : Icons.search,
//                 color: const Color(0xFF2D3748),
//                 size: 18,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Animated Search Bar
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             height: _showSearchBar ? 70 : 0,
//             curve: Curves.easeInOut,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               color: Colors.white,
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: _onSearchChanged,
//                 style: const TextStyle(fontSize: 14),
//                 decoration: InputDecoration(
//                   hintText: 'Search by ID, Title or Description...',
//                   hintStyle:
//                       const TextStyle(fontSize: 13, color: Color(0xFF718096)),
//                   prefixIcon: const Icon(Icons.search,
//                       size: 20, color: Color(0xFF667eea)),
//                   suffixIcon: _searchQuery.isNotEmpty
//                       ? IconButton(
//                           onPressed: () {
//                             _searchController.clear();
//                             _onSearchChanged('');
//                           },
//                           icon: const Icon(Icons.clear, size: 18),
//                         )
//                       : null,
//                   filled: true,
//                   fillColor: const Color(0xFFF7FAFC),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Color(0xFF667eea), width: 1.5),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),

//           // Header Card

//           // Main Content Area - ENTIRE TABLE IN ONE SCROLLABLE CONTAINER
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: paginatedData.isEmpty
//                     ? const Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 120),
//                           child: Text('No bills found'),
//                         ),
//                       )
//                     : Scrollbar(
//                         thumbVisibility: true,
//                         controller: _horizontalScrollController,
//                         child: SingleChildScrollView(
//                           controller: _horizontalScrollController,
//                           scrollDirection: Axis.horizontal,
//                           child: Container(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Table Header (Fixed)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[50],
//                                     border: Border(
//                                       bottom: BorderSide(
//                                         color: Colors.grey.shade200,
//                                         width: 1,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Municipality  Name',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       // All columns
//                                       SizedBox(
//                                         width: 80,
//                                         child: Text(
//                                           'Property ID',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),

//                                       SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Owner Name',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           'Property ID',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           'Mobile No.',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 150,
//                                         child: Text(
//                                           'Address',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           'Category',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           'Total Area',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           'Unit',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       SizedBox(
//                                         width: 100,
//                                         child: Text(
//                                           'Status',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),

//                                       SizedBox(
//                                         width: 80,
//                                         child: Text(
//                                           'Actions',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 12,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // Table Rows
//                                 ...paginatedData.map((bill) {
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(
//                                           color: Colors.grey.shade200,
//                                           width: 1,
//                                         ),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         SizedBox(
//                                           width: 120,
//                                           child: Text(
//                                             bill.municipality,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         // All columns
//                                         SizedBox(
//                                           width: 80,
//                                           child: Text(
//                                             bill.id,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                         ),

//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 120,
//                                           child: Text(
//                                             bill.customerName,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 100,
//                                           child: Text(
//                                             bill.propertyDetails,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 100,
//                                           child: Text(
//                                             bill.mobile,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 150,
//                                           child: Text(
//                                             bill.address.length > 20
//                                                 ? '${bill.address.substring(0, 20)}...'
//                                                 : bill.address,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 100,
//                                           child: Text(
//                                             bill.category,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                               color: const Color(0xFF2D3748),
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 100,
//                                           child: Text(
//                                             bill.totalArea,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                               color: const Color(0xFF2D3748),
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 100,
//                                           child: Text(
//                                             bill.unit,
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 11,
//                                               color: const Color(0xFF2D3748),
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 100,
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 8,
//                                               vertical: 4,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: bill.authorizationStatus ==
//                                                       'Approved'
//                                                   ? Colors.green.shade50
//                                                   : Colors.red.shade50,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                             ),
//                                             child: Text(
//                                               bill.authorizationStatus,
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.w600,
//                                                 color:
//                                                     bill.authorizationStatus ==
//                                                             'Approved'
//                                                         ? Colors.green.shade800
//                                                         : Colors.red.shade800,
//                                               ),
//                                               textAlign: TextAlign.center,
//                                               maxLines: 1,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 20),
//                                         SizedBox(
//                                           width: 80,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               // Edit Button
//                                               Container(
//                                                 width: 28,
//                                                 height: 28,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.blue.shade50,
//                                                   borderRadius:
//                                                       BorderRadius.circular(6),
//                                                 ),
//                                                 child: IconButton(
//                                                   onPressed: () =>
//                                                       _navigateToEditBill(bill),
//                                                   icon: Icon(
//                                                     Icons.menu,
//                                                     size: 14,
//                                                     color: Colors.blue.shade700,
//                                                   ),
//                                                   padding: EdgeInsets.zero,
//                                                   tooltip: 'Edit',
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 8),
//                                               // Delete Button
//                                               Container(
//                                                 width: 28,
//                                                 height: 28,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.red.shade50,
//                                                   borderRadius:
//                                                       BorderRadius.circular(6),
//                                                 ),
//                                                 child: IconButton(
//                                                   onPressed: () {
//                                                     _showDeleteDialog(
//                                                         context, bill);
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.delete_rounded,
//                                                     size: 14,
//                                                     color: Colors.red.shade700,
//                                                   ),
//                                                   padding: EdgeInsets.zero,
//                                                   tooltip: 'Delete',
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),

//                                 // Loading indicator
//                                 if (_isLoading)
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 20),
//                                     child: const Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                   ),

//                                 // No more data indicator
//                                 if (!_hasMore && paginatedData.isNotEmpty)
//                                   Container(
//                                     padding: const EdgeInsets.all(16),
//                                     child: Center(
//                                       child: Text(
//                                         'No more bills to load',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//       // FAB Button
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF667eea),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF667eea).withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: _navigateToAddBill,
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.add_rounded,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     'Add New Bill',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }

import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/bill_distribution/screens/new_bill_distribution/bill_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:data_care_app/features/bill_distribution/screens/model/bill_model.dart';

import 'package:google_fonts/google_fonts.dart';

class BillDistributorScreen extends StatefulWidget {
  final String? projectId;
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
      return bill.displayId.toLowerCase().contains(query) ||
          bill.customerName.toLowerCase().contains(query) ||
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
        builder: (context) => const BillFormScreen(isEditMode: false),
      ),
    );

    if (result != null && result is Bill) {
      setState(() {
        // Add new bill to the list
        _allBills.insert(0, result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill "${result.id}" created successfully'),
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
        final index = _allBills.indexWhere((b) => b.id == result.id);
        if (index != -1) {
          _allBills[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill "${result.id}" updated successfully'),
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
                  const Icon(
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
