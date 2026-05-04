import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ReportsKpiStripWidget extends StatelessWidget {
  final String reportType;

  const ReportsKpiStripWidget({super.key, required this.reportType});

  List<_ReportKpi> _kpisFor(String type) {
    switch (type) {
      case 'P&L Statement':
        return [
          _ReportKpi(
            'Revenue',
            '₹3.84L',
            AppTheme.success,
            Icons.arrow_upward_rounded,
          ),
          _ReportKpi(
            'Expenses',
            '₹2.61L',
            AppTheme.error,
            Icons.arrow_downward_rounded,
          ),
          _ReportKpi(
            'Net Profit',
            '₹1.23L',
            AppTheme.primary,
            Icons.show_chart_rounded,
          ),
          _ReportKpi(
            'Margin',
            '32.1%',
            AppTheme.gstAccent,
            Icons.percent_rounded,
          ),
        ];
      case 'Balance Sheet':
        return [
          _ReportKpi(
            'Total Assets',
            '₹8.42L',
            AppTheme.primary,
            Icons.account_balance_outlined,
          ),
          _ReportKpi(
            'Liabilities',
            '₹3.18L',
            AppTheme.error,
            Icons.money_off_outlined,
          ),
          _ReportKpi(
            'Net Worth',
            '₹5.24L',
            AppTheme.success,
            Icons.trending_up_rounded,
          ),
          _ReportKpi(
            'Debt Ratio',
            '37.8%',
            AppTheme.warning,
            Icons.help_outline,
          ),
        ];
      case 'Daily Report':
        return [
          _ReportKpi(
            'Today Sales',
            '₹48,750',
            AppTheme.success,
            Icons.point_of_sale_outlined,
          ),
          _ReportKpi(
            'Receipts',
            '₹32,400',
            AppTheme.primary,
            Icons.payments_outlined,
          ),
          _ReportKpi(
            'Payments',
            '₹18,200',
            AppTheme.error,
            Icons.send_outlined,
          ),
          _ReportKpi(
            'Cash Balance',
            '₹14,200',
            AppTheme.gstAccent,
            Icons.account_balance_wallet_outlined,
          ),
        ];
      case 'Sales Register':
        return [
          _ReportKpi(
            'Total Sales',
            '₹2.94L',
            AppTheme.success,
            Icons.trending_up_rounded,
          ),
          _ReportKpi(
            'Invoices',
            '28',
            AppTheme.primary,
            Icons.receipt_outlined,
          ),
          _ReportKpi(
            'GST Collected',
            '₹52,920',
            AppTheme.gstAccent,
            Icons.receipt_long_outlined,
          ),
          _ReportKpi(
            'Avg Invoice',
            '₹10,500',
            AppTheme.warning,
            Icons.analytics_outlined,
          ),
        ];
      case 'Purchase Register':
        return [
          _ReportKpi(
            'Total Purchase',
            '₹1.84L',
            AppTheme.error,
            Icons.shopping_cart_outlined,
          ),
          _ReportKpi('Bills', '16', AppTheme.primary, Icons.receipt_outlined),
          _ReportKpi(
            'GST Paid',
            '₹33,120',
            AppTheme.gstAccent,
            Icons.receipt_long_outlined,
          ),
          _ReportKpi(
            'Input Credit',
            '₹33,120',
            AppTheme.success,
            Icons.savings_outlined,
          ),
        ];
      case 'GST Reports':
        return [
          _ReportKpi(
            'Output GST',
            '₹52,920',
            AppTheme.error,
            Icons.arrow_upward_rounded,
          ),
          _ReportKpi(
            'Input Credit',
            '₹33,120',
            AppTheme.success,
            Icons.arrow_downward_rounded,
          ),
          _ReportKpi(
            'Net GST',
            '₹19,800',
            AppTheme.warning,
            Icons.account_balance_outlined,
          ),
          _ReportKpi(
            'GSTR-3B Due',
            '20 May',
            AppTheme.error,
            Icons.event_outlined,
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final kpis = _kpisFor(reportType);

    return Row(
      children: kpis.asMap().entries.map((entry) {
        final kpi = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: entry.key < kpis.length - 1 ? 8 : 0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: kpi.color.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kpi.color.withAlpha(51)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(kpi.icon, size: 12, color: kpi.color),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          kpi.label,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 9,
                            color: kpi.color,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kpi.value,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: kpi.color,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ReportKpi {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _ReportKpi(this.label, this.value, this.color, this.icon);
}
