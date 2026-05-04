import 'package:flutter/material.dart';

import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/invoice_screen/invoice_screen.dart';
import '../presentation/reports_screen/reports_screen.dart';
import '../presentation/parties_screen/parties_screen.dart';
import '../presentation/items_screen/items_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String dashboardScreen = '/dashboard-screen';
  static const String invoiceScreen = '/invoice-screen';
  static const String reportsScreen = '/reports-screen';
  static const String partiesScreen = '/parties-screen';
  static const String itemsScreen = '/items-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    invoiceScreen: (context) => const InvoiceScreen(),
    reportsScreen: (context) => const ReportsScreen(),
    partiesScreen: (context) => const PartiesScreen(),
    itemsScreen: (context) => const ItemsScreen(),
  };
}
