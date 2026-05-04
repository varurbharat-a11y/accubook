import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardChartWidget extends StatefulWidget {
  final String period;
  const DashboardChartWidget({super.key, required this.period});

  @override
  State<DashboardChartWidget> createState() => _DashboardChartWidgetState();
}

class _DashboardChartWidgetState extends State<DashboardChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  int _touchedIndex = -1;

  // Mock 7-day sales data — realistic daily variance
  final List<Map<String, dynamic>> _salesData = [
    {'day': 'Mon', 'sales': 32400.0, 'purchases': 18200.0},
    {'day': 'Tue', 'sales': 41200.0, 'purchases': 22100.0},
    {'day': 'Wed', 'sales': 28900.0, 'purchases': 15400.0},
    {'day': 'Thu', 'sales': 55600.0, 'purchases': 31200.0},
    {'day': 'Fri', 'sales': 48750.0, 'purchases': 27800.0},
    {'day': 'Sat', 'sales': 62100.0, 'purchases': 19500.0},
    {'day': 'Sun', 'sales': 19300.0, 'purchases': 8700.0},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    final chartHeight = isTablet ? 240.0 : 200.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
      child: Container(
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
                  '7-Day Sales Trend',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    _buildLegend(AppTheme.primary, 'Sales'),
                    const SizedBox(width: 12),
                    _buildLegend(AppTheme.gstAccent, 'Purchases'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Week of 28 Apr – 04 May 2026',
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
                  child: LineChart(
                    _buildLineChartData(),
                    duration: const Duration(milliseconds: 200),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
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

  LineChartData _buildLineChartData() {
    final salesSpots = _salesData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value['sales'] as double);
    }).toList();

    final purchaseSpots = _salesData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value['purchases'] as double);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20000,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppTheme.outlineVariant.withAlpha(153),
          strokeWidth: 1,
          dashArray: [4, 4],
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
              if (idx >= 0 && idx < _salesData.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _salesData[idx]['day'] as String,
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
            interval: 20000,
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
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 75000,
      lineBarsData: [
        LineChartBarData(
          spots: salesSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppTheme.primary,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 3.5,
              color: AppTheme.surface,
              strokeWidth: 2,
              strokeColor: AppTheme.primary,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withAlpha(46),
                AppTheme.primary.withAlpha(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        LineChartBarData(
          spots: purchaseSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppTheme.gstAccent,
          barWidth: 2,
          isStrokeCapRound: true,
          dashArray: [5, 3],
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        touchCallback: (event, response) {
          if (response != null && response.lineBarSpots != null) {
            setState(
              () => _touchedIndex = response.lineBarSpots!.first.spotIndex,
            );
          } else {
            setState(() => _touchedIndex = -1);
          }
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: AppTheme.onSurface,
          tooltipRoundedRadius: 8,
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          getTooltipItems: (spots) {
            return spots.map((spot) {
              final isFirst = spot == spots.first;
              return LineTooltipItem(
                isFirst
                    ? '₹${(spot.y / 1000).toStringAsFixed(1)}K\n'
                    : '₹${(spot.y / 1000).toStringAsFixed(1)}K',
                GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                children: isFirst
                    ? [
                        TextSpan(
                          text:
                              _salesData[spot.spotIndex.toInt()]['day']
                                  as String,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                      ]
                    : null,
              );
            }).toList();
          },
        ),
      ),
    );
  }
}