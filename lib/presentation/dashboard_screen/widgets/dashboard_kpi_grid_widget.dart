import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardKpiGridWidget extends StatelessWidget {
  final Map<String, dynamic> kpiData;
  final bool isTablet;

  const DashboardKpiGridWidget({
    super.key,
    required this.kpiData,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = _buildMetrics();
    final crossAxisCount = isTablet ? 3 : 2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: isTablet ? 1.6 : 1.5,
        ),
        itemCount: metrics.length,
        itemBuilder: (context, index) => _KpiCard(metric: metrics[index]),
      ),
    );
  }

  List<_KpiMetric> _buildMetrics() {
    return [
      _KpiMetric(
        label: "Today's Sales",
        value: '₹${_formatAmount(kpiData['todaySales'])}',
        icon: Icons.trending_up_rounded,
        iconColor: AppTheme.success,
        bgColor: AppTheme.successContainer,
        trend: '+12.4%',
        trendUp: true,
      ),
      _KpiMetric(
        label: 'Receivables',
        value: '₹${_formatAmount(kpiData['receivables'])}',
        icon: Icons.account_balance_wallet_outlined,
        iconColor: AppTheme.primary,
        bgColor: AppTheme.primaryContainer,
        trend: '${kpiData['overdueCount']} overdue',
        trendUp: false,
        trendIsAlert: true,
      ),
      _KpiMetric(
        label: 'Payables',
        value: '₹${_formatAmount(kpiData['payables'])}',
        icon: Icons.payment_outlined,
        iconColor: AppTheme.warning,
        bgColor: AppTheme.warningContainer,
        trend: 'Due in 7d',
        trendUp: false,
      ),
      _KpiMetric(
        label: 'GST Payable',
        value: '₹${_formatAmount(kpiData['gstPayable'])}',
        icon: Icons.receipt_outlined,
        iconColor: AppTheme.gstAccent,
        bgColor: AppTheme.secondaryContainer,
        trend: 'GSTR-3B due',
        trendUp: false,
        trendIsAlert: true,
      ),
      _KpiMetric(
        label: 'Net P&L (Month)',
        value: '₹${_formatAmount(kpiData['netPL'])}',
        icon: Icons.show_chart_rounded,
        iconColor: AppTheme.success,
        bgColor: AppTheme.successContainer,
        trend: '+8.2% vs last',
        trendUp: true,
      ),
      _KpiMetric(
        label: 'Active Parties',
        value: '${kpiData['activeParties']}',
        icon: Icons.people_outline_rounded,
        iconColor: const Color(0xFF7B1FA2),
        bgColor: const Color(0xFFF3E5F5),
        trend: '12 debtors',
        trendUp: null,
      ),
    ];
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _KpiMetric {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String trend;
  final bool? trendUp;
  final bool trendIsAlert;

  const _KpiMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.trend,
    this.trendUp,
    this.trendIsAlert = false,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiMetric metric;
  const _KpiCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: metric.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(metric.icon, size: 16, color: metric.iconColor),
              ),
              _buildTrendBadge(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            metric.label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.outline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBadge() {
    Color badgeColor;
    Color textColor;

    if (metric.trendIsAlert) {
      badgeColor = AppTheme.errorContainer;
      textColor = AppTheme.error;
    } else if (metric.trendUp == true) {
      badgeColor = AppTheme.successContainer;
      textColor = AppTheme.success;
    } else if (metric.trendUp == false) {
      badgeColor = AppTheme.warningContainer;
      textColor = AppTheme.warning;
    } else {
      badgeColor = AppTheme.surfaceVariant;
      textColor = AppTheme.outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        metric.trend,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
