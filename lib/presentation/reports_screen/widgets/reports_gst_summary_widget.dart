import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ReportsGstSummaryWidget extends StatefulWidget {
  const ReportsGstSummaryWidget({super.key});

  @override
  State<ReportsGstSummaryWidget> createState() =>
      _ReportsGstSummaryWidgetState();
}

class _ReportsGstSummaryWidgetState extends State<ReportsGstSummaryWidget> {
  int _touchedIndex = -1;
  String _activeTab = 'GSTR-1';

  static const List<Map<String, dynamic>> _gstr1Data = [
    {
      'rate': '5%',
      'taxable': 48000.0,
      'cgst': 1200.0,
      'sgst': 1200.0,
      'igst': 0.0,
      'total': 2400.0,
    },
    {
      'rate': '12%',
      'taxable': 124000.0,
      'cgst': 7440.0,
      'sgst': 7440.0,
      'igst': 0.0,
      'total': 14880.0,
    },
    {
      'rate': '18%',
      'taxable': 198000.0,
      'cgst': 17820.0,
      'sgst': 17820.0,
      'igst': 0.0,
      'total': 35640.0,
    },
    {
      'rate': '28%',
      'taxable': 14000.0,
      'cgst': 1960.0,
      'sgst': 1960.0,
      'igst': 0.0,
      'total': 3920.0,
    },
  ];

  static const List<Map<String, dynamic>> _gstr3bData = [
    {'label': 'Output Tax (Sales)', 'value': 56840.0, 'type': 'liability'},
    {'label': 'ITC on Purchases', 'value': 33120.0, 'type': 'credit'},
    {'label': 'ITC on Capital Goods', 'value': 4800.0, 'type': 'credit'},
    {'label': 'Reverse Charge', 'value': 2400.0, 'type': 'liability'},
    {'label': 'Net GST Payable', 'value': 22320.0, 'type': 'net'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        const SizedBox(height: 12),
        if (_activeTab == 'GSTR-1') _buildGstr1Content(),
        if (_activeTab == 'GSTR-3B') _buildGstr3bContent(),
        if (_activeTab == 'HSN') _buildHsnContent(),
      ],
    );
  }

  Widget _buildTabBar() {
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
      child: Row(
        children: ['GSTR-1', 'GSTR-3B', 'HSN'].map((tab) {
          final isActive = _activeTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tab,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? Colors.white : AppTheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGstr1Content() {
    return Column(
      children: [
        _buildGstPieChart(),
        const SizedBox(height: 12),
        Container(
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
            children: [
              _buildTableHeader([
                'GST Rate',
                'Taxable Amt',
                'CGST',
                'SGST',
                'Total Tax',
              ]),
              ..._gstr1Data.asMap().entries.map((entry) {
                final row = entry.value;
                return _buildTableRow([
                  row['rate'] as String,
                  '₹${_fmt(row['taxable'] as double)}',
                  '₹${_fmt(row['cgst'] as double)}',
                  '₹${_fmt(row['sgst'] as double)}',
                  '₹${_fmt(row['total'] as double)}',
                ], entry.key.isEven);
              }),
              _buildTableRow(
                [
                  'Total',
                  '₹${_fmt(_gstr1Data.fold(0.0, (s, r) => s + (r['taxable'] as double)))}',
                  '₹${_fmt(_gstr1Data.fold(0.0, (s, r) => s + (r['cgst'] as double)))}',
                  '₹${_fmt(_gstr1Data.fold(0.0, (s, r) => s + (r['sgst'] as double)))}',
                  '₹${_fmt(_gstr1Data.fold(0.0, (s, r) => s + (r['total'] as double)))}',
                ],
                false,
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGstPieChart() {
    final colors = [
      AppTheme.success,
      AppTheme.primary,
      AppTheme.gstAccent,
      AppTheme.warning,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Text(
            'Tax Distribution by Rate',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (response != null &&
                                response.touchedSection != null) {
                              _touchedIndex =
                                  response.touchedSection!.touchedSectionIndex;
                            } else {
                              _touchedIndex = -1;
                            }
                          });
                        },
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _gstr1Data.asMap().entries.map((entry) {
                        final isTouched = _touchedIndex == entry.key;
                        final row = entry.value;
                        final total = row['total'] as double;
                        return PieChartSectionData(
                          value: total,
                          color: colors[entry.key],
                          radius: isTouched ? 60 : 50,
                          title: row['rate'] as String,
                          titleStyle: GoogleFonts.ibmPlexSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _gstr1Data.asMap().entries.map((entry) {
                    final row = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colors[entry.key],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${row['rate']}: ₹${_fmt(row['total'] as double)}',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
                              color: AppTheme.onSurface,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGstr3bContent() {
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
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GSTR-3B Summary',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Due: 20 May 2026',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ..._gstr3bData.map((row) {
            final type = row['type'] as String;
            Color valueColor;
            if (type == 'liability') {
              valueColor = AppTheme.error;
            } else if (type == 'credit')
              valueColor = AppTheme.success;
            else
              valueColor = AppTheme.primary;

            final isNet = type == 'net';

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isNet ? AppTheme.primaryContainer : null,
                border: isNet
                    ? const Border(
                        top: BorderSide(color: AppTheme.outlineVariant),
                      )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    row['label'] as String,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: isNet ? 14 : 13,
                      fontWeight: isNet ? FontWeight.w700 : FontWeight.w400,
                      color: isNet ? AppTheme.primary : AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    '₹${(row['value'] as double).toStringAsFixed(0)}',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: isNet ? 16 : 13,
                      fontWeight: isNet ? FontWeight.w700 : FontWeight.w600,
                      color: valueColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file_outlined, size: 16),
              label: Text(
                'File GSTR-3B',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.gstAccent,
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHsnContent() {
    final hsnData = [
      {
        'hsn': '5208',
        'desc': 'Woven cotton fabrics',
        'qty': '420 Mtr',
        'taxable': 84000.0,
        'gst': 15120.0,
      },
      {
        'hsn': '8471',
        'desc': 'Computing machines',
        'qty': '12 Nos',
        'taxable': 126000.0,
        'gst': 22680.0,
      },
      {
        'hsn': '3004',
        'desc': 'Pharmaceutical goods',
        'qty': '850 Nos',
        'taxable': 42500.0,
        'gst': 5100.0,
      },
      {
        'hsn': '7308',
        'desc': 'Steel structures',
        'qty': '2.4 MT',
        'taxable': 96000.0,
        'gst': 17280.0,
      },
    ];

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
        children: [
          _buildTableHeader([
            'HSN Code',
            'Description',
            'Qty',
            'Taxable',
            'GST',
          ]),
          ...hsnData.asMap().entries.map((entry) {
            final row = entry.value;
            return _buildTableRow([
              row['hsn'] as String,
              row['desc'] as String,
              row['qty'] as String,
              '₹${_fmt(row['taxable'] as double)}',
              '₹${_fmt(row['gst'] as double)}',
            ], entry.key.isEven);
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: headers.asMap().entries.map((entry) {
          return Expanded(
            child: Text(
              entry.value,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
              textAlign: entry.key > 0 ? TextAlign.right : TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableRow(
    List<String> cells,
    bool isEven, {
    bool isTotal = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isTotal
            ? AppTheme.primaryContainer
            : isEven
            ? AppTheme.surfaceVariant.withAlpha(102)
            : AppTheme.surface,
        border: isTotal
            ? const Border(top: BorderSide(color: AppTheme.outlineVariant))
            : null,
      ),
      child: Row(
        children: cells.asMap().entries.map((entry) {
          return Expanded(
            child: Text(
              entry.value,
              style: entry.key == 0
                  ? GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
                      color: isTotal ? AppTheme.primary : AppTheme.onSurface,
                    )
                  : GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
                      color: isTotal ? AppTheme.primary : AppTheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              textAlign: entry.key > 0 ? TextAlign.right : TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}
