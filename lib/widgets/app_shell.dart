import 'package:flutter/material.dart';

import '../models/service_request_store.dart';

enum AppSection {
  dashboard,
  rooms,
  roomStatus,
  serviceRequests,
  staff,
  billing,
  settings,

  // Internal page only.
  // It is intentionally NOT displayed in the sidebar.
  hotelSetup,
}

class AppShell extends StatelessWidget {
  final AppSection currentSection;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentSection,
    required this.child,
  });

  static const darkBg = Color(0xFF13241B);
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const sidebarBg = Color(0xFF0F1E17);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          if (isWide) _buildSidebar(context),

          Expanded(
            child: Container(color: darkBg, child: child),
          ),
        ],
      ),

      drawer: isWide
          ? null
          : Drawer(
              backgroundColor: sidebarBg,
              child: _buildSidebarContent(context),
            ),

      appBar: isWide
          ? null
          : AppBar(
              backgroundColor: darkBg2,
              elevation: 0,
              title: const Text(
                'StayOps',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 240,
      color: sidebarBg,
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: mintAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: mintAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'StayOps',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          _navItem(
            context,
            Icons.grid_view_rounded,
            'Dashboard',
            AppSection.dashboard,
          ),

          _navItem(context, Icons.bed_rounded, 'Rooms', AppSection.rooms),

          _navItem(
            context,
            Icons.bar_chart_rounded,
            'Room Status',
            AppSection.roomStatus,
          ),

          AnimatedBuilder(
            animation: ServiceRequestStore.instance,
            builder: (context, _) {
              final pendingCount = ServiceRequestStore.instance.pendingCount;

              return _navItem(
                context,
                Icons.room_service_outlined,
                'Service Requests',
                AppSection.serviceRequests,
                badgeCount: pendingCount,
              );
            },
          ),

          _navItem(context, Icons.groups_rounded, 'Staff', AppSection.staff),

          _navItem(
            context,
            Icons.receipt_long_outlined,
            'Billing',
            AppSection.billing,
          ),

          _navItem(
            context,
            Icons.settings_outlined,
            'Settings',
            AppSection.settings,
          ),

          const Spacer(),

          const Divider(color: Colors.white12, height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: mintAccent.withOpacity(0.2),
                  child: const Text(
                    'A',
                    style: TextStyle(
                      color: mintAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arsh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Hotel Admin',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white38,
                    size: 18,
                  ),
                  tooltip: 'Logout',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    AppSection section, {
    int badgeCount = 0,
  }) {
    final active = currentSection == section;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: active ? mintAccent.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _navigate(context, section),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: active ? mintAccent : Colors.white54,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white60,
                      fontSize: 13.5,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),

                if (badgeCount > 0)
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
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

  void _navigate(BuildContext context, AppSection section) {
    if (section == currentSection) {
      return;
    }

    Navigator.of(context).pushNamed(_routeFor(section));
  }

  String _routeFor(AppSection section) {
    switch (section) {
      case AppSection.dashboard:
        return '/dashboard';

      case AppSection.rooms:
        return '/rooms';

      case AppSection.roomStatus:
        return '/room-status';

      case AppSection.serviceRequests:
        return '/service-requests';

      case AppSection.staff:
        return '/staff';

      case AppSection.billing:
        return '/billing';

      case AppSection.settings:
        return '/settings';

      case AppSection.hotelSetup:
        return '/hotel-setup';
    }
  }
}
