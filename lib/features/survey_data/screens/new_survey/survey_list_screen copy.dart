// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../../../app/routes/route_names.dart';
// // import '../../../core/constants/app_strings.dart';

// // class SurveyListScreen extends StatefulWidget {
// //   const SurveyListScreen({super.key});

// //   @override
// //   State<SurveyListScreen> createState() => _SurveyListScreenState();
// // }

// // class _SurveyListScreenState extends State<SurveyListScreen> {
// //   final _scrollController = ScrollController();

// //   // Static survey data list
// //   final List<Map<String, dynamic>> _surveyData = [
// //     {
// //       'id': 'SRV001',
// //       'name': 'Green Valley Apartments Survey',
// //       'status': 'Active',
// //     },
// //     {
// //       'id': 'SRV002',
// //       'name': 'Skyline Towers Customer Feedback',
// //       'status': 'Active',
// //     },
// //     {
// //       'id': 'SRV003',
// //       'name': 'Sunrise Complex Satisfaction Survey',
// //       'status': 'Inactive',
// //     },
// //     {
// //       'id': 'SRV004',
// //       'name': 'Royal Residency Market Research',
// //       'status': 'Active',
// //     },
// //     {
// //       'id': 'SRV005',
// //       'name': 'Ocean View Property Analysis',
// //       'status': 'Active',
// //     },
// //     {
// //       'id': 'SRV006',
// //       'name': 'Downtown Plaza Survey',
// //       'status': 'Inactive',
// //     },
// //     {
// //       'id': 'SRV007',
// //       'name': 'Hill Station Residential Survey',
// //       'status': 'Active',
// //     },
// //     {
// //       'id': 'SRV008',
// //       'name': 'Metro Heights Customer Survey',
// //       'status': 'Active',
// //     },
// //   ];

// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final textTheme = Theme.of(context).textTheme;

// //     return Scaffold(
// //       backgroundColor: Colors.grey[100],
// //       body: Stack(
// //         children: [
// //           Column(
// //             children: [
// //               // Header Card - New UI Structure
// //               Container(
// //                 margin: const EdgeInsets.all(8),
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(12),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.05),
// //                       blurRadius: 8,
// //                       offset: const Offset(0, 2),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.all(8),
// //                       decoration: BoxDecoration(
// //                         color: Colors.blue.shade50,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Icon(
// //                         Icons.analytics_rounded,
// //                         color: Colors.blue.shade700,
// //                         size: 20,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('Survey Data',
// //                               style: TextStyle(
// //                                   fontFamily: GoogleFonts.poppins().fontFamily,
// //                                   fontWeight: FontWeight.w700)),
// //                           Text(
// //                             'View and update survey records',
// //                             style: TextStyle(
// //                               color: Theme.of(context).colorScheme.outline,
// //                               fontFamily: GoogleFonts.poppins().fontFamily,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Main Content Area - New UI Structure
// //               Expanded(
// //                 child: Container(
// //                   margin:
// //                       const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(12),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.05),
// //                         blurRadius: 8,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ],
// //                   ),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12),
// //                     child: _surveyData.isEmpty
// //                         ? ListView(
// //                             controller: _scrollController,
// //                             children: const [
// //                               SizedBox(height: 120),
// //                               Center(child: Text('No records found')),
// //                             ],
// //                           )
// //                         : ListView(
// //                             controller: _scrollController,
// //                             padding: EdgeInsets.zero,
// //                             children: [
// //                               // Custom Table with updated UI
// //                               Container(
// //                                 margin: const EdgeInsets.all(8),
// //                                 decoration: BoxDecoration(
// //                                   border: Border.all(
// //                                     color: Colors.grey.shade200,
// //                                     width: 1,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 child: Column(
// //                                   children: [
// //                                     // Table Header
// //                                     Container(
// //                                       padding: const EdgeInsets.symmetric(
// //                                         horizontal: 16,
// //                                         vertical: 12,
// //                                       ),
// //                                       decoration: BoxDecoration(
// //                                         color: Colors.grey[50],
// //                                         borderRadius: const BorderRadius.only(
// //                                           topLeft: Radius.circular(8),
// //                                           topRight: Radius.circular(8),
// //                                         ),
// //                                       ),
// //                                       child: Row(
// //                                         children: [
// //                                           Expanded(
// //                                             child: Text(
// //                                               'ID',
// //                                               style: textTheme.bodyMedium
// //                                                   ?.copyWith(
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.grey[700],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           Expanded(
// //                                             flex: 3,
// //                                             child: Text(
// //                                               'Name',
// //                                               style: textTheme.bodyMedium
// //                                                   ?.copyWith(
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.grey[700],
// //                                                 fontFamily:
// //                                                     GoogleFonts.poppins()
// //                                                         .fontFamily,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           Expanded(
// //                                             flex: 2,
// //                                             child: Text(
// //                                               'Status',
// //                                               style: textTheme.bodyMedium
// //                                                   ?.copyWith(
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.grey[700],
// //                                                 fontFamily:
// //                                                     GoogleFonts.poppins()
// //                                                         .fontFamily,
// //                                               ),
// //                                               textAlign: TextAlign.center,
// //                                             ),
// //                                           ),
// //                                           SizedBox(
// //                                             width: 80,
// //                                             child: Text(
// //                                               'Actions',
// //                                               style: textTheme.bodyMedium
// //                                                   ?.copyWith(
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.grey[700],
// //                                                 fontFamily:
// //                                                     GoogleFonts.poppins()
// //                                                         .fontFamily,
// //                                               ),
// //                                               textAlign: TextAlign.end,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     // Table Rows
// //                                     ..._surveyData.map((row) {
// //                                       return Container(
// //                                         padding: const EdgeInsets.symmetric(
// //                                           horizontal: 16,
// //                                           vertical: 12,
// //                                         ),
// //                                         decoration: BoxDecoration(
// //                                           border: Border(
// //                                             bottom: BorderSide(
// //                                               color: Colors.grey.shade200,
// //                                               width: 1,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         child: Row(
// //                                           children: [
// //                                             Expanded(
// //                                               child: Text(
// //                                                 row['id'] ?? '-',
// //                                                 style: textTheme.bodySmall
// //                                                     ?.copyWith(
// //                                                   fontFamily:
// //                                                       GoogleFonts.poppins()
// //                                                           .fontFamily,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                             Expanded(
// //                                               flex: 3,
// //                                               child: Text(
// //                                                 row['name'] ?? '-',
// //                                                 style: textTheme.bodySmall
// //                                                     ?.copyWith(
// //                                                   fontWeight: FontWeight.w500,
// //                                                   fontFamily:
// //                                                       GoogleFonts.poppins()
// //                                                           .fontFamily,
// //                                                   fontSize: 11,
// //                                                 ),
// //                                                 textAlign: TextAlign.start,
// //                                               ),
// //                                             ),
// //                                             Expanded(
// //                                               flex: 2,
// //                                               child: Container(
// //                                                 padding:
// //                                                     const EdgeInsets.symmetric(
// //                                                   horizontal: 8,
// //                                                   vertical: 4,
// //                                                 ),
// //                                                 decoration: BoxDecoration(
// //                                                   color: row['status'] ==
// //                                                           'Active'
// //                                                       ? Colors.green.shade50
// //                                                       : Colors.orange.shade50,
// //                                                   borderRadius:
// //                                                       BorderRadius.circular(4),
// //                                                   border: Border.all(
// //                                                     color: row['status'] ==
// //                                                             'Active'
// //                                                         ? Colors.green.shade200
// //                                                         : Colors
// //                                                             .orange.shade200,
// //                                                   ),
// //                                                 ),
// //                                                 child: Text(
// //                                                   row['status'] ?? '-',
// //                                                   style: textTheme.bodySmall
// //                                                       ?.copyWith(
// //                                                     fontWeight: FontWeight.w600,
// //                                                     color: row['status'] ==
// //                                                             'Active'
// //                                                         ? Colors.green.shade700
// //                                                         : Colors
// //                                                             .orange.shade700,
// //                                                     fontFamily:
// //                                                         GoogleFonts.poppins()
// //                                                             .fontFamily,
// //                                                     fontSize: 10,
// //                                                   ),
// //                                                   textAlign: TextAlign.center,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                             SizedBox(
// //                                               width: 80,
// //                                               child: Row(
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.end,
// //                                                 children: [
// //                                                   // Updated Edit Button
// //                                                   Container(
// //                                                     width: 28,
// //                                                     height: 28,
// //                                                     decoration: BoxDecoration(
// //                                                       color:
// //                                                           Colors.blue.shade50,
// //                                                       borderRadius:
// //                                                           BorderRadius.circular(
// //                                                               6),
// //                                                     ),
// //                                                     child: IconButton(
// //                                                       onPressed: () =>
// //                                                           Navigator.of(context)
// //                                                               .pushNamed(
// //                                                         RouteNames.surveyEdit,
// //                                                         arguments: {
// //                                                           'id': row['id']
// //                                                         },
// //                                                       ),
// //                                                       icon: Icon(
// //                                                         Icons.edit_rounded,
// //                                                         size: 14,
// //                                                         color: Colors
// //                                                             .blue.shade700,
// //                                                       ),
// //                                                       padding: EdgeInsets.zero,
// //                                                       tooltip: 'Edit',
// //                                                     ),
// //                                                   ),
// //                                                   const SizedBox(width: 8),
// //                                                   // Updated Delete Button
// //                                                   Container(
// //                                                     width: 28,
// //                                                     height: 28,
// //                                                     decoration: BoxDecoration(
// //                                                       color: Colors.red.shade50,
// //                                                       borderRadius:
// //                                                           BorderRadius.circular(
// //                                                               6),
// //                                                     ),
// //                                                     child: IconButton(
// //                                                       onPressed: () {
// //                                                         // Delete functionality
// //                                                         _showDeleteDialog(
// //                                                             context, row['id']);
// //                                                       },
// //                                                       icon: Icon(
// //                                                         Icons.delete_rounded,
// //                                                         size: 14,
// //                                                         color:
// //                                                             Colors.red.shade700,
// //                                                       ),
// //                                                       padding: EdgeInsets.zero,
// //                                                       tooltip: 'Delete',
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       );
// //                                     }).toList(),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           // Updated FAB Button
// //           Positioned(
// //             right: 16,
// //             bottom: 16,
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.blue.shade600,
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.blue.shade800.withOpacity(0.3),
// //                     blurRadius: 8,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               child: Material(
// //                 color: Colors.transparent,
// //                 child: InkWell(
// //                   onTap: () async {
// //                     await Navigator.of(context).pushNamed(RouteNames.surveyAdd);
// //                   },
// //                   borderRadius: BorderRadius.circular(12),
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 16,
// //                       vertical: 12,
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Icon(
// //                           Icons.add_rounded,
// //                           color: Colors.white,
// //                           size: 18,
// //                         ),
// //                         const SizedBox(width: 6),
// //                         Text(
// //                           AppStrings.addNew,
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showDeleteDialog(BuildContext context, String id) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         title: const Text(
// //           'Delete Survey',
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
// //         ),
// //         content: Text(
// //           'Are you sure you want to delete survey $id?',
// //           style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text(
// //               'Cancel',
// //               style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // Add delete logic here
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text('Survey $id deleted')),
// //               );
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.red.shade600,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //               ),
// //             ),
// //             child: const Text(
// //               'Delete',
// //               style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../app/routes/route_names.dart';
// import '../../../core/constants/app_strings.dart';

// class SurveyListScreen extends StatefulWidget {
//   const SurveyListScreen({super.key});

//   @override
//   State<SurveyListScreen> createState() => _SurveyListScreenState();
// }

// class _SurveyListScreenState extends State<SurveyListScreen> {
//   final _scrollController = ScrollController();
//   final _searchController = TextEditingController();
//   String _searchQuery = '';
//   bool _showSearchBar = false;
//   bool _isLoading = false;
//   bool _hasMore = true;

//   // Pagination variables
//   int _currentPage = 0;
//   final int _itemsPerPage = 10; // Changed to 10 items per page

//   // Static survey data list
//   final List<Map<String, dynamic>> _allSurveyData = [
//     {
//       'id': 'SRV001',
//       'name': 'Green Valley Apartments Survey',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV002',
//       'name': 'Skyline Towers Customer Feedback',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV003',
//       'name': 'Sunrise Complex Satisfaction Survey',
//       'status': 'Inactive',
//     },
//     {
//       'id': 'SRV004',
//       'name': 'Royal Residency Market Research',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV005',
//       'name': 'Ocean View Property Analysis',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV006',
//       'name': 'Downtown Plaza Survey',
//       'status': 'Inactive',
//     },
//     {
//       'id': 'SRV007',
//       'name': 'Hill Station Residential Survey',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV008',
//       'name': 'Metro Heights Customer Survey',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV009',
//       'name': 'Park Avenue Commercial Survey',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV010',
//       'name': 'Riverside Apartments Analysis',
//       'status': 'Inactive',
//     },
//     {
//       'id': 'SRV011',
//       'name': 'Tech Park Office Survey',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV012',
//       'name': 'Lakeside Villas Customer Feedback',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV013',
//       'name': 'Green Valley Apartments Survey 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV014',
//       'name': 'Skyline Towers Customer Feedback 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV015',
//       'name': 'Sunrise Complex Satisfaction Survey 2',
//       'status': 'Inactive',
//     },
//     {
//       'id': 'SRV016',
//       'name': 'Royal Residency Market Research 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV017',
//       'name': 'Ocean View Property Analysis 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV018',
//       'name': 'Downtown Plaza Survey 2',
//       'status': 'Inactive',
//     },
//     {
//       'id': 'SRV019',
//       'name': 'Hill Station Residential Survey 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV020',
//       'name': 'Metro Heights Customer Survey 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV021',
//       'name': 'Park Avenue Commercial Survey 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV022',
//       'name': 'Riverside Apartments Analysis 2',
//       'status': 'Inactive',
//     },
//     {
//       'id': 'SRV023',
//       'name': 'Tech Park Office Survey 2',
//       'status': 'Active',
//     },
//     {
//       'id': 'SRV024',
//       'name': 'Lakeside Villas Customer Feedback 2',
//       'status': 'Active',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels ==
//             _scrollController.position.maxScrollExtent &&
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

//   List<Map<String, dynamic>> get _filteredData {
//     if (_searchQuery.isEmpty) {
//       return _allSurveyData;
//     }
//     return _allSurveyData.where((item) {
//       final name = item['name'].toString().toLowerCase();
//       final id = item['id'].toString().toLowerCase();
//       final query = _searchQuery.toLowerCase();
//       return name.contains(query) || id.contains(query);
//     }).toList();
//   }

//   List<Map<String, dynamic>> get _paginatedData {
//     final filtered = _filteredData;
//     final startIndex = 0; // Always start from 0 for ListView.builder
//     final endIndex =
//         ((_currentPage + 1) * _itemsPerPage).clamp(0, filtered.length);

//     if (startIndex >= filtered.length) {
//       return [];
//     }

//     return filtered.sublist(startIndex, endIndex);
//   }

//   void _onSearchChanged(String value) {
//     setState(() {
//       _searchQuery = value;
//       _currentPage = 0; // Reset to first page on search
//       _hasMore = (_itemsPerPage < _filteredData.length); // Reset hasMore
//     });
//   }

//   void _toggleSearchBar() {
//     setState(() {
//       _showSearchBar = !_showSearchBar;
//       if (!_showSearchBar) {
//         _searchController.clear();
//         _searchQuery = '';
//         _currentPage = 0;
//         _hasMore = (_itemsPerPage < _allSurveyData.length);
//       }
//     });
//   }

//   void _resetPagination() {
//     setState(() {
//       _currentPage = 0;
//       _hasMore = (_itemsPerPage < _filteredData.length);
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
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
//           'Survey Data',
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
//                   hintText: 'Search by ID or Name...',
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

//           // Header Card
//           Container(
//             margin: const EdgeInsets.all(8),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.analytics_rounded,
//                     color: Colors.blue.shade700,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Survey Records',
//                           style: TextStyle(
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                               fontWeight: FontWeight.w700)),
//                       Text(
//                         'Showing ${paginatedData.length} of $totalItems surveys',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.outline,
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (totalItems > 10)
//                   Text(
//                     'Scroll down to load more',
//                     style: TextStyle(
//                       color: Colors.blue.shade600,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // Main Content Area
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
//                     ? ListView(
//                         controller: _scrollController,
//                         children: const [
//                           SizedBox(height: 120),
//                           Center(child: Text('No records found')),
//                         ],
//                       )
//                     : Column(
//                         children: [
//                           // Table Header (Fixed)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[50],
//                               border: Border(
//                                 bottom: BorderSide(
//                                   color: Colors.grey.shade200,
//                                   width: 1,
//                                 ),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     'ID',
//                                     style: textTheme.bodyMedium?.copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     'Name',
//                                     style: textTheme.bodyMedium?.copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                       fontFamily:
//                                           GoogleFonts.poppins().fontFamily,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     'Status',
//                                     style: textTheme.bodyMedium?.copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                       fontFamily:
//                                           GoogleFonts.poppins().fontFamily,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 80,
//                                   child: Text(
//                                     'Actions',
//                                     style: textTheme.bodyMedium?.copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                       fontFamily:
//                                           GoogleFonts.poppins().fontFamily,
//                                     ),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Scrollable Table Body
//                           Expanded(
//                             child: ListView.builder(
//                               controller: _scrollController,
//                               padding: EdgeInsets.zero,
//                               itemCount:
//                                   paginatedData.length + (_isLoading ? 1 : 0),
//                               itemBuilder: (context, index) {
//                                 // Loading indicator at the bottom
//                                 if (index >= paginatedData.length) {
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 20),
//                                     child: Center(
//                                       child: _hasMore
//                                           ? const CircularProgressIndicator()
//                                           : Container(
//                                               padding: const EdgeInsets.all(16),
//                                               child: Text(
//                                                 'No more surveys to load',
//                                                 style: TextStyle(
//                                                   color: Colors.grey[600],
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                     ),
//                                   );
//                                 }

//                                 final row = paginatedData[index];
//                                 return Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                         color: Colors.grey.shade200,
//                                         width: 1,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           row['id'] ?? '-',
//                                           style: textTheme.bodySmall?.copyWith(
//                                             fontFamily: GoogleFonts.poppins()
//                                                 .fontFamily,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 3,
//                                         child: Text(
//                                           row['name'] ?? '-',
//                                           style: textTheme.bodySmall?.copyWith(
//                                             fontWeight: FontWeight.w500,
//                                             fontFamily: GoogleFonts.poppins()
//                                                 .fontFamily,
//                                             fontSize: 11,
//                                           ),
//                                           textAlign: TextAlign.start,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 4,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: row['status'] == 'Active'
//                                                 ? Colors.green.shade50
//                                                 : Colors.orange.shade50,
//                                             borderRadius:
//                                                 BorderRadius.circular(4),
//                                             border: Border.all(
//                                               color: row['status'] == 'Active'
//                                                   ? Colors.green.shade200
//                                                   : Colors.orange.shade200,
//                                             ),
//                                           ),
//                                           child: Text(
//                                             row['status'] ?? '-',
//                                             style:
//                                                 textTheme.bodySmall?.copyWith(
//                                               fontWeight: FontWeight.w600,
//                                               color: row['status'] == 'Active'
//                                                   ? Colors.green.shade700
//                                                   : Colors.orange.shade700,
//                                               fontFamily: GoogleFonts.poppins()
//                                                   .fontFamily,
//                                               fontSize: 10,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 80,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             // Edit Button
//                                             Container(
//                                               width: 28,
//                                               height: 28,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.blue.shade50,
//                                                 borderRadius:
//                                                     BorderRadius.circular(6),
//                                               ),
//                                               child: IconButton(
//                                                 onPressed: () =>
//                                                     Navigator.of(context)
//                                                         .pushNamed(
//                                                   RouteNames.surveyEdit,
//                                                   arguments: {'id': row['id']},
//                                                 ),
//                                                 icon: Icon(
//                                                   Icons.edit_rounded,
//                                                   size: 14,
//                                                   color: Colors.blue.shade700,
//                                                 ),
//                                                 padding: EdgeInsets.zero,
//                                                 tooltip: 'Edit',
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             // Delete Button
//                                             Container(
//                                               width: 28,
//                                               height: 28,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.red.shade50,
//                                                 borderRadius:
//                                                     BorderRadius.circular(6),
//                                               ),
//                                               child: IconButton(
//                                                 onPressed: () {
//                                                   _showDeleteDialog(
//                                                       context, row['id']);
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.delete_rounded,
//                                                   size: 14,
//                                                   color: Colors.red.shade700,
//                                                 ),
//                                                 padding: EdgeInsets.zero,
//                                                 tooltip: 'Delete',
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
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
//           color: Colors.blue.shade600,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.shade800.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () async {
//               await Navigator.of(context).pushNamed(RouteNames.surveyAdd);
//             },
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
//                     AppStrings.addNew,
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

//   void _showDeleteDialog(BuildContext context, String id) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Text(
//           'Delete Survey',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         content: Text(
//           'Are you sure you want to delete survey $id?',
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
//               // Add delete logic here
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Survey $id deleted')),
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
// }

import 'package:data_care_app/features/model/survey_model/survey_model.dart';
import 'package:data_care_app/features/survey_data/screens/new_survey/survey_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({super.key});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSearchBar = false;
  bool _isLoading = false;
  bool _hasMore = true;

  // Pagination variables
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  // Survey data list
  List<Survey> _allSurveyData = [
    Survey(
      id: 'SRV001',
      name: 'Green Valley Apartments Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV002',
      name: 'Skyline Towers Customer Feedback',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV003',
      name: 'Sunrise Complex Satisfaction Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV004',
      name: 'Royal Residency Market Research',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV005',
      name: 'Ocean View Property Analysis',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV006',
      name: 'Downtown Plaza Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV007',
      name: 'Hill Station Residential Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV008',
      name: 'Metro Heights Customer Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV009',
      name: 'Park Avenue Commercial Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV010',
      name: 'Riverside Apartments Analysis',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV011',
      name: 'Tech Park Office Survey',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
    ),
    Survey(
      id: 'SRV012',
      name: 'Lakeside Villas Customer Feedback',
      propertyId: '',
      municipality: '',
      integratedPid: '',
      integratedOwner: '',
      areaOfAuthority: '',
      colony: '',
      address: '',
      mobile: '',
      category: '',
      totalArea: '',
      unit: '',
      authorizationStatus: '',
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

  List<Survey> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _allSurveyData;
    }
    return _allSurveyData.where((survey) {
      final name = survey.name.toLowerCase();
      final id = survey.id.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  List<Survey> get _paginatedData {
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
        _hasMore = (_itemsPerPage < _allSurveyData.length);
      }
    });
  }

  Future<void> _navigateToAddSurvey() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SurveyFormScreen(isEditMode: false),
      ),
    );

    if (result != null && result is Survey) {
      setState(() {
        _allSurveyData.insert(0, result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Survey "${result.name}" created successfully'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navigateToEditSurvey(Survey survey) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          survey: survey,
          isEditMode: true,
        ),
      ),
    );

    if (result != null && result is Survey) {
      setState(() {
        final index = _allSurveyData.indexWhere((s) => s.id == result.id);
        if (index != -1) {
          _allSurveyData[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Survey "${result.name}" updated successfully'),
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allSurveyData.removeWhere((s) => s.id == survey.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Survey "${survey.name}" deleted successfully'),
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
          'Survey Data',
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
                  hintText: 'Search by ID or Name...',
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
                    Icons.analytics_rounded,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Survey Records',
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w700)),
                      Text(
                        'Showing ${paginatedData.length} of $totalItems surveys',
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
                      color: Colors.blue.shade600,
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
                          Center(child: Text('No records found')),
                        ],
                      )
                    : Column(
                        children: [
                          // Table Header (Fixed)
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
                                Expanded(
                                  child: Text(
                                    'ID',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Name',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Actions',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
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
                                                'No more surveys to load',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                                }

                                final survey = paginatedData[index];
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
                                          survey.id,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              survey.name,
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
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
                                                    _navigateToEditSurvey(
                                                        survey),
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
                                                      context, survey);
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
          color: Colors.blue.shade600,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade800.withOpacity(0.3),
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
                  Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add New',
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
