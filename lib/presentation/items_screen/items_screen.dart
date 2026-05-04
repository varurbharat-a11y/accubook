import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/item_list_item_widget.dart';
import './widgets/item_form_sheet_widget.dart';

class CatalogItem {
  final String id;
  final String name;
  final String sku;
  final String hsnCode;
  final String unit;
  final double taxRate;
  final double purchasePrice;
  final double salePrice;
  final String description;

  CatalogItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.hsnCode,
    required this.unit,
    required this.taxRate,
    required this.purchasePrice,
    required this.salePrice,
    this.description = '',
  });

  CatalogItem copyWith({
    String? id,
    String? name,
    String? sku,
    String? hsnCode,
    String? unit,
    double? taxRate,
    double? purchasePrice,
    double? salePrice,
    String? description,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      hsnCode: hsnCode ?? this.hsnCode,
      unit: unit ?? this.unit,
      taxRate: taxRate ?? this.taxRate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      description: description ?? this.description,
    );
  }
}

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<CatalogItem> _items = [
    CatalogItem(
      id: '1',
      name: 'Cotton T-Shirt (Round Neck)',
      sku: 'SKU-CTN-001',
      hsnCode: '6109',
      unit: 'Nos',
      taxRate: 5,
      purchasePrice: 180.00,
      salePrice: 350.00,
      description: 'Premium cotton round neck t-shirt',
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
      description: 'Long grain premium basmati rice',
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
      description: 'Water resistant laptop bag with multiple compartments',
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
      description: '1 litre insulated stainless steel bottle',
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
      description: 'Annual subscription for accounting software',
    ),
  ];

  List<CatalogItem> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items
        .where(
          (item) =>
              item.name.toLowerCase().contains(q) ||
              item.sku.toLowerCase().contains(q) ||
              item.hsnCode.contains(q) ||
              item.description.toLowerCase().contains(q),
        )
        .toList();
  }

  void _openAddItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemFormSheetWidget(
        onSave: (item) {
          setState(() => _items.add(item));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.name} added to catalog'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openEditItem(CatalogItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemFormSheetWidget(
        existingItem: item,
        onSave: (updated) {
          setState(() {
            final idx = _items.indexWhere((i) => i.id == item.id);
            if (idx != -1) _items[idx] = updated;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${updated.name} updated'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _deleteItem(CatalogItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Item',
          style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${item.name}"? This action cannot be undone.',
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
              setState(() => _items.removeWhere((i) => i.id == item.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} deleted'),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;
    return MainShell(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.surface,
          elevation: 0,
          title: Text(
            'Item Catalog',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.icon(
                onPressed: _openAddItem,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Add Item',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSummaryStrip(),
            _buildSearchBar(),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.inventory_2_outlined,
                      title: _searchQuery.isEmpty
                          ? 'No items yet'
                          : 'No results found',
                      description: _searchQuery.isEmpty
                          ? 'Add your first item to the catalog'
                          : 'Try a different search term',
                      actionLabel: _searchQuery.isEmpty ? 'Add Item' : null,
                      onAction: _searchQuery.isEmpty ? _openAddItem : null,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => ItemListItemWidget(
                        item: filtered[i],
                        onEdit: () => _openEditItem(filtered[i]),
                        onDelete: () => _deleteItem(filtered[i]),
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddItem,
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Widget _buildSummaryStrip() {
    final totalItems = _items.length;
    final avgSalePrice = totalItems > 0
        ? _items.fold(0.0, (s, i) => s + i.salePrice) / totalItems
        : 0.0;
    final avgMargin = totalItems > 0
        ? _items.fold(0.0, (s, i) {
                final margin = i.salePrice > 0
                    ? ((i.salePrice - i.purchasePrice) / i.salePrice) * 100
                    : 0.0;
                return s + margin;
              }) /
              totalItems
        : 0.0;

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildStatChip(
            Icons.inventory_2_outlined,
            '$totalItems',
            'Items',
            AppTheme.primary,
          ),
          const SizedBox(width: 8),
          _buildStatChip(
            Icons.currency_rupee_rounded,
            '₹${avgSalePrice.toStringAsFixed(0)}',
            'Avg Sale',
            AppTheme.secondary,
          ),
          const SizedBox(width: 8),
          _buildStatChip(
            Icons.trending_up_rounded,
            '${avgMargin.toStringAsFixed(1)}%',
            'Avg Margin',
            AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: color.withAlpha(180),
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

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.ibmPlexSans(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search by name, SKU, or HSN code...',
          hintStyle: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            color: AppTheme.outline,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 18,
            color: AppTheme.outline,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 16,
                    color: AppTheme.outline,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
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
    );
  }
}