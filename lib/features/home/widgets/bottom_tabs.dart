import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class BottomTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const BottomTabs({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onChanged,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: AppStrings.billDistribution,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: AppStrings.surveyData,
        ),
      ],
    );
  }
}
