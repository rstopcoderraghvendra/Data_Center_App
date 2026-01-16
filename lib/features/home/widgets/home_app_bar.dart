import 'package:flutter/material.dart';
import '../../../app/routes/route_names.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String companyName;
  final bool? showSearch;
  final VoidCallback onSearchToggle;

  const HomeAppBar({
    super.key,
    required this.companyName,
    this.showSearch,
    required this.onSearchToggle,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + ((showSearch ?? false) ? 64 : 0),
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSearchVisible = showSearch ?? false;
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 4, 99, 222),
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.profile);
        },
      ),
      title: Text(
        companyName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: Icon(isSearchVisible ? Icons.close : Icons.search),
          onPressed: onSearchToggle,
        ),
        const SizedBox(width: 4),
      ],
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
                      color: colorScheme.outlineVariant.withValues(alpha: 0.7),
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
    );
  }
}
