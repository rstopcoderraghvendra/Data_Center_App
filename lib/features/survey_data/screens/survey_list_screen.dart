import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/route_names.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../home/widgets/data_table.dart';
import '../../../core/constants/app_strings.dart';

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({super.key});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  late final CustomerRepository _repository;
  late Future<List<Map<String, dynamic>>> _future;
  final _scrollController = ScrollController();
  bool _refreshingBottom = false;

  @override
  void initState() {
    super.initState();
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _future = _repository.fetchCustomers(sourceType: 'survey');
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      _refreshFromBottom();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _repository.fetchCustomers(sourceType: 'survey');
    });
    await _future;
  }

  Future<void> _refreshFromBottom() async {
    if (_refreshingBottom) {
      return;
    }
    setState(() => _refreshingBottom = true);
    try {
      await _refresh();
    } finally {
      if (mounted) {
        setState(() => _refreshingBottom = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              // Header Card - New UI Structure
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
                          Text('Survey Data',
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w700)),
                          Text(
                            'View and update survey records',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area - New UI Structure
              Expanded(
                child: Container(
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
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          final data = snapshot.data ?? [];
                          final rows = data.map((item) {
                            final status =
                                item['authorization_status']?.toString() ??
                                    (item['is_active'] == true
                                        ? 'Active'
                                        : 'Inactive');
                            return {
                              'id': item['id']?.toString() ?? '-',
                              'name': item['name']?.toString() ?? '-',
                              'status': status,
                            };
                          }).toList();
                          if (rows.isEmpty) {
                            return ListView(
                              controller: _scrollController,
                              children: const [
                                SizedBox(height: 120),
                                Center(child: Text('No records found')),
                              ],
                            );
                          }
                          return ListView(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            children: [
                              // Custom Table with updated UI
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    // Table Header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'ID',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Name',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Status',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Actions',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Table Rows
                                    ...rows.map((row) {
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
                                                row['id'] ?? '-',
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                row['name'] ?? '-',
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: 11,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: row['status'] ==
                                                          'Active'
                                                      ? Colors.green.shade50
                                                      : Colors.orange.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: row['status'] ==
                                                            'Active'
                                                        ? Colors.green.shade200
                                                        : Colors
                                                            .orange.shade200,
                                                  ),
                                                ),
                                                child: Text(
                                                  row['status'] ?? '-',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: row['status'] ==
                                                            'Active'
                                                        ? Colors.green.shade700
                                                        : Colors
                                                            .orange.shade700,
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // Updated Edit Button
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
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                        RouteNames.surveyEdit,
                                                        arguments: {
                                                          'id': row['id']
                                                        },
                                                      ),
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
                                                  // Updated Delete Button
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
                                                      onPressed: () {},
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
                                  ],
                                ),
                              ),
                              // if (_refreshingBottom)
                              //   const Padding(
                              //     padding: EdgeInsets.symmetric(vertical: 12),
                              //     child: Center(
                              //       child: CircularProgressIndicator(
                              //           strokeWidth: 2),
                              //     ),
                              //   ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Updated FAB Button
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
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
                  onTap: () async {
                    await Navigator.of(context).pushNamed(RouteNames.surveyAdd);
                    if (mounted) {
                      _refresh();
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.addNew,
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
          ),
        ],
      ),
    );
  }
}
