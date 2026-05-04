import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class DashboardQuickActionsWidget extends StatelessWidget {
  const DashboardQuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    final actions = [
      _QuickAction(
        label: 'New Invoice',
        icon: Icons.add_circle_outline_rounded,
        color: AppTheme.primary,
        bgColor: AppTheme.primaryContainer,
        route: AppRoutes.invoiceScreen,
      ),
      _QuickAction(
        label: 'Record Receipt',
        icon: Icons.payments_outlined,
        color: AppTheme.success,
        bgColor: AppTheme.successContainer,
        route: AppRoutes.dashboardScreen,
      ),
      _QuickAction(
        label: 'GST Report',
        icon: Icons.receipt_long_outlined,
        color: AppTheme.gstAccent,
        bgColor: AppTheme.secondaryContainer,
        route: AppRoutes.reportsScreen,
      ),
      _QuickAction(
        label: 'P&L Report',
        icon: Icons.show_chart_rounded,
        color: const Color(0xFF7B1FA2),
        bgColor: const Color(0xFFF3E5F5),
        route: AppRoutes.reportsScreen,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK ACTIONS',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.outline,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: actions.map((action) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: action == actions.last ? 0 : 8,
                  ),
                  child: _QuickActionButton(action: action),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.route,
  });
}

class _QuickActionButton extends StatefulWidget {
  final _QuickAction action;
  const _QuickActionButton({required this.action});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.reverse(),
      onTapUp: (_) {
        _scaleController.forward();
        Navigator.pushNamed(context, widget.action.route);
      },
      onTapCancel: () => _scaleController.forward(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.action.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.action.icon,
                  size: 18,
                  color: widget.action.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.action.label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
