import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../parties_screen.dart';

class PartyListItemWidget extends StatelessWidget {
  final Party party;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PartyListItemWidget({
    super.key,
    required this.party,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCreditor = party.partyType == 'Creditor';
    final typeColor = isCreditor ? AppTheme.error : AppTheme.success;
    final typeContainer = isCreditor
        ? AppTheme.errorContainer
        : AppTheme.successContainer;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: typeContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        party.name.isNotEmpty
                            ? party.name[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: typeColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          party.name,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: typeContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                party.partyType,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: typeColor,
                                ),
                              ),
                            ),
                            if (party.isGstRegistered) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'GST Reg.',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${party.openingBalance.toStringAsFixed(0)}',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: party.balanceType == 'Dr'
                              ? AppTheme.error
                              : AppTheme.success,
                        ),
                      ),
                      Text(
                        party.balanceType == 'Dr' ? 'Receivable' : 'Payable',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 10,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 18,
                      color: AppTheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (val) {
                      if (val == 'edit') onEdit();
                      if (val == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_outlined, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: GoogleFonts.ibmPlexSans(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 16,
                              color: AppTheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 13,
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (party.phone.isNotEmpty || party.address.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppTheme.outlineVariant),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (party.phone.isNotEmpty) ...[
                      const Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: AppTheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        party.phone,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (party.address.isNotEmpty)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppTheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                party.address,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 12,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
              if (party.isGstRegistered && party.gstNumber.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_outlined,
                      size: 13,
                      color: AppTheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'GSTIN: ${party.gstNumber}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
