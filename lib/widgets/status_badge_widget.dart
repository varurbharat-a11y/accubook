import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum InvoiceStatus { draft, sent, paid, partiallyPaid, overdue, cancelled }

class StatusBadgeWidget extends StatelessWidget {
  final InvoiceStatus status;
  final double fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        config.label,
        style: GoogleFonts.ibmPlexSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: config.textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return _StatusConfig(
          'DRAFT',
          AppTheme.surfaceVariant,
          AppTheme.outline,
        );
      case InvoiceStatus.sent:
        return _StatusConfig(
          'SENT',
          const Color(0xFFE3F2FD),
          const Color(0xFF1565C0),
        );
      case InvoiceStatus.paid:
        return _StatusConfig('PAID', AppTheme.paidContainer, AppTheme.paid);
      case InvoiceStatus.partiallyPaid:
        return _StatusConfig(
          'PARTIAL',
          const Color(0xFFFFF3E0),
          const Color(0xFFE65100),
        );
      case InvoiceStatus.overdue:
        return _StatusConfig(
          'OVERDUE',
          AppTheme.overdueContainer,
          AppTheme.overdue,
        );
      case InvoiceStatus.cancelled:
        return _StatusConfig(
          'CANCELLED',
          const Color(0xFFF5F5F5),
          const Color(0xFF757575),
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _StatusConfig(this.label, this.bgColor, this.textColor);
}
