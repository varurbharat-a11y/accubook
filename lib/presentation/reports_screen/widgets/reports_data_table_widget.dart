import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ReportsDataTableWidget extends StatelessWidget {
  final String reportType;

  const ReportsDataTableWidget({super.key, required this.reportType});

  @override
  Widget build(BuildContext context) {
    switch (reportType) {
      case 'P&L Statement':
        return _buildPLTable();
      case 'Balance Sheet':
        return _buildBalanceSheetTable();
      case 'Daily Report':
        return _buildDailyReportTable();
      case 'Sales Register':
        return _buildSalesRegisterTable();
      case 'Purchase Register':
        return _buildPurchaseRegisterTable();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPLTable() {
    final sections = [
      {
        'title': 'INCOME',
        'color': AppTheme.success,
        'rows': [
          ['Sales Revenue', '3,84,000', ''],
          ['Service Income', '18,400', ''],
          ['Other Income', '4,200', ''],
          ['Gross Income', '', '4,06,600'],
        ],
        'isHeader': [false, false, false, true],
      },
      {
        'title': 'EXPENSES',
        'color': AppTheme.error,
        'rows': [
          ['Cost of Goods Sold', '1,98,000', ''],
          ['Employee Salaries', '42,000', ''],
          ['Office Rent', '18,000', ''],
          ['Utilities & Misc', '3,200', ''],
          ['Total Expenses', '', '2,61,200'],
        ],
        'isHeader': [false, false, false, false, true],
      },
      {
        'title': 'NET PROFIT',
        'color': AppTheme.primary,
        'rows': [
          ['Net Profit Before Tax', '', '1,45,400'],
          ['Income Tax Provision', '22,140', ''],
          ['Net Profit After Tax', '', '1,23,260'],
        ],
        'isHeader': [true, false, true],
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
        children: sections.map((section) {
          final rows = section['rows'] as List<List<String>>;
          final isHeaderList = section['isHeader'] as List<bool>;
          final color = section['color'] as Color;
          final title = section['title'] as String;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                color: color.withAlpha(26),
                child: Text(
                  title,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              ...rows.asMap().entries.map((entry) {
                final row = entry.value;
                final isBold = isHeaderList[entry.key];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isBold ? color.withAlpha(13) : null,
                    border: isBold
                        ? const Border(
                            top: BorderSide(color: AppTheme.outlineVariant),
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        row[0],
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: isBold
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isBold ? color : AppTheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          if (row[1].isNotEmpty)
                            Text(
                              '₹${row[1]}',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 12,
                                color: AppTheme.onSurface,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          if (row[2].isNotEmpty)
                            Text(
                              '₹${row[2]}',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: color,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBalanceSheetTable() {
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
          _buildBSSection(
            'ASSETS',
            AppTheme.primary,
            [
              ['Fixed Assets', '₹2,84,000'],
              ['Current Assets', '₹4,18,000'],
              ['Cash & Bank', '₹1,40,000'],
              ['Total Assets', '₹8,42,000'],
            ],
            [false, false, false, true],
          ),
          const Divider(height: 1),
          _buildBSSection(
            'LIABILITIES & EQUITY',
            AppTheme.error,
            [
              ['Owner\'s Capital', '₹3,24,000'],
              ['Retained Earnings', '₹2,00,000'],
              ['Current Liabilities', '₹1,82,000'],
              ['Long-term Loans', '₹1,36,000'],
              ['Total Liabilities + Equity', '₹8,42,000'],
            ],
            [false, false, false, false, true],
          ),
        ],
      ),
    );
  }

  Widget _buildBSSection(
    String title,
    Color color,
    List<List<String>> rows,
    List<bool> isBoldList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          color: color.withAlpha(26),
          child: Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ...rows.asMap().entries.map((entry) {
          final isBold = isBoldList[entry.key];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isBold ? color.withAlpha(13) : null,
              border: isBold
                  ? const Border(
                      top: BorderSide(color: AppTheme.outlineVariant),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.value[0],
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                    color: isBold ? color : AppTheme.onSurface,
                  ),
                ),
                Text(
                  entry.value[1],
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: isBold ? 13 : 12,
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                    color: isBold ? color : AppTheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDailyReportTable() {
    final entries = [
      {
        'time': '09:14',
        'type': 'Receipt',
        'party': 'Mehta Textiles',
        'ref': 'RCP-0089',
        'debit': 0.0,
        'credit': 18450.0,
      },
      {
        'time': '10:32',
        'type': 'Invoice',
        'party': 'Nair Electronics',
        'ref': 'INV-0139',
        'debit': 14200.0,
        'credit': 0.0,
      },
      {
        'time': '11:45',
        'type': 'Payment',
        'party': 'Rajan Raw Materials',
        'ref': 'PAY-0067',
        'debit': 0.0,
        'credit': 22000.0,
      },
      {
        'time': '13:20',
        'type': 'Invoice',
        'party': 'Global Pharma',
        'ref': 'INV-0140',
        'debit': 62400.0,
        'credit': 0.0,
      },
      {
        'time': '15:10',
        'type': 'Expense',
        'party': 'Office Depot',
        'ref': 'EXP-0034',
        'debit': 0.0,
        'credit': 3200.0,
      },
      {
        'time': '16:48',
        'type': 'Receipt',
        'party': 'Sharma & Sons',
        'ref': 'RCP-0090',
        'debit': 9820.0,
        'credit': 0.0,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                SizedBox(width: 44, child: Text('Time', style: _headerStyle())),
                SizedBox(width: 64, child: Text('Type', style: _headerStyle())),
                Expanded(
                  child: Text('Party / Reference', style: _headerStyle()),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    'Amount',
                    style: _headerStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          ...entries.asMap().entries.map((entry) {
            final row = entry.value;
            final isCredit = (row['credit'] as double) > 0;
            final amount = isCredit
                ? row['credit'] as double
                : row['debit'] as double;
            final type = row['type'] as String;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: entry.key.isEven
                    ? AppTheme.surfaceVariant.withAlpha(77)
                    : null,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      row['time'] as String,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 10,
                        color: AppTheme.outline,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _typeColor(type).withAlpha(26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: _typeColor(type),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['party'] as String,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          row['ref'] as String,
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 10,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    child: Text(
                      '${isCredit ? '+' : '-'}₹${_fmt(amount)}',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isCredit ? AppTheme.success : AppTheme.error,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSalesRegisterTable() {
    final rows = [
      [
        'INV-0142',
        '04 May',
        'Mehta Textiles',
        '₹15,129',
        '₹18%',
        '₹3,321',
        '₹18,450',
        'SENT',
      ],
      [
        'INV-0141',
        '03 May',
        'Sharma & Sons',
        '₹8,052',
        '₹18%',
        '₹1,768',
        '₹9,820',
        'PAID',
      ],
      [
        'INV-0140',
        '02 May',
        'Global Pharma',
        '₹55,714',
        '12%',
        '₹6,686',
        '₹62,400',
        'SENT',
      ],
      [
        'INV-0138',
        '28 Apr',
        'Patel Engg',
        '₹28,983',
        '18%',
        '₹6,156',
        '₹34,200',
        'OVERDUE',
      ],
      [
        'INV-0136',
        '25 Apr',
        'Krishnamurthy',
        '₹44,153',
        '18%',
        '₹9,378',
        '₹52,100',
        'PARTIAL',
      ],
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppTheme.primaryContainer),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            return null;
          }),
          columnSpacing: 16,
          headingTextStyle: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
          dataTextStyle: GoogleFonts.ibmPlexMono(
            fontSize: 11,
            color: AppTheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          columns: const [
            DataColumn(label: Text('Invoice')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Party')),
            DataColumn(label: Text('Taxable')),
            DataColumn(label: Text('Rate')),
            DataColumn(label: Text('GST')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Status')),
          ],
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row.asMap().entries.map((entry) {
                    if (entry.key == 7) {
                      return DataCell(_buildStatusText(entry.value));
                    }
                    return DataCell(Text(entry.value));
                  }).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPurchaseRegisterTable() {
    final rows = [
      [
        'PUR-0089',
        '01 May',
        'Rajan Raw Mats',
        '₹37,119',
        '18%',
        '₹7,884',
        '₹43,800',
        'SENT',
      ],
      [
        'PUR-0088',
        '28 Apr',
        'Bansal Chemicals',
        '₹14,432',
        '12%',
        '₹1,732',
        '₹16,164',
        'PAID',
      ],
      [
        'PUR-0087',
        '24 Apr',
        'National Supply',
        '₹28,000',
        '18%',
        '₹5,040',
        '₹33,040',
        'PAID',
      ],
      [
        'PUR-0086',
        '20 Apr',
        'Delhi Traders',
        '₹9,200',
        '5%',
        '₹460',
        '₹9,660',
        'PAID',
      ],
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppTheme.primaryContainer),
          columnSpacing: 16,
          headingTextStyle: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
          dataTextStyle: GoogleFonts.ibmPlexMono(
            fontSize: 11,
            color: AppTheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          columns: const [
            DataColumn(label: Text('Bill No')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Supplier')),
            DataColumn(label: Text('Taxable')),
            DataColumn(label: Text('Rate')),
            DataColumn(label: Text('GST')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Status')),
          ],
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row.asMap().entries.map((entry) {
                    if (entry.key == 7) {
                      return DataCell(_buildStatusText(entry.value));
                    }
                    return DataCell(Text(entry.value));
                  }).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildStatusText(String status) {
    Color color;
    switch (status) {
      case 'PAID':
        color = AppTheme.success;
        break;
      case 'SENT':
        color = const Color(0xFF1565C0);
        break;
      case 'OVERDUE':
        color = AppTheme.error;
        break;
      case 'PARTIAL':
        color = AppTheme.warning;
        break;
      default:
        color = AppTheme.outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  TextStyle _headerStyle() => GoogleFonts.ibmPlexSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppTheme.primary,
  );

  Color _typeColor(String type) {
    switch (type) {
      case 'Receipt':
        return AppTheme.success;
      case 'Invoice':
        return AppTheme.primary;
      case 'Payment':
        return AppTheme.error;
      case 'Expense':
        return AppTheme.warning;
      default:
        return AppTheme.outline;
    }
  }

  String _fmt(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}
