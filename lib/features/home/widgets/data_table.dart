import 'dart:math' as math;

import 'package:flutter/material.dart';

class RecordsTable extends StatelessWidget {
  final List<Map<String, String>> rows;
  final ValueChanged<Map<String, String>> onEdit;
  final ValueChanged<Map<String, String>> onDelete;

  const RecordsTable({
    super.key,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
        side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const idWidth = 36.0;
            const actionsWidth = 78.0;
            const horizontalMargin = 8.0;
            const columnSpacing = 16.0;
            final fixedWidth = idWidth +
                actionsWidth +
                (horizontalMargin * 2) +
                (columnSpacing * 3);
            final available =
                math.max(constraints.maxWidth - fixedWidth, 140.0).toDouble();
            final nameWidth = math.max(100.0, available * 0.6).toDouble();
            final statusWidth =
                math.max(80.0, available - nameWidth).toDouble();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  border: TableBorder.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                    width: 0.6,
                  ),
                  headingRowColor: MaterialStateProperty.all(
                    colorScheme.surfaceVariant.withValues(alpha: 0.4),
                  ),
                  headingRowHeight: 36,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 44,
                  horizontalMargin: horizontalMargin,
                  columnSpacing: columnSpacing,
                  dividerThickness: 0.6,
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: idWidth,
                        child: Text(
                          'ID',
                          style: textTheme.labelSmall?.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: nameWidth,
                        child: Text(
                          'Name',
                          style: textTheme.labelSmall?.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: statusWidth,
                        child: Text(
                          'Status',
                          style: textTheme.labelSmall?.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: actionsWidth,
                        child: Text(
                          'Actions',
                          style: textTheme.labelSmall?.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                  rows: rows.map((row) {
                    final status = row['status'] ?? '';
                    final statusColor = _statusColor(status, colorScheme);
                    return DataRow(cells: [
                      DataCell(
                        SizedBox(
                          width: idWidth,
                          child: Text(
                            row['id'] ?? '',
                            style: textTheme.bodySmall?.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: nameWidth,
                          child: Text(
                            row['name'] ?? '',
                            style: textTheme.bodySmall?.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: statusWidth,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                status,
                                style: textTheme.labelMedium?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: actionsWidth,
                          child: Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: () => onEdit(row),
                                icon: const Icon(Icons.edit, size: 18),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton.filledTonal(
                                onPressed: () => onDelete(row),
                                icon:
                                    const Icon(Icons.delete_outline, size: 18),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                style: IconButton.styleFrom(
                                  foregroundColor: colorScheme.error,
                                  backgroundColor: colorScheme.errorContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color _statusColor(String status, ColorScheme colorScheme) {
  final value = status.toLowerCase();
  if (value.contains('done') || value.contains('active')) {
    return colorScheme.primary;
  }
  if (value.contains('pending')) {
    return colorScheme.tertiary;
  }
  if (value.contains('inactive') || value.contains('blocked')) {
    return colorScheme.error;
  }
  return colorScheme.secondary;
}
