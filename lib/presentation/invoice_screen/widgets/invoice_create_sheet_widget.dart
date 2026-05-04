import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../items_screen/items_screen.dart';

class InvoiceCreateSheetWidget extends StatefulWidget {
  const InvoiceCreateSheetWidget({super.key});

  @override
  State<InvoiceCreateSheetWidget> createState() =>
      _InvoiceCreateSheetWidgetState();
}

class _InvoiceCreateSheetWidgetState extends State<InvoiceCreateSheetWidget> {
  // TODO: Replace with Riverpod/Bloc for production state management
  final _formKey = GlobalKey<FormState>();
  final _partyController = TextEditingController();
  final _invoiceNoController = TextEditingController(text: 'INV-2026-0143');
  final _notesController = TextEditingController();
  String _selectedGstRate = '18%';
  String _selectedInvoiceType = 'Sales';
  bool _isSubmitting = false;
  DateTime _invoiceDate = DateTime(2026, 5, 4);
  DateTime _dueDate = DateTime(2026, 5, 18);

  final List<_LineItem> _lineItems = [
    _LineItem(description: '', qty: 1, rate: 0.0),
  ];

  final List<String> _gstRates = ['0%', '5%', '12%', '18%', '28%'];
  final List<String> _invoiceTypes = ['Sales', 'Purchase'];
  double get _subtotal => _lineItems.fold(0.0, (sum, item) => sum + item.total);
  double get _gstAmount {
    final rate = double.parse(_selectedGstRate.replaceAll('%', '')) / 100;
    return _subtotal * rate;
  }

  double get _grandTotal => _subtotal + _gstAmount;

  @override
  void dispose() {
    _partyController.dispose();
    _invoiceNoController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    // TODO: Replace with local SQLite/Hive database save in production
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isSubmitting = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invoice ${_invoiceNoController.text} created successfully',
            style: GoogleFonts.ibmPlexSans(),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildSheetHeader(),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Invoice Details',
                      icon: Icons.receipt_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTypeSelector()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildGstRateSelector()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildFilledField(
                          controller: _invoiceNoController,
                          label: 'Invoice Number',
                          hint: 'INV-2026-0143',
                          icon: Icons.tag_rounded,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                label: 'Invoice Date',
                                date: _invoiceDate,
                                onTap: () => _pickDate(true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateField(
                                label: 'Due Date',
                                date: _dueDate,
                                onTap: () => _pickDate(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: 'Party',
                      icon: Icons.person_outline_rounded,
                      children: [
                        _buildFilledField(
                          controller: _partyController,
                          label: 'Party Name (Customer / Supplier)',
                          hint: 'e.g. Mehta Textiles Pvt Ltd',
                          icon: Icons.business_outlined,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Party name is required'
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLineItemsCard(),
                    const SizedBox(height: 12),
                    _buildTotalsCard(),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: 'Notes',
                      icon: Icons.notes_rounded,
                      children: [
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          style: GoogleFonts.ibmPlexSans(fontSize: 13),
                          decoration: InputDecoration(
                            hintText:
                                'Payment terms, bank details, or any other notes...',
                            hintStyle: GoogleFonts.ibmPlexSans(
                              fontSize: 12,
                              color: AppTheme.outline,
                            ),
                            filled: true,
                            fillColor: AppTheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSubmitRow(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Create New Invoice',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: AppTheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFilledField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.ibmPlexSans(fontSize: 13, color: AppTheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 16, color: AppTheme.outline),
        labelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          color: AppTheme.outline,
        ),
        filled: true,
        fillColor: AppTheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: AppTheme.outline,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: AppTheme.outline,
                    ),
                  ),
                  Text(
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice Type',
          style: GoogleFonts.ibmPlexSans(fontSize: 11, color: AppTheme.outline),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedInvoiceType,
              isExpanded: true,
              isDense: true,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: AppTheme.onSurface,
              ),
              items: _invoiceTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedInvoiceType = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGstRateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GST Rate',
          style: GoogleFonts.ibmPlexSans(fontSize: 11, color: AppTheme.outline),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGstRate,
              isExpanded: true,
              isDense: true,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: AppTheme.onSurface,
              ),
              items: _gstRates
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedGstRate = v!),
            ),
          ),
        ),
      ],
    );
  }

  // Sample catalog items — in production, load from shared data store
  final List<CatalogItem> _catalogItems = [
    CatalogItem(
      id: '1',
      name: 'Cotton T-Shirt (Round Neck)',
      sku: 'SKU-CTN-001',
      hsnCode: '6109',
      unit: 'Nos',
      taxRate: 5,
      purchasePrice: 180.00,
      salePrice: 350.00,
    ),
    CatalogItem(
      id: '2',
      name: 'Basmati Rice (Premium)',
      sku: 'SKU-RICE-002',
      hsnCode: '1006',
      unit: 'Kg',
      taxRate: 0,
      purchasePrice: 65.00,
      salePrice: 90.00,
    ),
    CatalogItem(
      id: '3',
      name: 'Laptop Bag 15.6"',
      sku: 'SKU-BAG-003',
      hsnCode: '4202',
      unit: 'Nos',
      taxRate: 18,
      purchasePrice: 450.00,
      salePrice: 899.00,
    ),
    CatalogItem(
      id: '4',
      name: 'Stainless Steel Water Bottle',
      sku: 'SKU-BTL-004',
      hsnCode: '7323',
      unit: 'Nos',
      taxRate: 12,
      purchasePrice: 120.00,
      salePrice: 249.00,
    ),
    CatalogItem(
      id: '5',
      name: 'Accounting Software License',
      sku: 'SKU-SFT-005',
      hsnCode: '9983',
      unit: 'Nos',
      taxRate: 18,
      purchasePrice: 2000.00,
      salePrice: 3500.00,
    ),
  ];

  void _pickFromCatalog() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final filtered = searchQuery.isEmpty
              ? _catalogItems
              : _catalogItems
                    .where(
                      (i) =>
                          i.name.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ) ||
                          i.sku.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ) ||
                          i.hsnCode.contains(searchQuery),
                    )
                    .toList();
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.75,
            margin: const EdgeInsets.only(top: 40),
            decoration: const BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 18,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select from Catalog',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    onChanged: (v) => setModalState(() => searchQuery = v),
                    style: GoogleFonts.ibmPlexSans(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: GoogleFonts.ibmPlexSans(
                        fontSize: 13,
                        color: AppTheme.outline,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: AppTheme.outline,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${item.sku} · HSN ${item.hsnCode} · GST ${item.taxRate}%',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppTheme.outline,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${item.salePrice.toStringAsFixed(2)}',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Text(
                                'per ${item.unit}',
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 10,
                                  color: AppTheme.outline,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _lineItems.add(
                                _LineItem(
                                  description: '${item.name} (${item.sku})',
                                  qty: 1,
                                  rate: item.salePrice,
                                ),
                              );
                              // Apply item's GST rate if it's in the supported list
                              final rateStr = '${item.taxRate.toInt()}%';
                              if (_gstRates.contains(rateStr)) {
                                _selectedGstRate = rateStr;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLineItemsCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LINE ITEMS',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _pickFromCatalog,
                    icon: const Icon(Icons.inventory_2_outlined, size: 14),
                    label: Text(
                      'Catalog',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _lineItems.add(
                          _LineItem(description: '', qty: 1, rate: 0.0),
                        );
                      });
                    },
                    icon: const Icon(Icons.add_rounded, size: 14),
                    label: Text(
                      'Manual',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Description',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    'Qty',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    'Rate (₹)',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    'Total',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 28),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ...List.generate(_lineItems.length, (index) {
            return _buildLineItemRow(index);
          }),
        ],
      ),
    );
  }

  Widget _buildLineItemRow(int index) {
    final item = _lineItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              initialValue: item.description,
              onChanged: (v) =>
                  setState(() => _lineItems[index].description = v),
              style: GoogleFonts.ibmPlexSans(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Item / Service',
                hintStyle: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppTheme.outline,
                ),
                filled: true,
                fillColor: AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 48,
            child: TextFormField(
              initialValue: item.qty.toString(),
              onChanged: (v) =>
                  setState(() => _lineItems[index].qty = int.tryParse(v) ?? 1),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexMono(fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 72,
            child: TextFormField(
              initialValue: item.rate == 0.0
                  ? ''
                  : item.rate.toStringAsFixed(0),
              onChanged: (v) => setState(
                () => _lineItems[index].rate = double.tryParse(v) ?? 0.0,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.right,
              style: GoogleFonts.ibmPlexMono(fontSize: 12),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  color: AppTheme.outline,
                ),
                filled: true,
                fillColor: AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 72,
            child: Text(
              '₹${item.total.toStringAsFixed(0)}',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 24,
            child: _lineItems.length > 1
                ? InkWell(
                    onTap: () => setState(() => _lineItems.removeAt(index)),
                    borderRadius: BorderRadius.circular(6),
                    child: const Icon(
                      Icons.remove_circle_outline,
                      size: 18,
                      color: AppTheme.error,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal', _subtotal),
          const SizedBox(height: 6),
          _buildTotalRow('GST ($_selectedGstRate)', _gstAmount, isGst: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppTheme.primary, thickness: 0.5),
          ),
          _buildTotalRow('Grand Total', _grandTotal, isGrandTotal: true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isGst = false,
    bool isGrandTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: isGrandTotal ? 14 : 13,
            fontWeight: isGrandTotal ? FontWeight.w700 : FontWeight.w400,
            color: isGrandTotal ? AppTheme.primary : AppTheme.onSurface,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: GoogleFonts.ibmPlexMono(
            fontSize: isGrandTotal ? 16 : 13,
            fontWeight: isGrandTotal ? FontWeight.w700 : FontWeight.w500,
            color: isGst
                ? AppTheme.gstAccent
                : (isGrandTotal ? AppTheme.primary : AppTheme.onSurface),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 16),
            label: Text(
              'Cancel',
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.outline,
              side: const BorderSide(color: AppTheme.outlineVariant),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: _isSubmitting ? null : _submitInvoice,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_rounded, size: 16),
            label: Text(
              _isSubmitting ? 'Saving...' : 'Save Invoice',
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(bool isInvoiceDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _invoiceDate : _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isInvoiceDate) {
          _invoiceDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }
}

class _LineItem {
  String description;
  int qty;
  double rate;

  _LineItem({required this.description, required this.qty, required this.rate});

  double get total => qty * rate;
}
