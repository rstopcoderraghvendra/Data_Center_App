// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
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
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blue.withOpacity(0.15),
//                 blurRadius: 30,
//                 spreadRadius: 3,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//             border: Border.all(
//               color: Colors.blue.shade100,
//               width: 1,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: GNav(
//               // Floating Style
//               backgroundColor: Colors.transparent,
//               color: Colors.grey.shade600,
//               activeColor: Colors.blue.shade700,
//               tabBackgroundColor: Colors.blue.shade50,
//               tabBorderRadius: 20,
//               tabMargin: const EdgeInsets.symmetric(vertical: 4),
//               tabBorder: Border.all(
//                 color: Colors.blue.shade200,
//                 width: 1,
//               ),

//               // Animation
//               gap: 4,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,

//               // Icons
//               iconSize: 24,
//               textStyle: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.blue.shade700,
//                 letterSpacing: 0.3,
//               ),

//               // Tabs
//               tabs: [
//                 GButton(
//                   icon: currentIndex == 0
//                       ? Icons.receipt_long_rounded
//                       : Icons.receipt_long_outlined,
//                   text: AppStrings.billDistribution,
//                   iconSize: currentIndex == 0 ? 26 : 24,
//                 ),
//                 GButton(
//                   icon: currentIndex == 1
//                       ? Icons.assessment_rounded
//                       : Icons.assessment_outlined,
//                   text: AppStrings.surveyData,
//                   iconSize: currentIndex == 1 ? 26 : 24,
//                 ),
//               ],

//               selectedIndex: currentIndex,
//               onTabChange: (index) {
//                 HapticFeedback.lightImpact();
//                 onChanged(index);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 3,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.blue.shade100,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: GNav(
              // Floating Style
              backgroundColor: Colors.transparent,
              color: Colors.grey.shade600,
              activeColor: Colors.blue.shade700,
              tabBackgroundColor: Colors.blue.shade50,
              tabBorderRadius: 20,
              tabMargin: const EdgeInsets.symmetric(vertical: 4),
              tabBorder: Border.all(
                color: Colors.blue.shade200,
                width: 1,
              ),

              // Animation
              gap: 4,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,

              // Icons
              iconSize: 24,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins', // BEST CHOICE for modern apps
                letterSpacing: 0.2,
              ),

              // Tabs - BEST ICON CHOICES
              tabs: [
                GButton(
                  // BEST: Pie chart shows distribution visually
                  icon: currentIndex == 0
                      ? Icons.pie_chart_rounded
                      : Icons.pie_chart_outline_rounded,
                  text: AppStrings.billDistribution,
                  iconSize: currentIndex == 0 ? 26 : 24,
                ),
                GButton(
                  // BEST: Bar chart represents survey data analysis
                  icon: currentIndex == 1
                      ? Icons.bar_chart_rounded
                      : Icons.bar_chart_outlined,
                  text: AppStrings.surveyData,
                  iconSize: currentIndex == 1 ? 26 : 24,
                ),
              ],

              selectedIndex: currentIndex,
              onTabChange: (index) {
                HapticFeedback.lightImpact();
                onChanged(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
