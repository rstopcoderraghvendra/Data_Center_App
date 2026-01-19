import 'package:flutter/material.dart';
import '../../../app/routes/route_names.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String companyName;
  final bool? showSearch;
  final VoidCallback onSearchToggle;
  final VoidCallback? onLogout;

  const HomeAppBar({
    super.key,
    required this.companyName,
    this.showSearch,
    required this.onSearchToggle,
    this.onLogout,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + ((showSearch ?? false) ? 64 : 0),
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSearchVisible = showSearch ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade600,
            Colors.blue.shade500,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleSpacing: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteNames.profile);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            companyName,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSearchVisible
                  ? Colors.red.shade400.withOpacity(0.2)
                  : Colors.white.withOpacity(0.2),
              border: Border.all(
                color: isSearchVisible
                    ? Colors.red.shade300.withOpacity(0.5)
                    : Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: onSearchToggle,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isSearchVisible
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    color: isSearchVisible ? Colors.red.shade50 : Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          if (onLogout != null)
            Container(
              margin:
                  const EdgeInsets.only(left: 8, right: 12, top: 6, bottom: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade400.withOpacity(0.2),
                border: Border.all(
                  color: Colors.red.shade300.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: onLogout,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.red.shade50,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
        ],
        // ✅ SEARCH PART - EXACTLY SAME AS BEFORE (NO CHANGES)
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(isSearchVisible ? 64 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: isSearchVisible ? 56 : 0,
            padding: isSearchVisible
                ? const EdgeInsets.fromLTRB(16, 0, 16, 12)
                : EdgeInsets.zero,
            child: isSearchVisible
                ? Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.7),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.search,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search records, IDs, names...',
                              hintStyle: TextStyle(
                                color: colorScheme.outline,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
