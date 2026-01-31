// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import '../../../app/routes/route_names.dart';
// // // // import '../../../core/constants/app_strings.dart';

// // // // class SurveyListScreen extends StatefulWidget {
// // // //   const SurveyListScreen({super.key});

// // // //   @override
// // // //   State<SurveyListScreen> createState() => _SurveyListScreenState();
// // // // }

// // // // class _SurveyListScreenState extends State<SurveyListScreen> {
// // // //   final _scrollController = ScrollController();

// // // //   // Static survey data list
// // // //   final List<Map<String, dynamic>> _surveyData = [
// // // //     {
// // // //       'id': 'SRV001',
// // // //       'name': 'Green Valley Apartments Survey',
// // // //       'status': 'Active',
// // // //     },
// // // //     {
// // // //       'id': 'SRV002',
// // // //       'name': 'Skyline Towers Customer Feedback',
// // // //       'status': 'Active',
// // // //     },
// // // //     {
// // // //       'id': 'SRV003',
// // // //       'name': 'Sunrise Complex Satisfaction Survey',
// // // //       'status': 'Inactive',
// // // //     },
// // // //     {
// // // //       'id': 'SRV004',
// // // //       'name': 'Royal Residency Market Research',
// // // //       'status': 'Active',
// // // //     },
// // // //     {
// // // //       'id': 'SRV005',
// // // //       'name': 'Ocean View Property Analysis',
// // // //       'status': 'Active',
// // // //     },
// // // //     {
// // // //       'id': 'SRV006',
// // // //       'name': 'Downtown Plaza Survey',
// // // //       'status': 'Inactive',
// // // //     },
// // // //     {
// // // //       'id': 'SRV007',
// // // //       'name': 'Hill Station Residential Survey',
// // // //       'status': 'Active',
// // // //     },
// // // //     {
// // // //       'id': 'SRV008',
// // // //       'name': 'Metro Heights Customer Survey',
// // // //       'status': 'Active',
// // // //     },
// // // //   ];

// // // //   @override
// // // //   void dispose() {
// // // //     _scrollController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final textTheme = Theme.of(context).textTheme;

// // // //     return Scaffold(
// // // //       backgroundColor: Colors.grey[100],
// // // //       body: Stack(
// // // //         children: [
// // // //           Column(
// // // //             children: [
// // // //               // Header Card - New UI Structure
// // // //               Container(
// // // //                 margin: const EdgeInsets.all(8),
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.white,
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                   boxShadow: [
// // // //                     BoxShadow(
// // // //                       color: Colors.black.withOpacity(0.05),
// // // //                       blurRadius: 8,
// // // //                       offset: const Offset(0, 2),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 child: Row(
// // // //                   children: [
// // // //                     Container(
// // // //                       padding: const EdgeInsets.all(8),
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.blue.shade50,
// // // //                         borderRadius: BorderRadius.circular(8),
// // // //                       ),
// // // //                       child: Icon(
// // // //                         Icons.analytics_rounded,
// // // //                         color: Colors.blue.shade700,
// // // //                         size: 20,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 10),
// // // //                     Expanded(
// // // //                       child: Column(
// // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // //                         children: [
// // // //                           Text('Survey Data',
// // // //                               style: TextStyle(
// // // //                                   fontFamily: GoogleFonts.poppins().fontFamily,
// // // //                                   fontWeight: FontWeight.w700)),
// // // //                           Text(
// // // //                             'View and update survey records',
// // // //                             style: TextStyle(
// // // //                               color: Theme.of(context).colorScheme.outline,
// // // //                               fontFamily: GoogleFonts.poppins().fontFamily,
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),

// // // //               // Main Content Area - New UI Structure
// // // //               Expanded(
// // // //                 child: Container(
// // // //                   margin:
// // // //                       const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
// // // //                   decoration: BoxDecoration(
// // // //                     color: Colors.white,
// // // //                     borderRadius: BorderRadius.circular(12),
// // // //                     boxShadow: [
// // // //                       BoxShadow(
// // // //                         color: Colors.black.withOpacity(0.05),
// // // //                         blurRadius: 8,
// // // //                         offset: const Offset(0, 2),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                   child: ClipRRect(
// // // //                     borderRadius: BorderRadius.circular(12),
// // // //                     child: _surveyData.isEmpty
// // // //                         ? ListView(
// // // //                             controller: _scrollController,
// // // //                             children: const [
// // // //                               SizedBox(height: 120),
// // // //                               Center(child: Text('No records found')),
// // // //                             ],
// // // //                           )
// // // //                         : ListView(
// // // //                             controller: _scrollController,
// // // //                             padding: EdgeInsets.zero,
// // // //                             children: [
// // // //                               // Custom Table with updated UI
// // // //                               Container(
// // // //                                 margin: const EdgeInsets.all(8),
// // // //                                 decoration: BoxDecoration(
// // // //                                   border: Border.all(
// // // //                                     color: Colors.grey.shade200,
// // // //                                     width: 1,
// // // //                                   ),
// // // //                                   borderRadius: BorderRadius.circular(8),
// // // //                                 ),
// // // //                                 child: Column(
// // // //                                   children: [
// // // //                                     // Table Header
// // // //                                     Container(
// // // //                                       padding: const EdgeInsets.symmetric(
// // // //                                         horizontal: 16,
// // // //                                         vertical: 12,
// // // //                                       ),
// // // //                                       decoration: BoxDecoration(
// // // //                                         color: Colors.grey[50],
// // // //                                         borderRadius: const BorderRadius.only(
// // // //                                           topLeft: Radius.circular(8),
// // // //                                           topRight: Radius.circular(8),
// // // //                                         ),
// // // //                                       ),
// // // //                                       child: Row(
// // // //                                         children: [
// // // //                                           Expanded(
// // // //                                             child: Text(
// // // //                                               'ID',
// // // //                                               style: textTheme.bodyMedium
// // // //                                                   ?.copyWith(
// // // //                                                 fontWeight: FontWeight.w600,
// // // //                                                 color: Colors.grey[700],
// // // //                                               ),
// // // //                                             ),
// // // //                                           ),
// // // //                                           Expanded(
// // // //                                             flex: 3,
// // // //                                             child: Text(
// // // //                                               'Name',
// // // //                                               style: textTheme.bodyMedium
// // // //                                                   ?.copyWith(
// // // //                                                 fontWeight: FontWeight.w600,
// // // //                                                 color: Colors.grey[700],
// // // //                                                 fontFamily:
// // // //                                                     GoogleFonts.poppins()
// // // //                                                         .fontFamily,
// // // //                                               ),
// // // //                                             ),
// // // //                                           ),
// // // //                                           Expanded(
// // // //                                             flex: 2,
// // // //                                             child: Text(
// // // //                                               'Status',
// // // //                                               style: textTheme.bodyMedium
// // // //                                                   ?.copyWith(
// // // //                                                 fontWeight: FontWeight.w600,
// // // //                                                 color: Colors.grey[700],
// // // //                                                 fontFamily:
// // // //                                                     GoogleFonts.poppins()
// // // //                                                         .fontFamily,
// // // //                                               ),
// // // //                                               textAlign: TextAlign.center,
// // // //                                             ),
// // // //                                           ),
// // // //                                           SizedBox(
// // // //                                             width: 80,
// // // //                                             child: Text(
// // // //                                               'Actions',
// // // //                                               style: textTheme.bodyMedium
// // // //                                                   ?.copyWith(
// // // //                                                 fontWeight: FontWeight.w600,
// // // //                                                 color: Colors.grey[700],
// // // //                                                 fontFamily:
// // // //                                                     GoogleFonts.poppins()
// // // //                                                         .fontFamily,
// // // //                                               ),
// // // //                                               textAlign: TextAlign.end,
// // // //                                             ),
// // // //                                           ),
// // // //                                         ],
// // // //                                       ),
// // // //                                     ),
// // // //                                     // Table Rows
// // // //                                     ..._surveyData.map((row) {
// // // //                                       return Container(
// // // //                                         padding: const EdgeInsets.symmetric(
// // // //                                           horizontal: 16,
// // // //                                           vertical: 12,
// // // //                                         ),
// // // //                                         decoration: BoxDecoration(
// // // //                                           border: Border(
// // // //                                             bottom: BorderSide(
// // // //                                               color: Colors.grey.shade200,
// // // //                                               width: 1,
// // // //                                             ),
// // // //                                           ),
// // // //                                         ),
// // // //                                         child: Row(
// // // //                                           children: [
// // // //                                             Expanded(
// // // //                                               child: Text(
// // // //                                                 row['id'] ?? '-',
// // // //                                                 style: textTheme.bodySmall
// // // //                                                     ?.copyWith(
// // // //                                                   fontFamily:
// // // //                                                       GoogleFonts.poppins()
// // // //                                                           .fontFamily,
// // // //                                                 ),
// // // //                                               ),
// // // //                                             ),
// // // //                                             Expanded(
// // // //                                               flex: 3,
// // // //                                               child: Text(
// // // //                                                 row['name'] ?? '-',
// // // //                                                 style: textTheme.bodySmall
// // // //                                                     ?.copyWith(
// // // //                                                   fontWeight: FontWeight.w500,
// // // //                                                   fontFamily:
// // // //                                                       GoogleFonts.poppins()
// // // //                                                           .fontFamily,
// // // //                                                   fontSize: 11,
// // // //                                                 ),
// // // //                                                 textAlign: TextAlign.start,
// // // //                                               ),
// // // //                                             ),
// // // //                                             Expanded(
// // // //                                               flex: 2,
// // // //                                               child: Container(
// // // //                                                 padding:
// // // //                                                     const EdgeInsets.symmetric(
// // // //                                                   horizontal: 8,
// // // //                                                   vertical: 4,
// // // //                                                 ),
// // // //                                                 decoration: BoxDecoration(
// // // //                                                   color: row['status'] ==
// // // //                                                           'Active'
// // // //                                                       ? Colors.green.shade50
// // // //                                                       : Colors.orange.shade50,
// // // //                                                   borderRadius:
// // // //                                                       BorderRadius.circular(4),
// // // //                                                   border: Border.all(
// // // //                                                     color: row['status'] ==
// // // //                                                             'Active'
// // // //                                                         ? Colors.green.shade200
// // // //                                                         : Colors
// // // //                                                             .orange.shade200,
// // // //                                                   ),
// // // //                                                 ),
// // // //                                                 child: Text(
// // // //                                                   row['status'] ?? '-',
// // // //                                                   style: textTheme.bodySmall
// // // //                                                       ?.copyWith(
// // // //                                                     fontWeight: FontWeight.w600,
// // // //                                                     color: row['status'] ==
// // // //                                                             'Active'
// // // //                                                         ? Colors.green.shade700
// // // //                                                         : Colors
// // // //                                                             .orange.shade700,
// // // //                                                     fontFamily:
// // // //                                                         GoogleFonts.poppins()
// // // //                                                             .fontFamily,
// // // //                                                     fontSize: 10,
// // // //                                                   ),
// // // //                                                   textAlign: TextAlign.center,
// // // //                                                 ),
// // // //                                               ),
// // // //                                             ),
// // // //                                             SizedBox(
// // // //                                               width: 80,
// // // //                                               child: Row(
// // // //                                                 mainAxisAlignment:
// // // //                                                     MainAxisAlignment.end,
// // // //                                                 children: [
// // // //                                                   // Updated Edit Button
// // // //                                                   Container(
// // // //                                                     width: 28,
// // // //                                                     height: 28,
// // // //                                                     decoration: BoxDecoration(
// // // //                                                       color:
// // // //                                                           Colors.blue.shade50,
// // // //                                                       borderRadius:
// // // //                                                           BorderRadius.circular(
// // // //                                                               6),
// // // //                                                     ),
// // // //                                                     child: IconButton(
// // // //                                                       onPressed: () =>
// // // //                                                           Navigator.of(context)
// // // //                                                               .pushNamed(
// // // //                                                         RouteNames.surveyEdit,
// // // //                                                         arguments: {
// // // //                                                           'id': row['id']
// // // //                                                         },
// // // //                                                       ),
// // // //                                                       icon: Icon(
// // // //                                                         Icons.edit_rounded,
// // // //                                                         size: 14,
// // // //                                                         color: Colors
// // // //                                                             .blue.shade700,
// // // //                                                       ),
// // // //                                                       padding: EdgeInsets.zero,
// // // //                                                       tooltip: 'Edit',
// // // //                                                     ),
// // // //                                                   ),
// // // //                                                   const SizedBox(width: 8),
// // // //                                                   // Updated Delete Button
// // // //                                                   Container(
// // // //                                                     width: 28,
// // // //                                                     height: 28,
// // // //                                                     decoration: BoxDecoration(
// // // //                                                       color: Colors.red.shade50,
// // // //                                                       borderRadius:
// // // //                                                           BorderRadius.circular(
// // // //                                                               6),
// // // //                                                     ),
// // // //                                                     child: IconButton(
// // // //                                                       onPressed: () {
// // // //                                                         // Delete functionality
// // // //                                                         _showDeleteDialog(
// // // //                                                             context, row['id']);
// // // //                                                       },
// // // //                                                       icon: Icon(
// // // //                                                         Icons.delete_rounded,
// // // //                                                         size: 14,
// // // //                                                         color:
// // // //                                                             Colors.red.shade700,
// // // //                                                       ),
// // // //                                                       padding: EdgeInsets.zero,
// // // //                                                       tooltip: 'Delete',
// // // //                                                     ),
// // // //                                                   ),
// // // //                                                 ],
// // // //                                               ),
// // // //                                             ),
// // // //                                           ],
// // // //                                         ),
// // // //                                       );
// // // //                                     }).toList(),
// // // //                                   ],
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           // Updated FAB Button
// // // //           Positioned(
// // // //             right: 16,
// // // //             bottom: 16,
// // // //             child: Container(
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.blue.shade600,
// // // //                 borderRadius: BorderRadius.circular(12),
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: Colors.blue.shade800.withOpacity(0.3),
// // // //                     blurRadius: 8,
// // // //                     offset: const Offset(0, 4),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               child: Material(
// // // //                 color: Colors.transparent,
// // // //                 child: InkWell(
// // // //                   onTap: () async {
// // // //                     await Navigator.of(context).pushNamed(RouteNames.surveyAdd);
// // // //                   },
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                   child: Container(
// // // //                     padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 16,
// // // //                       vertical: 12,
// // // //                     ),
// // // //                     child: Row(
// // // //                       children: [
// // // //                         Icon(
// // // //                           Icons.add_rounded,
// // // //                           color: Colors.white,
// // // //                           size: 18,
// // // //                         ),
// // // //                         const SizedBox(width: 6),
// // // //                         Text(
// // // //                           AppStrings.addNew,
// // // //                           style: TextStyle(
// // // //                             color: Colors.white,
// // // //                             fontWeight: FontWeight.w600,
// // // //                             fontSize: 14,
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _showDeleteDialog(BuildContext context, String id) {
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) => AlertDialog(
// // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // //         title: const Text(
// // // //           'Delete Survey',
// // // //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
// // // //         ),
// // // //         content: Text(
// // // //           'Are you sure you want to delete survey $id?',
// // // //           style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context),
// // // //             child: const Text(
// // // //               'Cancel',
// // // //               style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
// // // //             ),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               // Add delete logic here
// // // //               ScaffoldMessenger.of(context).showSnackBar(
// // // //                 SnackBar(content: Text('Survey $id deleted')),
// // // //               );
// // // //             },
// // // //             style: ElevatedButton.styleFrom(
// // // //               backgroundColor: Colors.red.shade600,
// // // //               shape: RoundedRectangleBorder(
// // // //                 borderRadius: BorderRadius.circular(6),
// // // //               ),
// // // //             ),
// // // //             child: const Text(
// // // //               'Delete',
// // // //               style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import '../../../app/routes/route_names.dart';
// // // import '../../../core/constants/app_strings.dart';

// // // class SurveyListScreen extends StatefulWidget {
// // //   const SurveyListScreen({super.key});

// // //   @override
// // //   State<SurveyListScreen> createState() => _SurveyListScreenState();
// // // }

// // // class _SurveyListScreenState extends State<SurveyListScreen> {
// // //   final _scrollController = ScrollController();
// // //   final _searchController = TextEditingController();
// // //   String _searchQuery = '';
// // //   bool _showSearchBar = false;
// // //   bool _isLoading = false;
// // //   bool _hasMore = true;

// // //   // Pagination variables
// // //   int _currentPage = 0;
// // //   final int _itemsPerPage = 10; // Changed to 10 items per page

// // //   // Static survey data list
// // //   final List<Map<String, dynamic>> _allSurveyData = [
// // //     {
// // //       'id': 'SRV001',
// // //       'name': 'Green Valley Apartments Survey',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV002',
// // //       'name': 'Skyline Towers Customer Feedback',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV003',
// // //       'name': 'Sunrise Complex Satisfaction Survey',
// // //       'status': 'Inactive',
// // //     },
// // //     {
// // //       'id': 'SRV004',
// // //       'name': 'Royal Residency Market Research',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV005',
// // //       'name': 'Ocean View Property Analysis',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV006',
// // //       'name': 'Downtown Plaza Survey',
// // //       'status': 'Inactive',
// // //     },
// // //     {
// // //       'id': 'SRV007',
// // //       'name': 'Hill Station Residential Survey',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV008',
// // //       'name': 'Metro Heights Customer Survey',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV009',
// // //       'name': 'Park Avenue Commercial Survey',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV010',
// // //       'name': 'Riverside Apartments Analysis',
// // //       'status': 'Inactive',
// // //     },
// // //     {
// // //       'id': 'SRV011',
// // //       'name': 'Tech Park Office Survey',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV012',
// // //       'name': 'Lakeside Villas Customer Feedback',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV013',
// // //       'name': 'Green Valley Apartments Survey 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV014',
// // //       'name': 'Skyline Towers Customer Feedback 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV015',
// // //       'name': 'Sunrise Complex Satisfaction Survey 2',
// // //       'status': 'Inactive',
// // //     },
// // //     {
// // //       'id': 'SRV016',
// // //       'name': 'Royal Residency Market Research 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV017',
// // //       'name': 'Ocean View Property Analysis 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV018',
// // //       'name': 'Downtown Plaza Survey 2',
// // //       'status': 'Inactive',
// // //     },
// // //     {
// // //       'id': 'SRV019',
// // //       'name': 'Hill Station Residential Survey 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV020',
// // //       'name': 'Metro Heights Customer Survey 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV021',
// // //       'name': 'Park Avenue Commercial Survey 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV022',
// // //       'name': 'Riverside Apartments Analysis 2',
// // //       'status': 'Inactive',
// // //     },
// // //     {
// // //       'id': 'SRV023',
// // //       'name': 'Tech Park Office Survey 2',
// // //       'status': 'Active',
// // //     },
// // //     {
// // //       'id': 'SRV024',
// // //       'name': 'Lakeside Villas Customer Feedback 2',
// // //       'status': 'Active',
// // //     },
// // //   ];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _scrollController.addListener(_onScroll);
// // //   }

// // //   void _onScroll() {
// // //     if (_scrollController.position.pixels ==
// // //             _scrollController.position.maxScrollExtent &&
// // //         _hasMore &&
// // //         !_isLoading) {
// // //       _loadMoreData();
// // //     }
// // //   }

// // //   Future<void> _loadMoreData() async {
// // //     if (_isLoading || !_hasMore) return;

// // //     setState(() {
// // //       _isLoading = true;
// // //     });

// // //     // Simulate network delay
// // //     await Future.delayed(const Duration(seconds: 1));

// // //     setState(() {
// // //       _currentPage++;
// // //       _isLoading = false;

// // //       // Check if there's more data to load
// // //       final totalItemsLoaded = (_currentPage + 1) * _itemsPerPage;
// // //       _hasMore = totalItemsLoaded < _filteredData.length;
// // //     });
// // //   }

// // //   List<Map<String, dynamic>> get _filteredData {
// // //     if (_searchQuery.isEmpty) {
// // //       return _allSurveyData;
// // //     }
// // //     return _allSurveyData.where((item) {
// // //       final name = item['name'].toString().toLowerCase();
// // //       final id = item['id'].toString().toLowerCase();
// // //       final query = _searchQuery.toLowerCase();
// // //       return name.contains(query) || id.contains(query);
// // //     }).toList();
// // //   }

// // //   List<Map<String, dynamic>> get _paginatedData {
// // //     final filtered = _filteredData;
// // //     final startIndex = 0; // Always start from 0 for ListView.builder
// // //     final endIndex =
// // //         ((_currentPage + 1) * _itemsPerPage).clamp(0, filtered.length);

// // //     if (startIndex >= filtered.length) {
// // //       return [];
// // //     }

// // //     return filtered.sublist(startIndex, endIndex);
// // //   }

// // //   void _onSearchChanged(String value) {
// // //     setState(() {
// // //       _searchQuery = value;
// // //       _currentPage = 0; // Reset to first page on search
// // //       _hasMore = (_itemsPerPage < _filteredData.length); // Reset hasMore
// // //     });
// // //   }

// // //   void _toggleSearchBar() {
// // //     setState(() {
// // //       _showSearchBar = !_showSearchBar;
// // //       if (!_showSearchBar) {
// // //         _searchController.clear();
// // //         _searchQuery = '';
// // //         _currentPage = 0;
// // //         _hasMore = (_itemsPerPage < _allSurveyData.length);
// // //       }
// // //     });
// // //   }

// // //   void _resetPagination() {
// // //     setState(() {
// // //       _currentPage = 0;
// // //       _hasMore = (_itemsPerPage < _filteredData.length);
// // //     });
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _scrollController.dispose();
// // //     _searchController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final textTheme = Theme.of(context).textTheme;
// // //     final paginatedData = _paginatedData;
// // //     final totalItems = _filteredData.length;

// // //     return Scaffold(
// // //       backgroundColor: Colors.grey[100],
// // //       appBar: AppBar(
// // //         elevation: 0,
// // //         backgroundColor: Colors.white,
// // //         leading: IconButton(
// // //           icon: Container(
// // //             padding: const EdgeInsets.all(8),
// // //             decoration: BoxDecoration(
// // //               color: const Color(0xFFEDF2F7),
// // //               borderRadius: BorderRadius.circular(10),
// // //             ),
// // //             child: const Icon(
// // //               Icons.arrow_back_ios_new_rounded,
// // //               color: Color(0xFF2D3748),
// // //               size: 18,
// // //             ),
// // //           ),
// // //           onPressed: () => Navigator.pop(context),
// // //         ),
// // //         title: const Text(
// // //           'Survey Data',
// // //           style: TextStyle(
// // //             color: Color(0xFF2D3748),
// // //             fontSize: 16,
// // //             fontWeight: FontWeight.w700,
// // //           ),
// // //         ),
// // //         actions: [
// // //           // Search Icon
// // //           IconButton(
// // //             onPressed: _toggleSearchBar,
// // //             icon: Container(
// // //               padding: const EdgeInsets.all(8),
// // //               decoration: BoxDecoration(
// // //                 color: const Color(0xFFEDF2F7),
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Icon(
// // //                 _showSearchBar ? Icons.close : Icons.search,
// // //                 color: const Color(0xFF2D3748),
// // //                 size: 18,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Animated Search Bar
// // //           AnimatedContainer(
// // //             duration: const Duration(milliseconds: 300),
// // //             height: _showSearchBar ? 70 : 0,
// // //             curve: Curves.easeInOut,
// // //             child: Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //               color: Colors.white,
// // //               child: TextField(
// // //                 controller: _searchController,
// // //                 onChanged: _onSearchChanged,
// // //                 style: const TextStyle(fontSize: 14),
// // //                 decoration: InputDecoration(
// // //                   hintText: 'Search by ID or Name...',
// // //                   hintStyle:
// // //                       const TextStyle(fontSize: 13, color: Color(0xFF718096)),
// // //                   prefixIcon: const Icon(Icons.search,
// // //                       size: 20, color: Color(0xFF667eea)),
// // //                   suffixIcon: _searchQuery.isNotEmpty
// // //                       ? IconButton(
// // //                           onPressed: () {
// // //                             _searchController.clear();
// // //                             _onSearchChanged('');
// // //                           },
// // //                           icon: const Icon(Icons.clear, size: 18),
// // //                         )
// // //                       : null,
// // //                   filled: true,
// // //                   fillColor: const Color(0xFFF7FAFC),
// // //                   contentPadding:
// // //                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     borderSide: BorderSide.none,
// // //                   ),
// // //                   enabledBorder: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
// // //                   ),
// // //                   focusedBorder: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     borderSide:
// // //                         const BorderSide(color: Color(0xFF667eea), width: 1.5),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),

// // //           // Header Card
// // //           Container(
// // //             margin: const EdgeInsets.all(8),
// // //             padding: const EdgeInsets.all(12),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(12),
// // //               boxShadow: [
// // //                 BoxShadow(
// // //                   color: Colors.black.withOpacity(0.05),
// // //                   blurRadius: 8,
// // //                   offset: const Offset(0, 2),
// // //                 ),
// // //               ],
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   padding: const EdgeInsets.all(8),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.blue.shade50,
// // //                     borderRadius: BorderRadius.circular(8),
// // //                   ),
// // //                   child: Icon(
// // //                     Icons.analytics_rounded,
// // //                     color: Colors.blue.shade700,
// // //                     size: 20,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 10),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text('Survey Records',
// // //                           style: TextStyle(
// // //                               fontFamily: GoogleFonts.poppins().fontFamily,
// // //                               fontWeight: FontWeight.w700)),
// // //                       Text(
// // //                         'Showing ${paginatedData.length} of $totalItems surveys',
// // //                         style: TextStyle(
// // //                           color: Theme.of(context).colorScheme.outline,
// // //                           fontFamily: GoogleFonts.poppins().fontFamily,
// // //                           fontSize: 12,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 if (totalItems > 10)
// // //                   Text(
// // //                     'Scroll down to load more',
// // //                     style: TextStyle(
// // //                       color: Colors.blue.shade600,
// // //                       fontSize: 11,
// // //                       fontWeight: FontWeight.w500,
// // //                     ),
// // //                   ),
// // //               ],
// // //             ),
// // //           ),

// // //           // Main Content Area
// // //           Expanded(
// // //             child: Container(
// // //               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(12),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: Colors.black.withOpacity(0.05),
// // //                     blurRadius: 8,
// // //                     offset: const Offset(0, 2),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: ClipRRect(
// // //                 borderRadius: BorderRadius.circular(12),
// // //                 child: paginatedData.isEmpty
// // //                     ? ListView(
// // //                         controller: _scrollController,
// // //                         children: const [
// // //                           SizedBox(height: 120),
// // //                           Center(child: Text('No records found')),
// // //                         ],
// // //                       )
// // //                     : Column(
// // //                         children: [
// // //                           // Table Header (Fixed)
// // //                           Container(
// // //                             padding: const EdgeInsets.symmetric(
// // //                               horizontal: 16,
// // //                               vertical: 12,
// // //                             ),
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.grey[50],
// // //                               border: Border(
// // //                                 bottom: BorderSide(
// // //                                   color: Colors.grey.shade200,
// // //                                   width: 1,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             child: Row(
// // //                               children: [
// // //                                 Expanded(
// // //                                   child: Text(
// // //                                     'ID',
// // //                                     style: textTheme.bodyMedium?.copyWith(
// // //                                       fontWeight: FontWeight.w600,
// // //                                       color: Colors.grey[700],
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                                 Expanded(
// // //                                   flex: 3,
// // //                                   child: Text(
// // //                                     'Name',
// // //                                     style: textTheme.bodyMedium?.copyWith(
// // //                                       fontWeight: FontWeight.w600,
// // //                                       color: Colors.grey[700],
// // //                                       fontFamily:
// // //                                           GoogleFonts.poppins().fontFamily,
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                                 Expanded(
// // //                                   flex: 2,
// // //                                   child: Text(
// // //                                     'Status',
// // //                                     style: textTheme.bodyMedium?.copyWith(
// // //                                       fontWeight: FontWeight.w600,
// // //                                       color: Colors.grey[700],
// // //                                       fontFamily:
// // //                                           GoogleFonts.poppins().fontFamily,
// // //                                     ),
// // //                                     textAlign: TextAlign.center,
// // //                                   ),
// // //                                 ),
// // //                                 SizedBox(
// // //                                   width: 80,
// // //                                   child: Text(
// // //                                     'Actions',
// // //                                     style: textTheme.bodyMedium?.copyWith(
// // //                                       fontWeight: FontWeight.w600,
// // //                                       color: Colors.grey[700],
// // //                                       fontFamily:
// // //                                           GoogleFonts.poppins().fontFamily,
// // //                                     ),
// // //                                     textAlign: TextAlign.end,
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),

// // //                           // Scrollable Table Body
// // //                           Expanded(
// // //                             child: ListView.builder(
// // //                               controller: _scrollController,
// // //                               padding: EdgeInsets.zero,
// // //                               itemCount:
// // //                                   paginatedData.length + (_isLoading ? 1 : 0),
// // //                               itemBuilder: (context, index) {
// // //                                 // Loading indicator at the bottom
// // //                                 if (index >= paginatedData.length) {
// // //                                   return Container(
// // //                                     padding: const EdgeInsets.symmetric(
// // //                                         vertical: 20),
// // //                                     child: Center(
// // //                                       child: _hasMore
// // //                                           ? const CircularProgressIndicator()
// // //                                           : Container(
// // //                                               padding: const EdgeInsets.all(16),
// // //                                               child: Text(
// // //                                                 'No more surveys to load',
// // //                                                 style: TextStyle(
// // //                                                   color: Colors.grey[600],
// // //                                                   fontSize: 12,
// // //                                                 ),
// // //                                               ),
// // //                                             ),
// // //                                     ),
// // //                                   );
// // //                                 }

// // //                                 final row = paginatedData[index];
// // //                                 return Container(
// // //                                   padding: const EdgeInsets.symmetric(
// // //                                     horizontal: 16,
// // //                                     vertical: 12,
// // //                                   ),
// // //                                   decoration: BoxDecoration(
// // //                                     border: Border(
// // //                                       bottom: BorderSide(
// // //                                         color: Colors.grey.shade200,
// // //                                         width: 1,
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   child: Row(
// // //                                     children: [
// // //                                       Expanded(
// // //                                         child: Text(
// // //                                           row['id'] ?? '-',
// // //                                           style: textTheme.bodySmall?.copyWith(
// // //                                             fontFamily: GoogleFonts.poppins()
// // //                                                 .fontFamily,
// // //                                           ),
// // //                                         ),
// // //                                       ),
// // //                                       Expanded(
// // //                                         flex: 3,
// // //                                         child: Text(
// // //                                           row['name'] ?? '-',
// // //                                           style: textTheme.bodySmall?.copyWith(
// // //                                             fontWeight: FontWeight.w500,
// // //                                             fontFamily: GoogleFonts.poppins()
// // //                                                 .fontFamily,
// // //                                             fontSize: 11,
// // //                                           ),
// // //                                           textAlign: TextAlign.start,
// // //                                         ),
// // //                                       ),
// // //                                       Expanded(
// // //                                         flex: 2,
// // //                                         child: Container(
// // //                                           padding: const EdgeInsets.symmetric(
// // //                                             horizontal: 8,
// // //                                             vertical: 4,
// // //                                           ),
// // //                                           decoration: BoxDecoration(
// // //                                             color: row['status'] == 'Active'
// // //                                                 ? Colors.green.shade50
// // //                                                 : Colors.orange.shade50,
// // //                                             borderRadius:
// // //                                                 BorderRadius.circular(4),
// // //                                             border: Border.all(
// // //                                               color: row['status'] == 'Active'
// // //                                                   ? Colors.green.shade200
// // //                                                   : Colors.orange.shade200,
// // //                                             ),
// // //                                           ),
// // //                                           child: Text(
// // //                                             row['status'] ?? '-',
// // //                                             style:
// // //                                                 textTheme.bodySmall?.copyWith(
// // //                                               fontWeight: FontWeight.w600,
// // //                                               color: row['status'] == 'Active'
// // //                                                   ? Colors.green.shade700
// // //                                                   : Colors.orange.shade700,
// // //                                               fontFamily: GoogleFonts.poppins()
// // //                                                   .fontFamily,
// // //                                               fontSize: 10,
// // //                                             ),
// // //                                             textAlign: TextAlign.center,
// // //                                           ),
// // //                                         ),
// // //                                       ),
// // //                                       SizedBox(
// // //                                         width: 80,
// // //                                         child: Row(
// // //                                           mainAxisAlignment:
// // //                                               MainAxisAlignment.end,
// // //                                           children: [
// // //                                             // Edit Button
// // //                                             Container(
// // //                                               width: 28,
// // //                                               height: 28,
// // //                                               decoration: BoxDecoration(
// // //                                                 color: Colors.blue.shade50,
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(6),
// // //                                               ),
// // //                                               child: IconButton(
// // //                                                 onPressed: () =>
// // //                                                     Navigator.of(context)
// // //                                                         .pushNamed(
// // //                                                   RouteNames.surveyEdit,
// // //                                                   arguments: {'id': row['id']},
// // //                                                 ),
// // //                                                 icon: Icon(
// // //                                                   Icons.edit_rounded,
// // //                                                   size: 14,
// // //                                                   color: Colors.blue.shade700,
// // //                                                 ),
// // //                                                 padding: EdgeInsets.zero,
// // //                                                 tooltip: 'Edit',
// // //                                               ),
// // //                                             ),
// // //                                             const SizedBox(width: 8),
// // //                                             // Delete Button
// // //                                             Container(
// // //                                               width: 28,
// // //                                               height: 28,
// // //                                               decoration: BoxDecoration(
// // //                                                 color: Colors.red.shade50,
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(6),
// // //                                               ),
// // //                                               child: IconButton(
// // //                                                 onPressed: () {
// // //                                                   _showDeleteDialog(
// // //                                                       context, row['id']);
// // //                                                 },
// // //                                                 icon: Icon(
// // //                                                   Icons.delete_rounded,
// // //                                                   size: 14,
// // //                                                   color: Colors.red.shade700,
// // //                                                 ),
// // //                                                 padding: EdgeInsets.zero,
// // //                                                 tooltip: 'Delete',
// // //                                               ),
// // //                                             ),
// // //                                           ],
// // //                                         ),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 8),
// // //         ],
// // //       ),
// // //       // FAB Button
// // //       floatingActionButton: Container(
// // //         decoration: BoxDecoration(
// // //           color: Colors.blue.shade600,
// // //           borderRadius: BorderRadius.circular(12),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.blue.shade800.withOpacity(0.3),
// // //               blurRadius: 8,
// // //               offset: const Offset(0, 4),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Material(
// // //           color: Colors.transparent,
// // //           child: InkWell(
// // //             onTap: () async {
// // //               await Navigator.of(context).pushNamed(RouteNames.surveyAdd);
// // //             },
// // //             borderRadius: BorderRadius.circular(12),
// // //             child: Container(
// // //               padding: const EdgeInsets.symmetric(
// // //                 horizontal: 16,
// // //                 vertical: 12,
// // //               ),
// // //               child: Row(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 children: [
// // //                   Icon(
// // //                     Icons.add_rounded,
// // //                     color: Colors.white,
// // //                     size: 18,
// // //                   ),
// // //                   const SizedBox(width: 6),
// // //                   Text(
// // //                     AppStrings.addNew,
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontWeight: FontWeight.w600,
// // //                       fontSize: 14,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// // //     );
// // //   }

// // //   void _showDeleteDialog(BuildContext context, String id) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //         title: const Text(
// // //           'Delete Survey',
// // //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
// // //         ),
// // //         content: Text(
// // //           'Are you sure you want to delete survey $id?',
// // //           style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context),
// // //             child: const Text(
// // //               'Cancel',
// // //               style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
// // //             ),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               Navigator.pop(context);
// // //               // Add delete logic here
// // //               ScaffoldMessenger.of(context).showSnackBar(
// // //                 SnackBar(content: Text('Survey $id deleted')),
// // //               );
// // //             },
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.red.shade600,
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(6),
// // //               ),
// // //             ),
// // //             child: const Text(
// // //               'Delete',
// // //               style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:data_care_app/features/model/survey_model/survey_model.dart';
// // import 'package:data_care_app/features/survey_data/screens/new_survey/survey_form_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class SurveyListScreen extends StatefulWidget {
// //   const SurveyListScreen({super.key});

// //   @override
// //   State<SurveyListScreen> createState() => _SurveyListScreenState();
// // }

// // class _SurveyListScreenState extends State<SurveyListScreen> {
// //   final _scrollController = ScrollController();
// //   final _searchController = TextEditingController();
// //   String _searchQuery = '';
// //   bool _showSearchBar = false;
// //   bool _isLoading = false;
// //   bool _hasMore = true;

// //   // Pagination variables
// //   int _currentPage = 0;
// //   final int _itemsPerPage = 10;

// //   // Survey data list
// //   List<Survey> _allSurveyData = [
// //     Survey(
// //       id: 'SRV001',
// //       name: 'Green Valley Apartments Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV002',
// //       name: 'Skyline Towers Customer Feedback',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV003',
// //       name: 'Sunrise Complex Satisfaction Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV004',
// //       name: 'Royal Residency Market Research',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV005',
// //       name: 'Ocean View Property Analysis',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV006',
// //       name: 'Downtown Plaza Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV007',
// //       name: 'Hill Station Residential Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV008',
// //       name: 'Metro Heights Customer Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV009',
// //       name: 'Park Avenue Commercial Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV010',
// //       name: 'Riverside Apartments Analysis',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV011',
// //       name: 'Tech Park Office Survey',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //     Survey(
// //       id: 'SRV012',
// //       name: 'Lakeside Villas Customer Feedback',
// //       propertyId: '',
// //       municipality: '',
// //       integratedPid: '',
// //       integratedOwner: '',
// //       areaOfAuthority: '',
// //       colony: '',
// //       address: '',
// //       mobile: '',
// //       category: '',
// //       totalArea: '',
// //       unit: '',
// //       authorizationStatus: '',
// //     ),
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController.addListener(_onScroll);
// //   }

// //   void _onScroll() {
// //     if (_scrollController.position.pixels ==
// //             _scrollController.position.maxScrollExtent &&
// //         _hasMore &&
// //         !_isLoading) {
// //       _loadMoreData();
// //     }
// //   }

// //   Future<void> _loadMoreData() async {
// //     if (_isLoading || !_hasMore) return;

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     // Simulate network delay
// //     await Future.delayed(const Duration(seconds: 1));

// //     setState(() {
// //       _currentPage++;
// //       _isLoading = false;

// //       // Check if there's more data to load
// //       final totalItemsLoaded = (_currentPage + 1) * _itemsPerPage;
// //       _hasMore = totalItemsLoaded < _filteredData.length;
// //     });
// //   }

// //   List<Survey> get _filteredData {
// //     if (_searchQuery.isEmpty) {
// //       return _allSurveyData;
// //     }
// //     return _allSurveyData.where((survey) {
// //       final name = survey.name.toLowerCase();
// //       final id = survey.id.toLowerCase();
// //       final query = _searchQuery.toLowerCase();
// //       return name.contains(query) || id.contains(query);
// //     }).toList();
// //   }

// //   List<Survey> get _paginatedData {
// //     final filtered = _filteredData;
// //     final endIndex =
// //         ((_currentPage + 1) * _itemsPerPage).clamp(0, filtered.length);

// //     return filtered.sublist(0, endIndex);
// //   }

// //   void _onSearchChanged(String value) {
// //     setState(() {
// //       _searchQuery = value;
// //       _currentPage = 0;
// //       _hasMore = (_itemsPerPage < _filteredData.length);
// //     });
// //   }

// //   void _toggleSearchBar() {
// //     setState(() {
// //       _showSearchBar = !_showSearchBar;
// //       if (!_showSearchBar) {
// //         _searchController.clear();
// //         _searchQuery = '';
// //         _currentPage = 0;
// //         _hasMore = (_itemsPerPage < _allSurveyData.length);
// //       }
// //     });
// //   }

// //   Future<void> _navigateToAddSurvey() async {
// //     final result = await Navigator.of(context).push(
// //       MaterialPageRoute(
// //         builder: (context) => const SurveyFormScreen(isEditMode: false),
// //       ),
// //     );

// //     if (result != null && result is Survey) {
// //       setState(() {
// //         _allSurveyData.insert(0, result);
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Survey "${result.name}" created successfully'),
// //           backgroundColor: Colors.green.shade600,
// //           duration: const Duration(seconds: 2),
// //         ),
// //       );
// //     }
// //   }

// //   Future<void> _navigateToEditSurvey(Survey survey) async {
// //     final result = await Navigator.of(context).push(
// //       MaterialPageRoute(
// //         builder: (context) => SurveyFormScreen(
// //           survey: survey,
// //           isEditMode: true,
// //         ),
// //       ),
// //     );

// //     if (result != null && result is Survey) {
// //       setState(() {
// //         final index = _allSurveyData.indexWhere((s) => s.id == result.id);
// //         if (index != -1) {
// //           _allSurveyData[index] = result;
// //         }
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Survey "${result.name}" updated successfully'),
// //           backgroundColor: Colors.blue.shade600,
// //           duration: const Duration(seconds: 2),
// //         ),
// //       );
// //     }
// //   }

// //   void _showDeleteDialog(BuildContext context, Survey survey) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         title: const Text(
// //           'Delete Survey',
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
// //         ),
// //         content: Text(
// //           'Are you sure you want to delete survey "${survey.name}"?',
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
// //               setState(() {
// //                 _allSurveyData.removeWhere((s) => s.id == survey.id);
// //               });

// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                   content: Text('Survey "${survey.name}" deleted successfully'),
// //                   backgroundColor: Colors.red.shade600,
// //                   duration: const Duration(seconds: 2),
// //                 ),
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

// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final textTheme = Theme.of(context).textTheme;
// //     final paginatedData = _paginatedData;
// //     final totalItems = _filteredData.length;

// //     return Scaffold(
// //       backgroundColor: Colors.grey[100],
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         leading: IconButton(
// //           icon: Container(
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFFEDF2F7),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: const Icon(
// //               Icons.arrow_back_ios_new_rounded,
// //               color: Color(0xFF2D3748),
// //               size: 18,
// //             ),
// //           ),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: const Text(
// //           'Survey Data',
// //           style: TextStyle(
// //             color: Color(0xFF2D3748),
// //             fontSize: 16,
// //             fontWeight: FontWeight.w700,
// //           ),
// //         ),
// //         actions: [
// //           // Search Icon
// //           IconButton(
// //             onPressed: _toggleSearchBar,
// //             icon: Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFEDF2F7),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Icon(
// //                 _showSearchBar ? Icons.close : Icons.search,
// //                 color: const Color(0xFF2D3748),
// //                 size: 18,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Animated Search Bar
// //           AnimatedContainer(
// //             duration: const Duration(milliseconds: 300),
// //             height: _showSearchBar ? 70 : 0,
// //             curve: Curves.easeInOut,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //               color: Colors.white,
// //               child: TextField(
// //                 controller: _searchController,
// //                 onChanged: _onSearchChanged,
// //                 style: const TextStyle(fontSize: 14),
// //                 decoration: InputDecoration(
// //                   hintText: 'Search by ID or Name...',
// //                   hintStyle:
// //                       const TextStyle(fontSize: 13, color: Color(0xFF718096)),
// //                   prefixIcon: const Icon(Icons.search,
// //                       size: 20, color: Color(0xFF667eea)),
// //                   suffixIcon: _searchQuery.isNotEmpty
// //                       ? IconButton(
// //                           onPressed: () {
// //                             _searchController.clear();
// //                             _onSearchChanged('');
// //                           },
// //                           icon: const Icon(Icons.clear, size: 18),
// //                         )
// //                       : null,
// //                   filled: true,
// //                   fillColor: const Color(0xFFF7FAFC),
// //                   contentPadding:
// //                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   enabledBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
// //                   ),
// //                   focusedBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide:
// //                         const BorderSide(color: Color(0xFF667eea), width: 1.5),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),

// //           // Header Card
// //           Container(
// //             margin: const EdgeInsets.all(8),
// //             padding: const EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.05),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.blue.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Icon(
// //                     Icons.analytics_rounded,
// //                     color: Colors.blue.shade700,
// //                     size: 20,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text('Survey Records',
// //                           style: TextStyle(
// //                               fontFamily: GoogleFonts.poppins().fontFamily,
// //                               fontWeight: FontWeight.w700)),
// //                       Text(
// //                         'Showing ${paginatedData.length} of $totalItems surveys',
// //                         style: TextStyle(
// //                           color: Theme.of(context).colorScheme.outline,
// //                           fontFamily: GoogleFonts.poppins().fontFamily,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 if (totalItems > 10)
// //                   Text(
// //                     'Scroll down to load more',
// //                     style: TextStyle(
// //                       color: Colors.blue.shade600,
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           ),

// //           // Main Content Area
// //           Expanded(
// //             child: Container(
// //               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.05),
// //                     blurRadius: 8,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: ClipRRect(
// //                 borderRadius: BorderRadius.circular(12),
// //                 child: paginatedData.isEmpty
// //                     ? ListView(
// //                         controller: _scrollController,
// //                         children: const [
// //                           SizedBox(height: 120),
// //                           Center(child: Text('No records found')),
// //                         ],
// //                       )
// //                     : Column(
// //                         children: [
// //                           // Table Header (Fixed)
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 16,
// //                               vertical: 12,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: Colors.grey[50],
// //                               border: Border(
// //                                 bottom: BorderSide(
// //                                   color: Colors.grey.shade200,
// //                                   width: 1,
// //                                 ),
// //                               ),
// //                             ),
// //                             child: Row(
// //                               children: [
// //                                 Expanded(
// //                                   child: Text(
// //                                     'ID',
// //                                     style: textTheme.bodyMedium?.copyWith(
// //                                       fontWeight: FontWeight.w600,
// //                                       color: Colors.grey[700],
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 Expanded(
// //                                   flex: 3,
// //                                   child: Text(
// //                                     'Name',
// //                                     style: textTheme.bodyMedium?.copyWith(
// //                                       fontWeight: FontWeight.w600,
// //                                       color: Colors.grey[700],
// //                                       fontFamily:
// //                                           GoogleFonts.poppins().fontFamily,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(
// //                                   width: 80,
// //                                   child: Text(
// //                                     'Actions',
// //                                     style: textTheme.bodyMedium?.copyWith(
// //                                       fontWeight: FontWeight.w600,
// //                                       color: Colors.grey[700],
// //                                       fontFamily:
// //                                           GoogleFonts.poppins().fontFamily,
// //                                     ),
// //                                     textAlign: TextAlign.end,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),

// //                           // Scrollable Table Body
// //                           Expanded(
// //                             child: ListView.builder(
// //                               controller: _scrollController,
// //                               padding: EdgeInsets.zero,
// //                               itemCount:
// //                                   paginatedData.length + (_isLoading ? 1 : 0),
// //                               itemBuilder: (context, index) {
// //                                 // Loading indicator at the bottom
// //                                 if (index >= paginatedData.length) {
// //                                   return Container(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         vertical: 20),
// //                                     child: Center(
// //                                       child: _hasMore
// //                                           ? const CircularProgressIndicator()
// //                                           : Container(
// //                                               padding: const EdgeInsets.all(16),
// //                                               child: Text(
// //                                                 'No more surveys to load',
// //                                                 style: TextStyle(
// //                                                   color: Colors.grey[600],
// //                                                   fontSize: 12,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                     ),
// //                                   );
// //                                 }

// //                                 final survey = paginatedData[index];
// //                                 return Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                     horizontal: 16,
// //                                     vertical: 12,
// //                                   ),
// //                                   decoration: BoxDecoration(
// //                                     border: Border(
// //                                       bottom: BorderSide(
// //                                         color: Colors.grey.shade200,
// //                                         width: 1,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   child: Row(
// //                                     children: [
// //                                       Expanded(
// //                                         child: Text(
// //                                           survey.id,
// //                                           style: textTheme.bodySmall?.copyWith(
// //                                             fontFamily: GoogleFonts.poppins()
// //                                                 .fontFamily,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       Expanded(
// //                                         flex: 3,
// //                                         child: Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: [
// //                                             Text(
// //                                               survey.name,
// //                                               style:
// //                                                   textTheme.bodySmall?.copyWith(
// //                                                 fontWeight: FontWeight.w500,
// //                                                 fontFamily:
// //                                                     GoogleFonts.poppins()
// //                                                         .fontFamily,
// //                                                 fontSize: 11,
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                       SizedBox(
// //                                         width: 80,
// //                                         child: Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.end,
// //                                           children: [
// //                                             // Edit Button
// //                                             Container(
// //                                               width: 28,
// //                                               height: 28,
// //                                               decoration: BoxDecoration(
// //                                                 color: Colors.blue.shade50,
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(6),
// //                                               ),
// //                                               child: IconButton(
// //                                                 onPressed: () =>
// //                                                     _navigateToEditSurvey(
// //                                                         survey),
// //                                                 icon: Icon(
// //                                                   Icons.edit_rounded,
// //                                                   size: 14,
// //                                                   color: Colors.blue.shade700,
// //                                                 ),
// //                                                 padding: EdgeInsets.zero,
// //                                                 tooltip: 'Edit',
// //                                               ),
// //                                             ),
// //                                             const SizedBox(width: 8),
// //                                             // Delete Button
// //                                             Container(
// //                                               width: 28,
// //                                               height: 28,
// //                                               decoration: BoxDecoration(
// //                                                 color: Colors.red.shade50,
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(6),
// //                                               ),
// //                                               child: IconButton(
// //                                                 onPressed: () {
// //                                                   _showDeleteDialog(
// //                                                       context, survey);
// //                                                 },
// //                                                 icon: Icon(
// //                                                   Icons.delete_rounded,
// //                                                   size: 14,
// //                                                   color: Colors.red.shade700,
// //                                                 ),
// //                                                 padding: EdgeInsets.zero,
// //                                                 tooltip: 'Delete',
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //         ],
// //       ),
// //       // FAB Button
// //       floatingActionButton: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.blue.shade600,
// //           borderRadius: BorderRadius.circular(12),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.blue.shade800.withOpacity(0.3),
// //               blurRadius: 8,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Material(
// //           color: Colors.transparent,
// //           child: InkWell(
// //             onTap: _navigateToAddSurvey,
// //             borderRadius: BorderRadius.circular(12),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(
// //                 horizontal: 16,
// //                 vertical: 12,
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Icon(
// //                     Icons.add_rounded,
// //                     color: Colors.white,
// //                     size: 18,
// //                   ),
// //                   const SizedBox(width: 6),
// //                   Text(
// //                     'Add New',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// //     );
// //   }
// // }

// import 'package:data_care_app/features/model/survey_model/survey_model.dart';
// import 'package:data_care_app/features/survey_data/screens/new_survey/survey_form_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SurveyListScreen extends StatefulWidget {
//   const SurveyListScreen({super.key});

//   @override
//   State<SurveyListScreen> createState() => _SurveyListScreenState();
// }

// class _SurveyListScreenState extends State<SurveyListScreen> {
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

//   // Survey data list with all fields
//   List<Survey> _allSurveyData = [
//     Survey(
//       id: 'SRV001',
//       name: 'Green Valley Apartments Survey',
//       propertyId: 'BGR/W19/394',
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
//     Survey(
//       id: 'SRV002',
//       name: 'Skyline Towers Customer Feedback',
//       propertyId: 'NA',
//       municipality: 'NA',
//       integratedPid: '',
//       integratedOwner: 'Parvinder Rathore',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address:
//           '115, Ramesh Auto Works, Aggarwal Colony, Railway Station, 124507',
//       mobile: '4117',
//       category: 'Mixed Use',
//       totalArea: '427.87',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Survey(
//       id: 'SRV003',
//       name: 'Sunrise Complex Satisfaction Survey',
//       propertyId: 'BGR/W13/3391',
//       municipality: 'SARJEET SAHU',
//       integratedPid: '',
//       integratedOwner: 'N/A',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '368, Anya Nagar 2, Hardyal School, 124507',
//       mobile: '',
//       category: 'Residential',
//       totalArea: '100.61',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Survey(
//       id: 'SRV004',
//       name: 'Royal Residency Market Research',
//       propertyId: 'BGR/W13/3400',
//       municipality: 'MANJU W/O SANDHY KUMAR',
//       integratedPid: '',
//       integratedOwner: 'Dev Singh Rawat',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '383, Anya Nagar 2, 124507',
//       mobile: '9729800252',
//       category: 'Residential',
//       totalArea: '52.48',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Survey(
//       id: 'SRV005',
//       name: 'Ocean View Property Analysis',
//       propertyId: 'BGR/W14/3450',
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
//     Survey(
//       id: 'SRV006',
//       name: 'Downtown Plaza Survey',
//       propertyId: 'BGR/W15/3500',
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
//     Survey(
//       id: 'SRV007',
//       name: 'Hill Station Residential Survey',
//       propertyId: 'BGR/W16/3550',
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
//     Survey(
//       id: 'SRV008',
//       name: 'Metro Heights Customer Survey',
//       propertyId: 'BGR/W17/3600',
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
//     Survey(
//       id: 'SRV009',
//       name: 'Park Avenue Commercial Survey',
//       propertyId: 'BGR/W18/3650',
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
//     Survey(
//       id: 'SRV010',
//       name: 'Riverside Apartments Analysis',
//       propertyId: 'BGR/W19/3700',
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
//     Survey(
//       id: 'SRV011',
//       name: 'Tech Park Office Survey',
//       propertyId: 'BGR/W20/3750',
//       municipality: 'MURATI',
//       integratedPid: '',
//       integratedOwner: 'Amit Sharma',
//       areaOfAuthority: '',
//       colony: 'Aggarwal Colony',
//       address: 'Plot 101, Aggarwal Colony, Bahadurgarh',
//       mobile: '9876543211',
//       category: 'Commercial',
//       totalArea: '350.00',
//       unit: 'SqYard',
//       authorizationStatus: 'Approved',
//     ),
//     Survey(
//       id: 'SRV012',
//       name: 'Lakeside Villas Customer Feedback',
//       propertyId: 'BGR/W21/3800',
//       municipality: 'SARJEET SAHU',
//       integratedPid: '',
//       integratedOwner: 'Priya Singh',
//       areaOfAuthority: '',
//       colony: 'Anya Nagar 2',
//       address: '600, Anya Nagar 2, Bahadurgarh',
//       mobile: '9876543212',
//       category: 'Residential',
//       totalArea: '180.50',
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

//   List<Survey> get _filteredData {
//     if (_searchQuery.isEmpty) {
//       return _allSurveyData;
//     }
//     return _allSurveyData.where((survey) {
//       final id = survey.id.toLowerCase();
//       final name = survey.name.toLowerCase();
//       final propertyId = survey.propertyId.toLowerCase();
//       final mobile = survey.mobile.toLowerCase();
//       final category = survey.category.toLowerCase();
//       final colony = survey.colony.toLowerCase();
//       final query = _searchQuery.toLowerCase();

//       return id.contains(query) ||
//           name.contains(query) ||
//           propertyId.contains(query) ||
//           mobile.contains(query) ||
//           category.contains(query) ||
//           colony.contains(query);
//     }).toList();
//   }

//   List<Survey> get _paginatedData {
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
//         _hasMore = (_itemsPerPage < _allSurveyData.length);
//       }
//     });
//   }

//   Future<void> _navigateToAddSurvey() async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const SurveyFormScreen(isEditMode: false),
//       ),
//     );

//     if (result != null && result is Survey) {
//       setState(() {
//         _allSurveyData.insert(0, result);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Survey "${result.name}" created successfully'),
//           backgroundColor: Colors.green.shade600,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _navigateToEditSurvey(Survey survey) async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => SurveyFormScreen(
//           survey: survey,
//           isEditMode: true,
//         ),
//       ),
//     );

//     if (result != null && result is Survey) {
//       setState(() {
//         final index = _allSurveyData.indexWhere((s) => s.id == result.id);
//         if (index != -1) {
//           _allSurveyData[index] = result;
//         }
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Survey "${result.name}" updated successfully'),
//           backgroundColor: Colors.blue.shade600,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   void _showDeleteDialog(BuildContext context, Survey survey) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Text(
//           'Delete Survey',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         content: Text(
//           'Are you sure you want to delete survey "${survey.name}"?',
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
//                 _allSurveyData.removeWhere((s) => s.id == survey.id);
//               });

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Survey "${survey.name}" deleted successfully'),
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
//                   hintText: 'Search by ID, Name, Property ID or Mobile...',
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
//                           child: Text('No surveys found'),
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
//                                       // All columns
//                                       SizedBox(
//                                         width: 120,
//                                         child: Text(
//                                           'Municipality  Name',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: const Color(0xFF2D3748),
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
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
//                                 ...paginatedData.map((survey) {
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
//                                             survey.municipality,
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
//                                             survey.id,
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
//                                             survey.name,
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
//                                             survey.propertyId,
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
//                                             survey.mobile,
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
//                                             survey.address.length > 20
//                                                 ? '${survey.address.substring(0, 20)}...'
//                                                 : survey.address,
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
//                                             survey.category,
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
//                                             survey.totalArea,
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
//                                             survey.unit,
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
//                                               color:
//                                                   survey.authorizationStatus ==
//                                                           'Approved'
//                                                       ? Colors.green.shade50
//                                                       : Colors.red.shade50,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                             ),
//                                             child: Text(
//                                               survey.authorizationStatus,
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.w600,
//                                                 color:
//                                                     survey.authorizationStatus ==
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
//                                                       _navigateToEditSurvey(
//                                                           survey),
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
//                                                         context, survey);
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
//                                         'No more surveys to load',
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
//             onTap: _navigateToAddSurvey,
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
//                     'Add New Survey',
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

// lib/features/survey_distribution/screens/survey_distributor_screen.dart

import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/customer_repository.dart';
import 'package:data_care_app/features/model/survey_model/survey_model.dart';
import 'package:data_care_app/features/survey_data/screens/new_survey/survey_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyListScreen extends StatefulWidget {
  final String? projectId;
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
      return survey.displayId.toLowerCase().contains(query) ||
          survey.name.toLowerCase().contains(query) ||
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
        builder: (context) => const SurveyFormScreen(isEditMode: false),
      ),
    );

    if (result != null && result is Survey) {
      setState(() {
        _allSurveys.insert(0, result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Survey "${result.displayId}" created successfully'),
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
        final index = _allSurveys.indexWhere((s) => s.id == result.id);
        if (index != -1) {
          _allSurveys[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Survey "${result.displayId}" updated successfully'),
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
          'Are you sure you want to delete survey "${survey.displayId}"?',
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
                _allSurveys.removeWhere((s) => s.id == survey.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Survey "${survey.displayId}" deleted successfully'),
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
                                            width: 80,
                                            child: Text(
                                              'Survey ID',
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
                                    ...paginatedSurveys.map((survey) {
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
                                              width: 80,
                                              child: Text(
                                                survey.displayId,
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
                                                survey.name,
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
                                                survey.municipalityName ?? '-',
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
                                                overflow: TextOverflow.ellipsis,
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
                                                overflow: TextOverflow.ellipsis,
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
                                                overflow: TextOverflow.ellipsis,
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
                                                overflow: TextOverflow.ellipsis,
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
                                                overflow: TextOverflow.ellipsis,
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
                                                  color: survey.isActive
                                                      ? Colors.green.shade50
                                                      : Colors.red.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  survey.isActive
                                                      ? 'Active'
                                                      : 'Inactive',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: survey.isActive
                                                        ? Colors.green.shade800
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
                                                          BorderRadius.circular(
                                                              6),
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
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _showDeleteDialog(
                                                            context, survey);
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
