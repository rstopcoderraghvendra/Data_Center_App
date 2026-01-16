import 'package:flutter/material.dart';
import '../../../app/routes/route_names.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../home/widgets/data_table.dart';

class BillListScreen extends StatelessWidget {
  const BillListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final repository = CustomerRepository(ApiClient(storage: LocalStorage()));

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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: repository.fetchCustomers(
                sourceType: 'bill_distribution',
              ),
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
                  return const Center(child: Text('No records found'));
                }
                return RecordsTable(
                  rows: rows,
                  onEdit: (row) => Navigator.of(context).pushNamed(
                    RouteNames.billEdit,
                    arguments: {'id': row['id']},
                  ),
                  onDelete: (row) {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
