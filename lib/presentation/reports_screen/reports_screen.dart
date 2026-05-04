import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/reports_data_table_widget.dart';
import './widgets/reports_date_range_widget.dart';
import './widgets/reports_gst_summary_widget.dart';
import './widgets/reports_kpi_strip_widget.dart';
import './widgets/reports_pl_chart_widget.dart';
import './widgets/reports_type_selector_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // TODO: Replace with Riverpod/Bloc for production state management
  String _selectedReport = 'P&L Statement';
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime(2026, 4, 1),
    end: DateTime(2026, 4, 30),
  );

  final List<String> _reportTypes = [
    'P&L Statement',
    'Balance Sheet',
    'Daily Report',
    'Sales Register',
    'Purchase Register',
    'GST Reports',
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return MainShell(
      currentIndex: 4,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: isTablet
                    ? _buildTabletLayout(context)
                    : _buildPhoneLayout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Reports',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _exportReport(context),
            icon: const Icon(
              Icons.download_outlined,
              color: AppTheme.onSurface,
            ),
            tooltip: 'Export PDF',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: AppTheme.onSurface),
            tooltip: 'Share Report',
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          ReportsTypeSelectorWidget(
            reportTypes: _reportTypes,
            selectedReport: _selectedReport,
            onReportSelected: (r) => setState(() => _selectedReport = r),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ReportsDateRangeWidget(
              selectedRange: _selectedRange,
              onRangeChanged: (r) => setState(() => _selectedRange = r),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ReportsKpiStripWidget(reportType: _selectedReport),
          ),
          const SizedBox(height: 12),
          _buildReportContent(context, false),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ReportsTypeSelectorWidget(
                  reportTypes: _reportTypes,
                  selectedReport: _selectedReport,
                  onReportSelected: (r) => setState(() => _selectedReport = r),
                  isVertical: true,
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ReportsDateRangeWidget(
                  selectedRange: _selectedRange,
                  onRangeChanged: (r) => setState(() => _selectedRange = r),
                ),
                const SizedBox(height: 12),
                ReportsKpiStripWidget(reportType: _selectedReport),
                const SizedBox(height: 12),
                _buildReportContent(context, true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent(BuildContext context, bool isTablet) {
    switch (_selectedReport) {
      case 'P&L Statement':
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
              child: const ReportsPLChartWidget(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
              child: ReportsDataTableWidget(reportType: _selectedReport),
            ),
          ],
        );
      case 'GST Reports':
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
          child: const ReportsGstSummaryWidget(),
        );
      case 'Balance Sheet':
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
          child: ReportsDataTableWidget(reportType: _selectedReport),
        );
      default:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
          child: ReportsDataTableWidget(reportType: _selectedReport),
        );
    }
  }

  void _exportReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_selectedReport exported as PDF',
          style: GoogleFonts.ibmPlexSans(),
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
