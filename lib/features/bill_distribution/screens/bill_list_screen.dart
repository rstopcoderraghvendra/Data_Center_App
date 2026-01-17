import 'package:flutter/material.dart';
import '../../../app/routes/route_names.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../home/widgets/data_table.dart';

class BillListScreen extends StatefulWidget {
  const BillListScreen({super.key});

  @override
  State<BillListScreen> createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  late final CustomerRepository _repository;
  late Future<List<Map<String, dynamic>>> _future;
  final _scrollController = ScrollController();
  bool _refreshingBottom = false;

  @override
  void initState() {
    super.initState();
    _repository = CustomerRepository(ApiClient(storage: LocalStorage()));
    _future = _repository.fetchCustomers(sourceType: 'bill_distribution');
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
      _future = _repository.fetchCustomers(sourceType: 'bill_distribution');
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

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Bill Distribution',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Manage and update bill records',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          const SizedBox(height: 11),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  final data = snapshot.data ?? [];
                  final rows = data.map((item) {
                    final status = item['authorization_status']?.toString() ??
                        (item['is_active'] == true ? 'Active' : 'Inactive');
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
                      RecordsTable(
                        rows: rows,
                        onEdit: (row) => Navigator.of(context).pushNamed(
                          RouteNames.billEdit,
                          arguments: {'id': row['id']},
                        ),
                        onDelete: (row) {},
                      ),
                      if (_refreshingBottom)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
