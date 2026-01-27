import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
          child: IntrinsicHeight(
            // Yeh line add karein
            child: Row(
              children: [
                // Bill Distribution Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onChanged(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 4),
                      decoration: BoxDecoration(
                        color: currentIndex == 0
                            ? Colors.blue.shade50
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        border: Border.all(
                          color: currentIndex == 0
                              ? Colors.blue.shade200
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            currentIndex == 0
                                ? Icons.pie_chart_rounded
                                : Icons.pie_chart_outline_rounded,
                            size: 22,
                            color: currentIndex == 0
                                ? Colors.blue.shade700
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              AppStrings.billDistribution,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: currentIndex == 0
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  color: Colors.blue.shade100,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),

                // Survey Data Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onChanged(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 4),
                      decoration: BoxDecoration(
                        color: currentIndex == 1
                            ? Colors.blue.shade50
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border.all(
                          color: currentIndex == 1
                              ? Colors.blue.shade200
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            currentIndex == 1
                                ? Icons.bar_chart_rounded
                                : Icons.bar_chart_outlined,
                            size: 22,
                            color: currentIndex == 1
                                ? Colors.blue.shade700
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              AppStrings.surveyData,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: currentIndex == 1
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
