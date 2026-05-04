import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../parties_screen.dart';

class PartyFormSheetWidget extends StatefulWidget {
  final Party? existingParty;
  final Function(Party) onSave;

  const PartyFormSheetWidget({
    super.key,
    this.existingParty,
    required this.onSave,
  });

  @override
  State<PartyFormSheetWidget> createState() => _PartyFormSheetWidgetState();
}

class _PartyFormSheetWidgetState extends State<PartyFormSheetWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _gstCtrl;
  late TextEditingController _balanceCtrl;

  String _partyType = 'Debtor';
  bool _isGstRegistered = false;
  String _balanceType = 'Dr';

  bool get _isEditing => widget.existingParty != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingParty;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _phoneCtrl = TextEditingController(text: p?.phone ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
    _addressCtrl = TextEditingController(text: p?.address ?? '');
    _gstCtrl = TextEditingController(text: p?.gstNumber ?? '');
    _balanceCtrl = TextEditingController(
      text: p != null && p.openingBalance > 0
          ? p.openingBalance.toStringAsFixed(2)
          : '',
    );
    _partyType = p?.partyType ?? 'Debtor';
    _isGstRegistered = p?.isGstRegistered ?? false;
    _balanceType = p?.balanceType ?? 'Dr';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _gstCtrl.dispose();
    _balanceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final party = Party(
      id: '',
      name: _nameCtrl.text.trim(),
      partyType: _partyType,
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      gstNumber: _isGstRegistered ? _gstCtrl.text.trim().toUpperCase() : '',
      isGstRegistered: _isGstRegistered,
      openingBalance: double.tryParse(_balanceCtrl.text) ?? 0.0,
      balanceType: _balanceType,
    );
    Navigator.pop(context);
    widget.onSave(party);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? 'Edit Party' : 'Add New Party',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.surfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Party Type
              _sectionLabel('Party Type'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _typeChip(
                      label: 'Debtor',
                      subtitle: 'Owes you money',
                      icon: Icons.arrow_downward_rounded,
                      color: AppTheme.success,
                      container: AppTheme.successContainer,
                      selected: _partyType == 'Debtor',
                      onTap: () => setState(() => _partyType = 'Debtor'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _typeChip(
                      label: 'Creditor',
                      subtitle: 'You owe money',
                      icon: Icons.arrow_upward_rounded,
                      color: AppTheme.error,
                      container: AppTheme.errorContainer,
                      selected: _partyType == 'Creditor',
                      onTap: () => setState(() => _partyType = 'Creditor'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Name
              _sectionLabel('Party Name *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.ibmPlexSans(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g. Sharma Traders',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 14),

              // Phone
              _sectionLabel('Phone Number'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                style: GoogleFonts.ibmPlexSans(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '10-digit mobile number',
                  prefixIcon: Icon(Icons.phone_outlined, size: 18),
                  counterText: '',
                ),
                validator: (v) {
                  if (v != null && v.isNotEmpty && v.length != 10) {
                    return 'Enter a valid 10-digit number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Email
              _sectionLabel('Email Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.ibmPlexSans(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g. contact@business.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 18),
                ),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Address
              _sectionLabel('Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressCtrl,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.ibmPlexSans(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Street, City, PIN',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Icon(Icons.location_on_outlined, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // GST Section
              _sectionLabel('GST Registration'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _isGstRegistered,
                      onChanged: (v) => setState(() => _isGstRegistered = v),
                      title: Text(
                        'GST Registered Party',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Enable to enter GSTIN number',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          color: AppTheme.outline,
                        ),
                      ),
                      activeThumbColor: AppTheme.primary,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                    ),
                    if (_isGstRegistered) ...[
                      const Divider(height: 1, color: AppTheme.outlineVariant),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                        child: TextFormField(
                          controller: _gstCtrl,
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 15,
                          style: GoogleFonts.ibmPlexMono(fontSize: 14),
                          decoration: const InputDecoration(
                            labelText: 'GSTIN Number',
                            hintText: '22AAAAA0000A1Z5',
                            prefixIcon: Icon(Icons.receipt_outlined, size: 18),
                            counterText: '',
                          ),
                          validator: (v) {
                            if (_isGstRegistered) {
                              if (v == null || v.trim().isEmpty) {
                                return 'GSTIN is required';
                              }
                              if (v.trim().length != 15) {
                                return 'GSTIN must be 15 characters';
                              }
                              final gstRegex = RegExp(
                                r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                              );
                              if (!gstRegex.hasMatch(v.trim().toUpperCase())) {
                                return 'Enter a valid GSTIN format';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Opening Balance
              _sectionLabel('Opening Balance'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _balanceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: GoogleFonts.ibmPlexSans(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        prefixIcon: Icon(
                          Icons.currency_rupee_rounded,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        _balanceTypeBtn('Dr', 'Debit'),
                        _balanceTypeBtn('Cr', 'Credit'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Update Party' : 'Save Party',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.ibmPlexSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.outline,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _typeChip({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color container,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? container : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : AppTheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? color : AppTheme.outline),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? color : AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: selected ? color : AppTheme.outline,
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

  Widget _balanceTypeBtn(String type, String label) {
    final selected = _balanceType == type;
    return GestureDetector(
      onTap: () => setState(() => _balanceType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          type,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.outline,
          ),
        ),
      ),
    );
  }
}
