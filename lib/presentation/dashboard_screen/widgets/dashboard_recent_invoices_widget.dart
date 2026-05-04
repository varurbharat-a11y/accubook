import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../routes/app_routes.dart';

class DashboardRecentInvoicesWidget extends StatelessWidget {
  final bool isTablet;

  const DashboardRecentInvoicesWidget({super.key, required this.isTablet});

  static final List<Map<String, dynamic>> _recentInvoicesMaps = [
    {
      'id': 'INV-2026-0142',
      'party': 'Mehta Textiles Pvt Ltd',
      'amount': 18450.0,
      'gst': 3321.0,
      'date': '04 May 2026',
      'dueDate': '18 May 2026',
      'status': 'sent',
      'initials': 'MT',
      'color': 0xFF3949AB,
    },
    {
      'id': 'INV-2026-0141',
      'party': 'Sharma & Sons Traders',
      'amount': 9820.0,
      'gst': 1767.6,
      'date': '03 May 2026',
      'dueDate': '17 May 2026',
      'status': 'paid',
      'initials': 'SS',
      'color': 0xFF2E7D32,
    },
    {
      'id': 'INV-2026-0138',
      'party': 'Patel Engineering Works',
      'amount': 34200.0,
      'gst': 6156.0,
      'date': '28 Apr 2026',
      'dueDate': '28 Apr 2026',
      'status': 'overdue',
      'initials': 'PE',
      'color': 0xFFC62828,
    },
    {
      'id': 'INV-2026-0136',
      'party': 'Krishnamurthy Exports',
      'amount': 52100.0,
      'gst': 9378.0,
      'date': '25 Apr 2026',
      'dueDate': '09 May 2026',
      'status': 'partiallyPaid',
      'initials': 'KE',
      'color': 0xFFE65100,
    },
    {
      'id': 'INV-2026-0134',
      'party': 'Reddy Construction Co',
      'amount': 7650.0,
      'gst': 1377.0,
      'date': '22 Apr 2026',
      'dueDate': '06 May 2026',
      'status': 'draft',
      'initials': 'RC',
      'color': 0xFF546E7A,
    },
  ];

  static InvoiceStatus _parseStatus(String s) {
    switch (s) {
      case 'paid':
        return InvoiceStatus.paid;
      case 'sent':
        return InvoiceStatus.sent;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'partiallyPaid':
        return InvoiceStatus.partiallyPaid;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      default:
        return InvoiceStatus.draft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
      child: Container(
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Invoices',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.invoiceScreen),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    child: Text(
                      'View All',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...List.generate(_recentInvoicesMaps.length, (index) {
              final inv = _recentInvoicesMaps[index];
              final status = _parseStatus(inv['status'] as String);
              final isOverdue = status == InvoiceStatus.overdue;

              return Column(
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.invoiceScreen),
                    splashColor: AppTheme.primaryContainer,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? AppTheme.overdueContainer.withAlpha(77)
                            : null,
                        border: isOverdue
                            ? const Border(
                                left: BorderSide(
                                  color: AppTheme.overdue,
                                  width: 3,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          _buildAvatar(inv),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      inv['id'] as String,
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      '₹${_formatAmount(inv['amount'] as double)}',
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isOverdue
                                            ? AppTheme.overdue
                                            : AppTheme.onSurface,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        inv['party'] as String,
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    StatusBadgeWidget(status: status),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      inv['date'] as String,
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 10,
                                        color: AppTheme.outline,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(
                                        color: AppTheme.outline,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'GST: ₹${_formatAmount(inv['gst'] as double)}',
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 10,
                                        color: AppTheme.gstAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < _recentInvoicesMaps.length - 1)
                    const Divider(height: 1, indent: 60),
                ],
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> inv) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Color(inv['color'] as int).withAlpha(31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          inv['initials'] as String,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(inv['color'] as int),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}
