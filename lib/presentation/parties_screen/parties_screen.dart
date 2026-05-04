import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/party_list_item_widget.dart';
import './widgets/party_form_sheet_widget.dart';

class Party {
  final String id;
  final String name;
  final String partyType; // 'Creditor' or 'Debtor'
  final String phone;
  final String email;
  final String address;
  final String gstNumber;
  final bool isGstRegistered;
  final double openingBalance;
  final String balanceType; // 'Dr' or 'Cr'

  Party({
    required this.id,
    required this.name,
    required this.partyType,
    this.phone = '',
    this.email = '',
    this.address = '',
    this.gstNumber = '',
    this.isGstRegistered = false,
    this.openingBalance = 0.0,
    this.balanceType = 'Dr',
  });

  Party copyWith({
    String? id,
    String? name,
    String? partyType,
    String? phone,
    String? email,
    String? address,
    String? gstNumber,
    bool? isGstRegistered,
    double? openingBalance,
    String? balanceType,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      partyType: partyType ?? this.partyType,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      isGstRegistered: isGstRegistered ?? this.isGstRegistered,
      openingBalance: openingBalance ?? this.openingBalance,
      balanceType: balanceType ?? this.balanceType,
    );
  }
}

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({super.key});

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Party> _parties = [
    Party(
      id: '1',
      name: 'Sharma Traders',
      partyType: 'Creditor',
      phone: '9876543210',
      email: 'sharma@traders.com',
      address: '12, MG Road, Mumbai - 400001',
      gstNumber: '27AABCS1429B1ZB',
      isGstRegistered: true,
      openingBalance: 45000.0,
      balanceType: 'Cr',
    ),
    Party(
      id: '2',
      name: 'Patel Enterprises',
      partyType: 'Debtor',
      phone: '9123456780',
      email: 'patel@enterprises.in',
      address: '5, Ring Road, Ahmedabad - 380001',
      gstNumber: '24AAACR5055K1ZF',
      isGstRegistered: true,
      openingBalance: 32000.0,
      balanceType: 'Dr',
    ),
    Party(
      id: '3',
      name: 'Gupta Wholesale',
      partyType: 'Creditor',
      phone: '9988776655',
      email: '',
      address: '8, Chandni Chowk, Delhi - 110006',
      gstNumber: '',
      isGstRegistered: false,
      openingBalance: 18500.0,
      balanceType: 'Cr',
    ),
    Party(
      id: '4',
      name: 'Mehta & Sons',
      partyType: 'Debtor',
      phone: '9012345678',
      email: 'mehta.sons@gmail.com',
      address: '22, Brigade Road, Bengaluru - 560001',
      gstNumber: '29AABCM1234D1ZA',
      isGstRegistered: true,
      openingBalance: 67800.0,
      balanceType: 'Dr',
    ),
    Party(
      id: '5',
      name: 'Joshi Distributors',
      partyType: 'Debtor',
      phone: '9765432109',
      email: 'joshi.dist@yahoo.com',
      address: '3, FC Road, Pune - 411004',
      gstNumber: '',
      isGstRegistered: false,
      openingBalance: 12000.0,
      balanceType: 'Dr',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Party> get _filteredParties {
    List<Party> list = _parties;
    if (_tabController.index == 1) {
      list = list.where((p) => p.partyType == 'Creditor').toList();
    } else if (_tabController.index == 2) {
      list = list.where((p) => p.partyType == 'Debtor').toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.phone.contains(_searchQuery) ||
                p.gstNumber.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return list;
  }

  void _openAddParty() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PartyFormSheetWidget(
        onSave: (party) {
          setState(() {
            _parties.add(
              party.copyWith(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
              ),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${party.name} added successfully'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openEditParty(Party party) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PartyFormSheetWidget(
        existingParty: party,
        onSave: (updated) {
          setState(() {
            final idx = _parties.indexWhere((p) => p.id == party.id);
            if (idx != -1) _parties[idx] = updated.copyWith(id: party.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${updated.name} updated successfully'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _deleteParty(Party party) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Party',
          style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${party.name}"? This action cannot be undone.',
          style: GoogleFonts.ibmPlexSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _parties.removeWhere((p) => p.id == party.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${party.name} deleted'),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainShell(
      currentIndex: 3,
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(child: _buildPartyList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final creditorCount = _parties
        .where((p) => p.partyType == 'Creditor')
        .length;
    final debtorCount = _parties.where((p) => p.partyType == 'Debtor').length;

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parties',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$creditorCount Creditors · $debtorCount Debtors',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: _openAddParty,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Party'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.ibmPlexSans(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name, phone or GST...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.surface,
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.outline,
        indicatorColor: AppTheme.primary,
        indicatorWeight: 2.5,
        labelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Creditors'),
          Tab(text: 'Debtors'),
        ],
      ),
    );
  }

  Widget _buildPartyList() {
    final parties = _filteredParties;
    if (parties.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people_outline_rounded,
        title: _searchQuery.isNotEmpty ? 'No results found' : 'No parties yet',
        description: _searchQuery.isNotEmpty
            ? 'Try a different search term'
            : 'Tap "Add Party" to create your first creditor or debtor',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: parties.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => PartyListItemWidget(
        party: parties[i],
        onEdit: () => _openEditParty(parties[i]),
        onDelete: () => _deleteParty(parties[i]),
      ),
    );
  }
}
