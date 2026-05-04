import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class InvoiceFilterBarWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const InvoiceFilterBarWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  static const List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.list_rounded},
    {'label': 'Draft', 'icon': Icons.edit_note_outlined},
    {'label': 'Sent', 'icon': Icons.send_outlined},
    {'label': 'Paid', 'icon': Icons.check_circle_outline},
    {'label': 'Overdue', 'icon': Icons.warning_amber_outlined},
    {'label': 'Partial', 'icon': Icons.hourglass_top_outlined},
    {'label': 'Cancelled', 'icon': Icons.cancel_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = selectedFilter == filter['label'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                child: FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        filter['icon'] as IconData,
                        size: 13,
                        color: isSelected ? AppTheme.primary : AppTheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        filter['label'] as String,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  onSelected: (_) => onFilterChanged(filter['label'] as String),
                  backgroundColor: AppTheme.surfaceVariant,
                  selectedColor: AppTheme.primaryContainer,
                  checkmarkColor: AppTheme.primary,
                  showCheckmark: false,
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.outlineVariant,
                    width: isSelected ? 1.5 : 1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
