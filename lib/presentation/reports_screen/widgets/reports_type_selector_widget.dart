import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ReportsTypeSelectorWidget extends StatelessWidget {
  final List<String> reportTypes;
  final String selectedReport;
  final Function(String) onReportSelected;
  final bool isVertical;

  const ReportsTypeSelectorWidget({
    super.key,
    required this.reportTypes,
    required this.selectedReport,
    required this.onReportSelected,
    this.isVertical = false,
  });

  static IconData _iconFor(String type) {
    switch (type) {
      case 'P&L Statement':
        return Icons.show_chart_rounded;
      case 'Balance Sheet':
        return Icons.account_balance_outlined;
      case 'Daily Report':
        return Icons.today_outlined;
      case 'Sales Register':
        return Icons.trending_up_rounded;
      case 'Purchase Register':
        return Icons.shopping_cart_outlined;
      case 'GST Reports':
        return Icons.receipt_long_outlined;
      default:
        return Icons.bar_chart_outlined;
    }
  }

  static Color _colorFor(String type) {
    switch (type) {
      case 'P&L Statement':
        return AppTheme.primary;
      case 'Balance Sheet':
        return const Color(0xFF7B1FA2);
      case 'Daily Report':
        return AppTheme.success;
      case 'Sales Register':
        return AppTheme.warning;
      case 'Purchase Register':
        return AppTheme.error;
      case 'GST Reports':
        return AppTheme.gstAccent;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: reportTypes.asMap().entries.map((entry) {
            final isSelected = selectedReport == entry.value;
            return _buildVerticalItem(
              entry.value,
              isSelected,
              entry.key == reportTypes.length - 1,
            );
          }).toList(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT REPORT',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.outline,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: reportTypes.length,
            itemBuilder: (context, index) {
              final type = reportTypes[index];
              final isSelected = selectedReport == type;
              return _buildReportTypeCard(type, isSelected);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeCard(String type, bool isSelected) {
    final color = _colorFor(type);
    final icon = _iconFor(type);

    return GestureDetector(
      onTap: () => onReportSelected(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(31) : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppTheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isSelected ? color : AppTheme.outline),
            const SizedBox(height: 6),
            Text(
              type,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : AppTheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalItem(String type, bool isSelected, bool isLast) {
    final color = _colorFor(type);
    final icon = _iconFor(type);

    return Column(
      children: [
        InkWell(
          onTap: () => onReportSelected(type),
          borderRadius: BorderRadius.circular(isLast ? 0 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color.withAlpha(20) : Colors.transparent,
              border: isSelected
                  ? Border(left: BorderSide(color: color, width: 3))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? color : AppTheme.outline,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    type,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? color : AppTheme.onSurface,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.chevron_right_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
