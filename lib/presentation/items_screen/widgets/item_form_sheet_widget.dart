import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../items_screen.dart';

class ItemFormSheetWidget extends StatefulWidget {
  final CatalogItem? existingItem;
  final void Function(CatalogItem item) onSave;

  const ItemFormSheetWidget({
    super.key,
    this.existingItem,
    required this.onSave,
  });

  @override
  State<ItemFormSheetWidget> createState() => _ItemFormSheetWidgetState();
}

class _ItemFormSheetWidgetState extends State<ItemFormSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _hsnCtrl;
  late final TextEditingController _purchasePriceCtrl;
  late final TextEditingController _salePriceCtrl;
  late final TextEditingController _descCtrl;

  String _selectedUnit = 'Nos';
  double _taxRate = 18.0;

  final List<String> _units = [
    'Nos',
    'Kg',
    'Gm',
    'Ltr',
    'Mtr',
    'Cm',
    'Box',
    'Pcs',
    'Doz',
    'Set',
    'Pair',
  ];
  final List<double> _taxRates = [
    0,
    0.1,
    0.25,
    1,
    1.5,
    3,
    5,
    6,
    7.5,
    12,
    18,
    28,
  ];

  bool get _isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existingItem;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _skuCtrl = TextEditingController(text: e?.sku ?? '');
    _hsnCtrl = TextEditingController(text: e?.hsnCode ?? '');
    _purchasePriceCtrl = TextEditingController(
      text: e != null ? e.purchasePrice.toStringAsFixed(2) : '',
    );
    _salePriceCtrl = TextEditingController(
      text: e != null ? e.salePrice.toStringAsFixed(2) : '',
    );
    _descCtrl = TextEditingController(text: e?.description ?? '');
    if (e != null) {
      _selectedUnit = e.unit;
      _taxRate = e.taxRate;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _hsnCtrl.dispose();
    _purchasePriceCtrl.dispose();
    _salePriceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final item = CatalogItem(
      id:
          widget.existingItem?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      hsnCode: _hsnCtrl.text.trim(),
      unit: _selectedUnit,
      taxRate: _taxRate,
      purchasePrice: double.tryParse(_purchasePriceCtrl.text) ?? 0.0,
      salePrice: double.tryParse(_salePriceCtrl.text) ?? 0.0,
      description: _descCtrl.text.trim(),
    );
    widget.onSave(item);
    Navigator.pop(context);
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
          _buildHeader(),
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
                      title: 'Item Details',
                      icon: Icons.inventory_2_outlined,
                      children: [
                        _buildField(
                          controller: _nameCtrl,
                          label: 'Item Name',
                          hint: 'e.g. Cotton T-Shirt',
                          icon: Icons.label_outline_rounded,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Item name is required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                controller: _skuCtrl,
                                label: 'SKU Code',
                                hint: 'e.g. SKU-001',
                                icon: Icons.qr_code_2_rounded,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildField(
                                controller: _hsnCtrl,
                                label: 'HSN Code',
                                hint: 'e.g. 6109',
                                icon: Icons.qr_code_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: _descCtrl,
                          label: 'Description (optional)',
                          hint: 'Brief description of the item',
                          icon: Icons.notes_rounded,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: 'Unit & Tax',
                      icon: Icons.calculate_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildUnitDropdown()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTaxRateDropdown()),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: 'Pricing',
                      icon: Icons.currency_rupee_rounded,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                controller: _purchasePriceCtrl,
                                label: 'Purchase Price (₹)',
                                hint: '0.00',
                                icon: Icons.arrow_downward_rounded,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  if (double.tryParse(v) == null) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildField(
                                controller: _salePriceCtrl,
                                label: 'Sale Price (₹)',
                                hint: '0.00',
                                icon: Icons.arrow_upward_rounded,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  if (double.tryParse(v) == null) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _save,
                            icon: Icon(
                              _isEditing
                                  ? Icons.save_rounded
                                  : Icons.add_rounded,
                              size: 16,
                            ),
                            label: Text(
                              _isEditing ? 'Update Item' : 'Add Item',
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              Icons.inventory_2_outlined,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditing ? 'Edit Item' : 'Add New Item',
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
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

  Widget _buildUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit of Measure',
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
              value: _selectedUnit,
              isExpanded: true,
              isDense: true,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: AppTheme.onSurface,
              ),
              items: _units
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedUnit = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaxRateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GST Tax Rate (%)',
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
            child: DropdownButton<double>(
              value: _taxRate,
              isExpanded: true,
              isDense: true,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: AppTheme.onSurface,
              ),
              items: _taxRates
                  .map((r) => DropdownMenuItem(value: r, child: Text('$r%')))
                  .toList(),
              onChanged: (v) => setState(() => _taxRate = v!),
            ),
          ),
        ),
      ],
    );
  }
}
