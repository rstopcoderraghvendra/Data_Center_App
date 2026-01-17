// // import 'package:flutter/material.dart';
// // import '../../../core/constants/app_strings.dart';

// // class BottomTabs extends StatelessWidget {
// //   final int currentIndex;
// //   final ValueChanged<int> onChanged;

// //   const BottomTabs({
// //     super.key,
// //     required this.currentIndex,
// //     required this.onChanged,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return BottomNavigationBar(
// //       currentIndex: currentIndex,
// //       onTap: onChanged,
// //       items: const [
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.receipt_long),
// //           label: AppStrings.billDistribution,
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.assignment),
// //           label: AppStrings.surveyData,
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import '../../../core/constants/app_strings.dart';

// class BottomTabs extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onChanged;

//   const BottomTabs({
//     super.key,
//     required this.currentIndex,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return BottomAppBar(
//       height: 70 + MediaQuery.of(context).padding.bottom,
//       padding: EdgeInsets.zero,
//       color:
//           isDark ? theme.colorScheme.surface.withOpacity(0.95) : Colors.white,
//       surfaceTintColor: theme.colorScheme.surfaceTint,
//       elevation: 8,
//       shadowColor: Colors.black.withOpacity(0.15),
//       shape: const CircularNotchedRectangle(),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: theme.dividerColor.withOpacity(0.1),
//               width: 1,
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildElegantTabItem(
//               context: context,
//               index: 0,
//               icon: Icons.receipt_long_outlined,
//               activeIcon: Icons.receipt_long,
//               label: AppStrings.billDistribution,
//             ),
//             _buildElegantTabItem(
//               context: context,
//               index: 1,
//               icon: Icons.assessment_outlined,
//               activeIcon: Icons.assessment,
//               label: AppStrings.surveyData,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildElegantTabItem({
//     required BuildContext context,
//     required int index,
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//   }) {
//     final theme = Theme.of(context);
//     final isActive = currentIndex == index;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => onChanged(index),
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             color: isActive
//                 ? theme.colorScheme.primary.withOpacity(0.08)
//                 : Colors.transparent,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 isActive ? activeIcon : icon,
//                 color: isActive
//                     ? theme.colorScheme.primary
//                     : theme.colorScheme.onSurface.withOpacity(0.5),
//                 size: isActive ? 26 : 24,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
//                   color: isActive
//                       ? theme.colorScheme.primary
//                       : theme.colorScheme.onSurface.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
    return Container(
      height: 75 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.blue.shade100,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Blue Indicator Line
          Container(
            height: 3,
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: currentIndex == 0
                              ? Colors.blue.shade600
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: currentIndex == 1
                              ? Colors.blue.shade600
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          Expanded(
            child: Row(
              children: [
                _buildSimpleBlueTabItem(
                  index: 0,
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long,
                  label: AppStrings.billDistribution,
                ),
                _buildSimpleBlueTabItem(
                  index: 1,
                  icon: Icons.assessment_outlined,
                  activeIcon: Icons.assessment,
                  label: AppStrings.surveyData,
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSimpleBlueTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.blue.shade50 : Colors.transparent,
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
