import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class DashboardOverdueBannerWidget extends StatelessWidget {
  final int overdueCount;
  final double overdueAmount;

  const DashboardOverdueBannerWidget({
    super.key,
    required this.overdueCount,
    required this.overdueAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Padding(
      padding: EdgeInsets.fromLTRB(isTablet ? 0 : 16, 0, isTablet ? 0 : 16, 8),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.invoiceScreen),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.error.withAlpha(77), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.error.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppTheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$overdueCount Invoice${overdueCount > 1 ? 's' : ''} Overdue',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.error,
                      ),
                    ),
                    Text(
                      'Total outstanding: ₹${(overdueAmount / 1000).toStringAsFixed(1)}K',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: AppTheme.error.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Collect',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.error,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppTheme.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
