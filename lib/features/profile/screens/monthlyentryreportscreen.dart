import 'package:data_care_app/core/network/api_client.dart';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/models/projects_model.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/projects_repository copy.dart';
import '../../model/authbilldetailsresponse.dart';

class BillDistributionDetailsScreen extends StatefulWidget {
  const BillDistributionDetailsScreen({super.key});

  @override
  State<BillDistributionDetailsScreen> createState() =>
      _BillDistributionDetailsScreenState();
}

class _BillDistributionDetailsScreenState
    extends State<BillDistributionDetailsScreen> {
  late final ProjectRepository _projectRepository;

  bool _loadingProjects = true;
  bool _loadingDetails = false;

  String? _errorMessage;

  List<Project> _projects = [];
  Project? _selectedProject;

  AuthBillDetailsResponse? _billDetails;

  String _selectedDateFilter = 'this_month';

  DateTime? _fromDate;
  DateTime? _toDate;

  final List<_DateFilterItem> _dateFilters = const [
    _DateFilterItem(label: 'Today', value: 'today'),
    _DateFilterItem(label: 'Last Day', value: 'last_day'),
    _DateFilterItem(label: 'This Week', value: 'this_week'),
    _DateFilterItem(label: 'Last Week', value: 'last_week'),
    _DateFilterItem(label: 'This Month', value: 'this_month'),
    _DateFilterItem(label: 'Last Month', value: 'last_month'),
    _DateFilterItem(label: 'This Year', value: 'this_year'),
    _DateFilterItem(label: 'Last Year', value: 'last_year'),
    _DateFilterItem(label: 'Custom Date', value: 'custom'),
  ];

  @override
  void initState() {
    super.initState();
    _projectRepository = ProjectRepository(
      ApiClient(storage: LocalStorage()),
    );
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _loadingProjects = true;
      _errorMessage = null;
    });

    try {
      final projects = await _projectRepository.getProjects();

      if (!mounted) return;

      setState(() {
        _projects = projects;

        _selectedProject = null;

        _loadingProjects = false;
      });

      await _loadBillDetails();

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingProjects = false;
        _errorMessage = _cleanError(e);
      });
    }
  }

  Future<void> _loadBillDetails() async {
    if (_selectedDateFilter == 'custom') {
      if (_fromDate == null || _toDate == null) {
        _showMessage('Please select from date and to date');
        return;
      }
    }

    setState(() {
      _loadingDetails = true;
      _errorMessage = null;
    });

    try {
      final response = await _projectRepository.getAuthBillDetails(
        projectId: _selectedProject?.id,

        dateFilter: _selectedDateFilter,
        fromDate: _selectedDateFilter == 'custom'
            ? _formatApiDate(_fromDate!)
            : null,
        toDate: _selectedDateFilter == 'custom'
            ? _formatApiDate(_toDate!)
            : null,
      );

      if (!mounted) return;

      setState(() {
        _billDetails = response;
        _loadingDetails = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingDetails = false;
        _errorMessage = _cleanError(e);
      });

      _showMessage(_cleanError(e), isError: true);
    }
  }

  Future<void> _pickDate({required bool isFromDate}) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      isFromDate ? (_fromDate ?? now) : (_toDate ?? _fromDate ?? now),
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF667eea),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isFromDate) {
        _fromDate = picked;

        if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
          _toDate = picked;
        }
      } else {
        _toDate = picked;
      }
    });
  }

  String _projectName(Project project) {
    return project.name.toString().trim().isEmpty
        ? 'Project ${project.id}'
        : project.name.toString();
  }

  String _formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _formatDisplayDate(String date) {
    if (date.trim().isEmpty) return '-';

    final parsed = DateTime.tryParse(date);

    if (parsed == null) return date;

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
  }

  String _cleanError(dynamic error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('Failed to fetch bill details: ', '')
        .trim();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? const Color(0xFFE53E3E) : const Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _openImagePreview({
    required String title,
    required String url,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  color: const Color(0xFF667eea),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const SizedBox(
                      height: 220,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF667eea),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) {
                    return const SizedBox(
                      height: 190,
                      child: Center(
                        child: Text('Failed to load image'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = _billDetails;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: _loadingProjects
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF667eea),
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 185,
            backgroundColor: const Color(0xFF667eea),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Bill Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _loadingDetails ? null : _loadBillDetails,
                icon: _loadingDetails
                    ? const SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.refresh_rounded, size: 21),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(14, 82, 14, 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distribution Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedProject == null
                          ? 'All Projects'
                          : _projectName(_selectedProject!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        _headerStatCard(
                          title: 'Filtered',
                          value: details?.summary.filteredDistribution
                              .toString() ??
                              '0',
                          icon: Icons.filter_alt_rounded,
                        ),
                        const SizedBox(width: 8),
                        _headerStatCard(
                          title: 'This Month',
                          value: details?.summary.thisMonthDistribution
                              .toString() ??
                              '0',
                          icon: Icons.calendar_month_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompactFilterSection(),

                  if (_selectedDateFilter == 'custom')
                    _buildCustomDateSection(),

                  if (_selectedDateFilter == 'custom')


                  if (_errorMessage != null)
                    _buildErrorCard(_errorMessage!),

                  if (details != null) ...[
                    _buildSummaryGrid(details.summary),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.list_alt_rounded,
                          size: 18,
                          color: Color(0xFF667eea),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Day-wise Distribution',
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                            const Color(0xFF667eea).withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${details.dayWiseDistribution.length} Days',
                            style: const TextStyle(
                              color: Color(0xFF667eea),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),

          if (_loadingDetails)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF667eea),
                ),
              ),
            )
          else if (details == null ||
              details.dayWiseDistribution.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _emptyView(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
              sliver: SliverList.separated(
                itemCount: details.dayWiseDistribution.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = details.dayWiseDistribution[index];
                  return _dayDistributionCard(item);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _headerStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactFilterSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              _smallIconBox(Icons.business_center_rounded),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Project & Filter',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_loadingDetails)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF667eea),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                flex: 6,
                child:
                DropdownButtonFormField<Project?>(
                  value: _selectedProject,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    prefixIcon: Icons.work_outline_rounded,
                    hintText: 'Project',
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                  ),
                  items: [
                    const DropdownMenuItem<Project?>(
                      value: null,
                      child: Text(
                        'All Projects',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),

                    ..._projects.map((project) {
                      return DropdownMenuItem<Project?>(
                        value: project,
                        child: Text(
                          _projectName(project),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (project) async {
                    setState(() {
                      // null means All Projects
                      _selectedProject = project;
                      _billDetails = null;
                    });

                    await _loadBillDetails();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: DropdownButtonFormField<String>(
                  value: _selectedDateFilter,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    prefixIcon: Icons.calendar_today_rounded,
                    hintText: 'Filter',
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  items: _dateFilters.map((filter) {
                    return DropdownMenuItem<String>(
                      value: filter.value,
                      child: Text(
                        filter.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value == null) return;

                    setState(() {
                      _selectedDateFilter = value;

                      if (value != 'custom') {
                        _fromDate = null;
                        _toDate = null;
                      }
                    });

                    if (value != 'custom') {
                      await _loadBillDetails();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDateSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dateButton(
                  label: 'From',
                  value: _fromDate == null ? 'Select' : _formatApiDate(_fromDate!),
                  onTap: () => _pickDate(isFromDate: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dateButton(
                  label: 'To',
                  value: _toDate == null ? 'Select' : _formatApiDate(_toDate!),
                  onTap: () => _pickDate(isFromDate: false),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 42,
                width: 48,
                child: ElevatedButton(
                  onPressed: _loadingDetails ? null : _loadBillDetails,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Icon(Icons.search_rounded, size: 19),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid(AuthBillSummary summary) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.35,
      children: [
        _summaryCard(
          title: 'Total',
          value: summary.totalDistribution.toString(),
          icon: Icons.all_inbox_rounded,
          color: const Color(0xFF667eea),
        ),
        _summaryCard(
          title: 'Today',
          value: summary.todayDistribution.toString(),
          icon: Icons.today_rounded,
          color: const Color(0xFF48BB78),
        ),
        _summaryCard(
          title: 'Month',
          value: summary.thisMonthDistribution.toString(),
          icon: Icons.calendar_month_rounded,
          color: const Color(0xFFED8936),
        ),
        _summaryCard(
          title: 'Filtered',
          value: summary.filteredDistribution.toString(),
          icon: Icons.filter_alt_rounded,
          color: const Color(0xFF764ba2),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: _cardDecoration(radius: 15, shadow: false),
      child: Row(
        children: [
          Container(
            height: 33,
            width: 33,
            decoration: BoxDecoration(
              color: color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayDistributionCard(DayWiseDistribution item) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDisplayDate(item.date),
                      style: const TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Bill distribution count',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  item.count.toString(),
                  style: const TextStyle(
                    color: Color(0xFF667eea),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _imageChip({
    required String title,
    required String? url,
    required IconData icon,
  }) {
    final hasUrl = url != null && url.trim().isNotEmpty;

    return Expanded(
      child: InkWell(
        onTap: hasUrl
            ? () {
          _openImagePreview(
            title: title,
            url: url,
          );
        }
            : null,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: hasUrl
                ? const Color(0xFF667eea).withOpacity(0.10)
                : const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: hasUrl
                  ? const Color(0xFF667eea).withOpacity(0.18)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: hasUrl
                    ? const Color(0xFF667eea)
                    : const Color(0xFFCBD5E0),
                size: 15,
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: TextStyle(
                  color: hasUrl
                      ? const Color(0xFF667eea)
                      : const Color(0xFF9AA5B1),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateButton({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF718096),
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallIconBox(IconData icon) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  InputDecoration _dropdownDecoration({
    required IconData prefixIcon,
    required String hintText,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      prefixIcon: Icon(
        prefixIcon,
        size: 16,
        color: const Color(0xFF667eea),
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 34,
        minHeight: 34,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 9,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFF667eea),
          width: 1.2,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration({
    double radius = 16,
    bool shadow = true,
  }) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: shadow
          ? [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ]
          : null,
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7D7)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFE53E3E),
            size: 19,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_rounded,
                color: Color(0xFF667eea),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No distribution data found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please select project and date filter to view data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF718096),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateFilterItem {
  final String label;
  final String value;

  const _DateFilterItem({
    required this.label,
    required this.value,
  });
}