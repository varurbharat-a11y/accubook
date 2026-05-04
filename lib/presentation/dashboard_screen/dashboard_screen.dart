import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/dashboard_chart_widget.dart';
import './widgets/dashboard_kpi_grid_widget.dart';
import './widgets/dashboard_overdue_banner_widget.dart';
import './widgets/dashboard_quick_actions_widget.dart';
import './widgets/dashboard_recent_invoices_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // TODO: Replace with Riverpod/Bloc for production state management
  bool _isLoading = false;
  String _selectedPeriod = 'Today';
  final List<String> _periods = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  final Map<String, dynamic> _kpiData = {
    'todaySales': 48750.0,
    'receivables': 182400.0,
    'payables': 64200.0,
    'gstPayable': 22680.0,
    'netPL': 31250.0,
    'activeParties': 47,
    'overdueCount': 3,
    'overdueAmount': 38500.0,
  };

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return MainShell(
      currentIndex: 0,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: isTablet
                    ? _buildTabletLayout(context)
                    : _buildPhoneLayout(context),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppTheme.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'AccuBook',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
      actions: [
        _buildPeriodSelector(),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.onSurface,
          ),
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return PopupMenuButton<String>(
      initialValue: _selectedPeriod,
      onSelected: (value) => setState(() => _selectedPeriod = value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedPeriod,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => _periods
          .map(
            (p) => PopupMenuItem(
              value: p,
              child: Text(p, style: GoogleFonts.ibmPlexSans(fontSize: 13)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildGreetingStrip(context),
        const SizedBox(height: 12),
        if (_kpiData['overdueCount'] > 0)
          DashboardOverdueBannerWidget(
            overdueCount: _kpiData['overdueCount'],
            overdueAmount: _kpiData['overdueAmount'],
          ),
        const SizedBox(height: 4),
        DashboardKpiGridWidget(kpiData: _kpiData, isTablet: false),
        const SizedBox(height: 16),
        DashboardChartWidget(period: _selectedPeriod),
        const SizedBox(height: 16),
        DashboardRecentInvoicesWidget(isTablet: false),
        const SizedBox(height: 16),
        DashboardQuickActionsWidget(),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGreetingStrip(context),
          const SizedBox(height: 12),
          if (_kpiData['overdueCount'] > 0)
            DashboardOverdueBannerWidget(
              overdueCount: _kpiData['overdueCount'],
              overdueAmount: _kpiData['overdueAmount'],
            ),
          const SizedBox(height: 8),
          DashboardKpiGridWidget(kpiData: _kpiData, isTablet: true),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: DashboardChartWidget(period: _selectedPeriod),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: DashboardRecentInvoicesWidget(isTablet: true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DashboardQuickActionsWidget(),
        ],
      ),
    );
  }

  Widget _buildGreetingStrip(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  color: AppTheme.outline,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Financial Overview',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.successContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Books Updated',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
