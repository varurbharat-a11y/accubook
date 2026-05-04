import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class InvoiceSummaryStripWidget extends StatelessWidget {
  final List<Map<String, dynamic>> invoices;

  const InvoiceSummaryStripWidget({super.key, required this.invoices});

  @override
  Widget build(BuildContext context) {
    double totalSales = 0;
    double totalPaid = 0;
    double totalOverdue = 0;
    int overdueCount = 0;

    for (final inv in invoices) {
      final amount = inv['amount'] as double;
      final status = inv['status'] as String;
      if (inv['invoiceType'] == 'Sales') {
        totalSales += amount;
        if (status == 'paid') totalPaid += amount;
        if (status == 'overdue') {
          totalOverdue += amount;
          overdueCount++;
        }
      }
    }

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          _buildStrip(
            'Total Billed',
            totalSales,
            AppTheme.primary,
            AppTheme.primaryContainer,
          ),
          const SizedBox(width: 8),
          _buildStrip(
            'Collected',
            totalPaid,
            AppTheme.success,
            AppTheme.successContainer,
          ),
          const SizedBox(width: 8),
          _buildStripAlert('Overdue', totalOverdue, overdueCount),
        ],
      ),
    );
  }

  Widget _buildStrip(
    String label,
    double amount,
    Color textColor,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '₹${_fmt(amount)}',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStripAlert(String label, double amount, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.overdueContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.error.withAlpha(51)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 10,
                    color: AppTheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '₹${_fmt(amount)}',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.error,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}
