import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class InvoiceListItemWidget extends StatelessWidget {
  final Map<String, dynamic> invoice;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const InvoiceListItemWidget({
    super.key,
    required this.invoice,
    required this.onDelete,
    required this.onTap,
  });

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
    final status = _parseStatus(invoice['status'] as String);
    final isOverdue = status == InvoiceStatus.overdue;
    final amount = invoice['amount'] as double;
    final gst = invoice['gst'] as double;
    final subtotal = amount - gst;

    return Dismissible(
      key: Key(invoice['id'] as String),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              'Delete',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Invoice',
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'Delete ${invoice['id']}? This action cannot be undone.',
              style: GoogleFonts.ibmPlexSans(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel', style: GoogleFonts.ibmPlexSans()),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                child: Text(
                  'Delete',
                  style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: isOverdue ? const Color(0xFFFFF5F5) : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isOverdue
              ? Border.all(color: AppTheme.error.withAlpha(64), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: AppTheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      invoice['id'] as String,
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      invoice['party'] as String,
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${amount.toStringAsFixed(0)}',
                                    style: GoogleFonts.ibmPlexMono(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isOverdue
                                          ? AppTheme.overdue
                                          : AppTheme.onSurface,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  StatusBadgeWidget(status: status),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildMetaChip(
                                Icons.calendar_today_outlined,
                                invoice['date'] as String,
                              ),
                              const SizedBox(width: 8),
                              _buildMetaChip(
                                Icons.event_outlined,
                                'Due ${invoice['dueDate']}',
                                color: isOverdue
                                    ? AppTheme.overdue
                                    : AppTheme.outline,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildGstChip(gst, invoice['gstRate'] as String),
                              const SizedBox(width: 8),
                              _buildTypeChip(invoice['invoiceType'] as String),
                              const Spacer(),
                              Row(
                                children: [
                                  _buildActionIcon(Icons.edit_outlined, () {}),
                                  const SizedBox(width: 4),
                                  _buildActionIcon(
                                    Icons.picture_as_pdf_outlined,
                                    () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color(invoice['colorHex'] as int).withAlpha(31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          invoice['initials'] as String,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(invoice['colorHex'] as int),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color ?? AppTheme.outline),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 10,
            color: color ?? AppTheme.outline,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildGstChip(double gst, String rate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'GST $rate: ₹${gst.toStringAsFixed(0)}',
        style: GoogleFonts.ibmPlexMono(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppTheme.gstAccent,
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    final isPurchase = type == 'Purchase';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPurchase
            ? AppTheme.warningContainer
            : AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isPurchase ? AppTheme.warning : AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppTheme.outline),
      ),
    );
  }
}
