import 'package:flutter/material.dart';

import 'utils/app_theme.dart';

import 'screens/intro_page.dart';

// Admin pages
import 'screens/dashboard_page.dart';
import 'screens/rooms_page.dart';
import 'screens/hotel_setup_page.dart';
import 'screens/room_status_page.dart';
import 'screens/service_requests_page.dart';
import 'screens/billing_page.dart';
import 'screens/staff_management_page.dart';
import 'screens/super_admin_page.dart';

// Guest pages
import 'screens/guest_dashboard_page.dart';
import 'screens/guest_bill_page.dart';
import 'screens/in_room_guest_screen.dart';

void main() {
  runApp(const StayOpsApp());
}

class StayOpsApp extends StatelessWidget {
  const StayOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayOps',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: Uri.base.path.isEmpty ? '/' : Uri.base.path,

      routes: {
        '/': (context) => const IntroPage(),

        '/dashboard': (context) => const DashboardPage(),

        '/rooms': (context) => const RoomsPage(),

        '/room-status': (context) => const RoomStatusPage(),

        '/service-requests': (context) => const ServiceRequestsPage(),

        '/staff': (context) => const StaffManagementPage(),

        '/billing': (context) => const BillingPage(),

        '/hotel-setup': (context) => const HotelSetupPage(),

        '/super-admin': (context) => const SuperAdminPage(),

        '/guest-dashboard': (context) => const GuestDashboardPage(),

        '/guest-bill': (context) => const GuestBillPage(),

        '/room-screen': (context) =>
            const InRoomGuestScreen(roomNumber: '204', guestName: 'Guest'),
      },
    );
  }
}
