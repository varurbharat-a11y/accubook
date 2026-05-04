import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ReportsDateRangeWidget extends StatelessWidget {
  final DateTimeRange selectedRange;
  final Function(DateTimeRange) onRangeChanged;

  const ReportsDateRangeWidget({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  static const List<Map<String, dynamic>> _presets = [
    {'label': 'Today', 'days': 0},
    {'label': 'This Week', 'days': 7},
    {'label': 'This Month', 'days': 30},
    {'label': 'Last Month', 'days': -30},
    {'label': 'This Quarter', 'days': 90},
    {'label': 'This FY', 'days': 365},
  ];

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                size: 14,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'DATE RANGE',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _pickCustomRange(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_formatDate(selectedRange.start)} – ${_formatDate(selectedRange.end)}',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.edit_calendar_outlined,
                        size: 12,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presets.map((preset) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(
                      preset['label'] as String,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => _applyPreset(preset['label'] as String),
                    backgroundColor: AppTheme.surfaceVariant,
                    side: const BorderSide(color: AppTheme.outlineVariant),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _applyPreset(String label) {
    final now = DateTime(2026, 5, 4);
    DateTimeRange range;
    switch (label) {
      case 'Today':
        range = DateTimeRange(start: now, end: now);
        break;
      case 'This Week':
        range = DateTimeRange(
          start: now.subtract(Duration(days: now.weekday - 1)),
          end: now,
        );
        break;
      case 'This Month':
        range = DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
        break;
      case 'Last Month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        range = DateTimeRange(
          start: lastMonth,
          end: DateTime(now.year, now.month, 0),
        );
        break;
      case 'This Quarter':
        final qStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        range = DateTimeRange(start: qStart, end: now);
        break;
      case 'This FY':
        final fyStart = now.month >= 4
            ? DateTime(now.year, 4, 1)
            : DateTime(now.year - 1, 4, 1);
        range = DateTimeRange(start: fyStart, end: now);
        break;
      default:
        range = DateTimeRange(start: now, end: now);
    }
    onRangeChanged(range);
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: selectedRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) onRangeChanged(picked);
  }
}
