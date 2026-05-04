import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ReportsPLChartWidget extends StatefulWidget {
  const ReportsPLChartWidget({super.key});

  @override
  State<ReportsPLChartWidget> createState() => _ReportsPLChartWidgetState();
}

class _ReportsPLChartWidgetState extends State<ReportsPLChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  int _touchedGroupIndex = -1;

  // Monthly Revenue vs Expense — realistic variance across 6 months
  static const List<Map<String, dynamic>> _monthlyData = [
    {'month': 'Nov', 'revenue': 298000.0, 'expense': 201000.0},
    {'month': 'Dec', 'revenue': 412000.0, 'expense': 298000.0},
    {'month': 'Jan', 'revenue': 334000.0, 'expense': 245000.0},
    {'month': 'Feb', 'revenue': 289000.0, 'expense': 218000.0},
    {'month': 'Mar', 'revenue': 378000.0, 'expense': 261000.0},
    {'month': 'Apr', 'revenue': 384000.0, 'expense': 261000.0},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final chartHeight = isTablet ? 280.0 : 220.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue vs Expenses',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              Row(
                children: [
                  _buildLegend(AppTheme.primary, 'Revenue'),
                  const SizedBox(width: 12),
                  _buildLegend(AppTheme.error, 'Expenses'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Nov 2025 – Apr 2026',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return SizedBox(
                height: chartHeight,
                child: BarChart(
                  _buildBarChartData(),
                  swapAnimationDuration: const Duration(milliseconds: 200),
                ),
              );
            },
          ),
          if (_touchedGroupIndex >= 0 &&
              _touchedGroupIndex < _monthlyData.length) ...[
            const SizedBox(height: 12),
            _buildTouchSummary(_touchedGroupIndex),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            color: AppTheme.outline,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTouchSummary(int index) {
    final data = _monthlyData[index];
    final revenue = data['revenue'] as double;
    final expense = data['expense'] as double;
    final profit = revenue - expense;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Revenue', revenue, AppTheme.primary),
          _buildSummaryItem('Expenses', expense, AppTheme.error),
          _buildSummaryItem('Profit', profit, AppTheme.success),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(fontSize: 10, color: AppTheme.outline),
        ),
        Text(
          '₹${(value / 1000).toStringAsFixed(1)}K',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 450000,
      barTouchData: BarTouchData(
        touchCallback: (event, response) {
          setState(() {
            if (response != null && response.spot != null) {
              _touchedGroupIndex = response.spot!.touchedBarGroupIndex;
            } else {
              _touchedGroupIndex = -1;
            }
          });
        },
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: AppTheme.onSurface,
          tooltipRoundedRadius: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final label = rodIndex == 0 ? 'Revenue' : 'Expense';
            return BarTooltipItem(
              '$label\n₹${(rod.toY / 1000).toStringAsFixed(1)}K',
              GoogleFonts.ibmPlexMono(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx >= 0 && idx < _monthlyData.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _monthlyData[idx]['month'] as String,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: AppTheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 46,
            interval: 100000,
            getTitlesWidget: (value, meta) {
              return Text(
                '₹${(value / 1000).toStringAsFixed(0)}K',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 9,
                  color: AppTheme.outline,
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 100000,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppTheme.outlineVariant.withAlpha(128),
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(_monthlyData.length, (index) {
        final data = _monthlyData[index];
        final isTouched = _touchedGroupIndex == index;
        final revenue = (data['revenue'] as double) * _animation.value;
        final expense = (data['expense'] as double) * _animation.value;

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: revenue,
              color: isTouched ? AppTheme.primaryDark : AppTheme.primary,
              width: 10,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: expense,
              color: isTouched
                  ? AppTheme.overdue
                  : AppTheme.error.withAlpha(179),
              width: 10,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
          barsSpace: 4,
        );
      }),
    );
  }
}