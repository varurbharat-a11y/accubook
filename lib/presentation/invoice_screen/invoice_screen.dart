import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_badge_widget.dart';
import './widgets/invoice_create_sheet_widget.dart';
import './widgets/invoice_filter_bar_widget.dart';
import './widgets/invoice_list_item_widget.dart';
import './widgets/invoice_summary_strip_widget.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production state management
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late AnimationController _fabAnimController;

  static final List<Map<String, dynamic>> _invoiceMaps = [
    {
      'id': 'INV-2026-0142',
      'party': 'Mehta Textiles Pvt Ltd',
      'initials': 'MT',
      'colorHex': 0xFF3949AB,
      'amount': 18450.0,
      'gst': 3321.0,
      'gstRate': '18%',
      'date': '04 May 2026',
      'dueDate': '18 May 2026',
      'status': 'sent',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0141',
      'party': 'Sharma & Sons Traders',
      'initials': 'SS',
      'colorHex': 0xFF2E7D32,
      'amount': 9820.0,
      'gst': 1767.6,
      'gstRate': '18%',
      'date': '03 May 2026',
      'dueDate': '17 May 2026',
      'status': 'paid',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0140',
      'party': 'Global Pharma Distributors',
      'initials': 'GP',
      'colorHex': 0xFF00838F,
      'amount': 62400.0,
      'gst': 7488.0,
      'gstRate': '12%',
      'date': '02 May 2026',
      'dueDate': '16 May 2026',
      'status': 'sent',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0139',
      'party': 'Nair Electronics Hub',
      'initials': 'NE',
      'colorHex': 0xFF7B1FA2,
      'amount': 14200.0,
      'gst': 2556.0,
      'gstRate': '18%',
      'date': '01 May 2026',
      'dueDate': '15 May 2026',
      'status': 'draft',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0138',
      'party': 'Patel Engineering Works',
      'initials': 'PE',
      'colorHex': 0xFFC62828,
      'amount': 34200.0,
      'gst': 6156.0,
      'gstRate': '18%',
      'date': '28 Apr 2026',
      'dueDate': '28 Apr 2026',
      'status': 'overdue',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0137',
      'party': 'Sundarajan Constructions',
      'initials': 'SC',
      'colorHex': 0xFFE65100,
      'amount': 88000.0,
      'gst': 15840.0,
      'gstRate': '18%',
      'date': '26 Apr 2026',
      'dueDate': '10 May 2026',
      'status': 'partiallyPaid',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0136',
      'party': 'Krishnamurthy Exports',
      'initials': 'KE',
      'colorHex': 0xFF1565C0,
      'amount': 52100.0,
      'gst': 9378.0,
      'gstRate': '18%',
      'date': '25 Apr 2026',
      'dueDate': '09 May 2026',
      'status': 'partiallyPaid',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0135',
      'party': 'Iyer Auto Components',
      'initials': 'IA',
      'colorHex': 0xFF37474F,
      'amount': 21600.0,
      'gst': 3888.0,
      'gstRate': '18%',
      'date': '23 Apr 2026',
      'dueDate': '07 May 2026',
      'status': 'paid',
      'invoiceType': 'Sales',
    },
    {
      'id': 'INV-2026-0134',
      'party': 'Reddy Construction Co',
      'initials': 'RC',
      'colorHex': 0xFF546E7A,
      'amount': 7650.0,
      'gst': 1377.0,
      'gstRate': '18%',
      'date': '22 Apr 2026',
      'dueDate': '06 May 2026',
      'status': 'draft',
      'invoiceType': 'Sales',
    },
    {
      'id': 'PUR-2026-0089',
      'party': 'Rajan Raw Materials Ltd',
      'initials': 'RR',
      'colorHex': 0xFF4527A0,
      'amount': 43800.0,
      'gst': 7884.0,
      'gstRate': '18%',
      'date': '01 May 2026',
      'dueDate': '15 May 2026',
      'status': 'sent',
      'invoiceType': 'Purchase',
    },
    {
      'id': 'INV-2026-0133',
      'party': 'Bansal Chemicals Pvt',
      'initials': 'BC',
      'colorHex': 0xFF558B2F,
      'amount': 16400.0,
      'gst': 1968.0,
      'gstRate': '12%',
      'date': '20 Apr 2026',
      'dueDate': '04 May 2026',
      'status': 'cancelled',
      'invoiceType': 'Sales',
    },
  ];

  List<Map<String, dynamic>> get _filteredInvoices {
    return _invoiceMaps.where((inv) {
      final matchesFilter =
          _selectedFilter == 'All' ||
          inv['status'] == _selectedFilter.toLowerCase() ||
          (_selectedFilter == 'Overdue' && inv['status'] == 'overdue') ||
          (_selectedFilter == 'Partial' && inv['status'] == 'partiallyPaid');
      final matchesSearch =
          _searchQuery.isEmpty ||
          (inv['party'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (inv['id'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  void _showCreateInvoiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InvoiceCreateSheetWidget(),
    );
  }

  void _deleteInvoice(String id) {
    // TODO: Replace with local database delete in production
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice $id deleted', style: GoogleFonts.ibmPlexSans()),
        backgroundColor: AppTheme.onSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppTheme.primaryLight,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return MainShell(
      currentIndex: 1,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: Column(
            children: [
              _buildAppBar(context),
              InvoiceSummaryStripWidget(invoices: _invoiceMaps),
              InvoiceFilterBarWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: (f) => setState(() => _selectedFilter = f),
              ),
              Expanded(
                child: _filteredInvoices.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.receipt_long_outlined,
                        title: 'No invoices found',
                        description: _searchQuery.isNotEmpty
                            ? 'No results for "$_searchQuery". Try a different search term.'
                            : 'Create your first invoice to start tracking sales and receivables.',
                        actionLabel: 'Create Invoice',
                        onAction: _showCreateInvoiceSheet,
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollStartNotification) {
                            _fabAnimController.reverse();
                          } else if (notification is ScrollEndNotification) {
                            _fabAnimController.forward();
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 600),
                            );
                          },
                          color: AppTheme.primary,
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              isTablet ? 16 : 0,
                              8,
                              isTablet ? 16 : 0,
                              88,
                            ),
                            itemCount: _filteredInvoices.length,
                            itemBuilder: (context, index) {
                              final inv = _filteredInvoices[index];
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(
                                  milliseconds: 200 + index * 40,
                                ),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                ),
                                child: InvoiceListItemWidget(
                                  invoice: inv,
                                  onDelete: () =>
                                      _deleteInvoice(inv['id'] as String),
                                  onTap: () => _showInvoiceDetail(context, inv),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: AnimatedBuilder(
            animation: _fabAnimController,
            builder: (context, child) =>
                Transform.scale(scale: _fabAnimController.value, child: child),
            child: FloatingActionButton.extended(
              onPressed: _showCreateInvoiceSheet,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'New Invoice',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(
        _isSearchActive ? 8 : 16,
        12,
        _isSearchActive ? 8 : 12,
        12,
      ),
      child: Row(
        children: [
          if (!_isSearchActive) ...[
            Expanded(
              child: Text(
                'Invoices',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() => _isSearchActive = true);
                _searchFocus.requestFocus();
              },
              icon: const Icon(Icons.search_rounded, color: AppTheme.onSurface),
            ),
            IconButton(
              onPressed: () => _showFilterSheet(context),
              icon: const Icon(Icons.tune_rounded, color: AppTheme.onSurface),
            ),
          ] else ...[
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
                    color: AppTheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by party, invoice no...',
                    hintStyle: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      color: AppTheme.outline,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppTheme.outline,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSearchActive = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.ibmPlexSans(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              'Date (Newest)',
              'Date (Oldest)',
              'Amount (High to Low)',
              'Amount (Low to High)',
              'Party Name',
            ].map(
              (opt) => ListTile(
                title: Text(opt, style: GoogleFonts.ibmPlexSans(fontSize: 13)),
                leading: const Icon(Icons.radio_button_unchecked, size: 20),
                contentPadding: EdgeInsets.zero,
                onTap: () => Navigator.pop(ctx),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetail(BuildContext context, Map<String, dynamic> inv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InvoiceDetailSheet(invoice: inv),
    );
  }
}

class _InvoiceDetailSheet extends StatelessWidget {
  final Map<String, dynamic> invoice;
  const _InvoiceDetailSheet({required this.invoice});

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

    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice['id'] as String,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StatusBadgeWidget(status: status, fontSize: 11),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(
                            invoice['colorHex'] as int,
                          ).withAlpha(31),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            invoice['initials'] as String,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(invoice['colorHex'] as int),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Party', invoice['party'] as String),
                  _buildDetailRow('Invoice Date', invoice['date'] as String),
                  _buildDetailRow('Due Date', invoice['dueDate'] as String),
                  _buildDetailRow(
                    'Invoice Type',
                    invoice['invoiceType'] as String,
                  ),
                  const Divider(height: 28),
                  _buildAmountRow(
                    'Subtotal',
                    (invoice['amount'] as double) - (invoice['gst'] as double),
                  ),
                  _buildAmountRow(
                    'GST (${invoice['gstRate']})',
                    invoice['gst'] as double,
                  ),
                  const Divider(height: 16),
                  _buildAmountRow(
                    'Total Amount',
                    invoice['amount'] as double,
                    isTotal: true,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 16,
                          ),
                          label: Text(
                            'PDF',
                            style: GoogleFonts.ibmPlexSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.print_outlined, size: 16),
                          label: Text(
                            'Print',
                            style: GoogleFonts.ibmPlexSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.onSurface,
                            side: const BorderSide(
                              color: AppTheme.outlineVariant,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.payments_outlined, size: 16),
                          label: Text(
                            status == InvoiceStatus.paid ? 'Paid' : 'Mark Paid',
                            style: GoogleFonts.ibmPlexSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: status == InvoiceStatus.paid
                                ? AppTheme.success
                                : AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                color: AppTheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal ? AppTheme.onSurface : AppTheme.outline,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: GoogleFonts.ibmPlexMono(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppTheme.primary : AppTheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
