import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'result_screen.dart';

// ─────────────────────────────────────────────
// Purchase Type Enum
// ─────────────────────────────────────────────

enum PurchaseType { online, offline }

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen>
    with TickerProviderStateMixin {

  // ── Form ──
  final _formKey = GlobalKey<FormState>();

  // Online fields
  final _urlController = TextEditingController();

  // Offline fields
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();

  // Shared
  final _notesController = TextEditingController();

  // Focus nodes
  final _urlFocus = FocusNode();
  final _itemNameFocus = FocusNode();
  final _itemPriceFocus = FocusNode();
  final _notesFocus = FocusNode();

  // ── State ──
  PurchaseType _purchaseType = PurchaseType.online;
  bool _isLoading = false;
  String _selectedCategory = 'Electronics';

  // ── Categories ──
  final List<Map<String, dynamic>> _categories = [
    {'label': 'Electronics', 'icon': Icons.devices_rounded},
    {'label': 'Fashion', 'icon': Icons.checkroom_rounded},
    {'label': 'Grocery', 'icon': Icons.shopping_basket_rounded},
    {'label': 'Home', 'icon': Icons.home_rounded},
    {'label': 'Beauty', 'icon': Icons.face_retouching_natural_rounded},
    {'label': 'Sports', 'icon': Icons.sports_soccer_rounded},
    {'label': 'Books', 'icon': Icons.menu_book_rounded},
    {'label': 'Other', 'icon': Icons.more_horiz_rounded},
  ];

  // ── Mock financial data ──
  // In a real app these come from a state manager / service
  final double _monthlySalary = 65000;
  final double _spendingLimit = 20000;
  final double _savingsGoal = 15000;
  final double _totalSpent = 8450;

  // ── Animation Controllers ──
  late AnimationController _entranceController;
  late AnimationController _typeController;
  late AnimationController _formController;
  late AnimationController _orbController;

  // ── Entrance ──
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _typeSelectorOpacity;
  late Animation<Offset> _typeSelectorSlide;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _ctaOpacity;
  late Animation<Offset> _ctaSlide;

  // ── Type Switch ──
  late Animation<double> _typeFormOpacity;
  late Animation<Offset> _typeFormSlide;

  // ── Orbs ──
  late Animation<double> _orbAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _playEntrance();
  }

  void _setupAnimations() {
    // ── Entrance controller ──
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    ));

    _typeSelectorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _typeSelectorSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.65, curve: Curves.easeOutCubic),
    ));

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.80, curve: Curves.easeOut),
      ),
    );
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.4, 0.85, curve: Curves.easeOutCubic),
    ));

    _ctaOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
    ));

    // ── Type switch animation ──
    _typeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _typeFormOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typeController, curve: Curves.easeOut),
    );
    _typeFormSlide = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _typeController,
      curve: Curves.easeOutCubic,
    ));

    // ── Form panel controller (unused — shares typeController) ──
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // ── Orbs ──
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _orbAnim = CurvedAnimation(
      parent: _orbController,
      curve: Curves.easeInOut,
    );
  }

  void _playEntrance() async {
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;
    _entranceController.forward();
    _typeController.forward();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _notesController.dispose();
    _urlFocus.dispose();
    _itemNameFocus.dispose();
    _itemPriceFocus.dispose();
    _notesFocus.dispose();
    _entranceController.dispose();
    _typeController.dispose();
    _formController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  // ── Switch purchase type ──
  Future<void> _switchType(PurchaseType type) async {
    if (_purchaseType == type) return;
    HapticFeedback.selectionClick();

    await _typeController.reverse();
    setState(() {
      _purchaseType = type;
      _formKey.currentState?.reset();
      _urlController.clear();
      _itemNameController.clear();
      _itemPriceController.clear();
    });
    _typeController.forward();
  }

  // ── Extract product name from URL ──
  String _extractProductName(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.pathSegments;
      for (final segment in path) {
        final cleaned = segment
            .replaceAll('-', ' ')
            .replaceAll('_', ' ')
            .replaceAll(RegExp(r'[^\w\s]'), '')
            .trim();
        if (cleaned.length > 8 && !RegExp(r'^\d+$').hasMatch(cleaned)) {
          return cleaned
              .split(' ')
              .map((w) => w.isEmpty
              ? ''
              : '${w[0].toUpperCase()}${w.substring(1)}')
              .join(' ');
        }
      }
    } catch (_) {}
    return 'Online Product';
  }

  // ── Detect platform ──
  String _detectPlatform(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('amazon')) return 'Amazon';
    if (lower.contains('flipkart')) return 'Flipkart';
    if (lower.contains('myntra')) return 'Myntra';
    if (lower.contains('meesho')) return 'Meesho';
    if (lower.contains('snapdeal')) return 'Snapdeal';
    if (lower.contains('nykaa')) return 'Nykaa';
    if (lower.contains('ajio')) return 'AJIO';
    if (lower.contains('tatacliq')) return 'Tata CLiQ';
    if (lower.contains('jiomart')) return 'JioMart';
    return 'Other';
  }

  // ── Submit ──
  Future<void> _handleCheck() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      HapticFeedback.mediumImpact();
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Build purchase data map
    final String productName;
    final double productPrice;
    final String platform;

    if (_purchaseType == PurchaseType.online) {
      productName = _extractProductName(_urlController.text.trim());
      // For demo — real app would scrape or use an API
      productPrice = 2499.0;
      platform = _detectPlatform(_urlController.text.trim());
    } else {
      productName = _itemNameController.text.trim();
      productPrice =
          double.tryParse(_itemPriceController.text.trim()) ?? 0.0;
      platform = 'Offline Store';
    }

    // Navigate to result
    if (!mounted) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultScreen(
          productName: productName,
          productPrice: productPrice,
          platform: platform,
          purchaseType: _purchaseType == PurchaseType.online
              ? 'Online'
              : 'Offline',
          category: _selectedCategory,
          monthlySalary: _monthlySalary,
          spendingLimit: _spendingLimit,
          savingsGoal: _savingsGoal,
          totalSpent: _totalSpent,
          productUrl: _purchaseType == PurchaseType.online
              ? _urlController.text.trim()
              : null,
          notes: _notesController.text.trim(),
        ),
        transitionDuration: const Duration(milliseconds: 550),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                    curve: Curves.easeOutCubic, parent: anim),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
      isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: Stack(
        children: [
          _buildBackground(isDark),
          _buildOrbs(isDark, size),
          _buildContent(isDark),
        ],
      ),
    );
  }

  // ── Background ──
  Widget _buildBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const RadialGradient(
          center: Alignment(0.0, -0.6),
          radius: 0.85,
          colors: [Color(0xFF130B2E), AppTheme.darkBackground],
        )
            : const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0EFFE), AppTheme.lightBackground],
        ),
      ),
    );
  }

  // ── Orbs ──
  Widget _buildOrbs(bool isDark, Size size) {
    return AnimatedBuilder(
      animation: _orbAnim,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -50,
            left: -40,
            child: Transform.translate(
              offset: Offset(0, _orbAnim.value * 20),
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: -50,
            child: Transform.translate(
              offset: Offset(0, -_orbAnim.value * 16),
              child: Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentColor.withOpacity(0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Main Content ──
  Widget _buildContent(bool isDark) {
    return SafeArea(
      child: Column(
        children: [
          // ── AppBar ──
          FadeTransition(
            opacity: _headerOpacity,
            child: SlideTransition(
              position: _headerSlide,
              child: _buildAppBar(isDark),
            ),
          ),

          // ── Scrollable body ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingSm),

                    // ── Type Selector ──
                    FadeTransition(
                      opacity: _typeSelectorOpacity,
                      child: SlideTransition(
                        position: _typeSelectorSlide,
                        child: _buildTypeSelector(isDark),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // ── Financial Summary ──
                    FadeTransition(
                      opacity: _formOpacity,
                      child: SlideTransition(
                        position: _formSlide,
                        child: _buildFinancialSummary(isDark),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // ── Dynamic Form Panel ──
                    FadeTransition(
                      opacity: _formOpacity,
                      child: SlideTransition(
                        position: _formSlide,
                        child: _buildFormPanel(isDark),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // ── Category Selector ──
                    FadeTransition(
                      opacity: _formOpacity,
                      child: SlideTransition(
                        position: _formSlide,
                        child: _buildCategorySelector(isDark),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // ── Notes ──
                    FadeTransition(
                      opacity: _formOpacity,
                      child: SlideTransition(
                        position: _formSlide,
                        child: _buildNotesField(isDark),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingXl),

                    // ── CTA Button ──
                    FadeTransition(
                      opacity: _ctaOpacity,
                      child: SlideTransition(
                        position: _ctaSlide,
                        child: _buildCTA(isDark),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingXxl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ──
  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingSm,
        AppTheme.spacingLg,
        AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          // Back button
          IconActionButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 40,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: AppTheme.spacingMd),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reality Check',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Analyse your purchase decision',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Theme toggle
          const ThemeToggleButton(),
        ],
      ),
    );
  }

  // ── Purchase Type Selector ──
  Widget _buildTypeSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase Type',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Row(
          children: [
            Expanded(
              child: _typeTile(
                isDark,
                type: PurchaseType.online,
                icon: Icons.language_rounded,
                title: 'Online',
                subtitle: 'Amazon, Flipkart & more',
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: _typeTile(
                isDark,
                type: PurchaseType.offline,
                icon: Icons.store_rounded,
                title: 'Offline',
                subtitle: 'Local stores & markets',
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typeTile(
      bool isDark, {
        required PurchaseType type,
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
      }) {
    final isSelected = _purchaseType == type;

    return GestureDetector(
      onTap: () => _switchType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected
              ? null
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.5)
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ]
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? color
                    : (isDark
                    ? AppTheme.darkCardElevated
                    : AppTheme.lightCardElevated),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : (isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? color
                          : (isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppTheme.darkTextMuted
                          : AppTheme.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Selected indicator
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Financial Summary Strip ──
  Widget _buildFinancialSummary(bool isDark) {
    final remaining = _spendingLimit - _totalSpent;
    final percentUsed = (_totalSpent / _spendingLimit).clamp(0.0, 1.0);

    Color statusColor;
    if (percentUsed < 0.5) {
      statusColor = AppTheme.safeGreen;
    } else if (percentUsed < 0.8) {
      statusColor = AppTheme.warningAmber;
    } else {
      statusColor = AppTheme.dangerRed;
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 16,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Your Financial Snapshot',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          Row(
            children: [
              _summaryChip(
                isDark,
                label: 'Salary',
                value: '₹${_fmt(_monthlySalary)}',
                color: AppTheme.primaryColor,
                icon: Icons.payments_rounded,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _summaryChip(
                isDark,
                label: 'Spent',
                value: '₹${_fmt(_totalSpent)}',
                color: AppTheme.warningAmber,
                icon: Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _summaryChip(
                isDark,
                label: 'Left',
                value: '₹${_fmt(remaining)}',
                color: statusColor,
                icon: Icons.wallet_rounded,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Mini progress
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percentUsed),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (_, val, __) => LinearProgressIndicator(
                value: val,
                minHeight: 6,
                backgroundColor: isDark
                    ? AppTheme.darkCardElevated
                    : AppTheme.lightCardElevated,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(
      bool isDark, {
        required String label,
        required String value,
        required Color color,
        required IconData icon,
      }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingSm + 2,
          horizontal: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dynamic Form Panel ──
  Widget _buildFormPanel(bool isDark) {
    return FadeTransition(
      opacity: _typeFormOpacity,
      child: SlideTransition(
        position: _typeFormSlide,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: _purchaseType == PurchaseType.online
              ? _buildOnlineForm(isDark)
              : _buildOfflineForm(isDark),
        ),
      ),
    );
  }

  // ── Online Form ──
  Widget _buildOnlineForm(bool isDark) {
    return Container(
      key: const ValueKey('online'),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(
                  Icons.language_rounded,
                  size: 17,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Online Purchase',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Paste the product link below',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Supported platforms row
          _buildPlatformBadges(isDark),

          const SizedBox(height: AppTheme.spacingLg),

          // URL field
          UrlInputField(
            label: 'Product Link',
            controller: _urlController,
            focusNode: _urlFocus,
            validator: FieldValidators.productUrl,
            onChanged: (_) {},
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Paste tip
          _buildTip(
            isDark,
            icon: Icons.lightbulb_outline_rounded,
            text:
            'Copy the product link from your browser or app and paste it here.',
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformBadges(bool isDark) {
    final platforms = [
      {'label': 'Amazon', 'color': const Color(0xFFFF9900)},
      {'label': 'Flipkart', 'color': const Color(0xFF2874F0)},
      {'label': 'Myntra', 'color': const Color(0xFFFF3F6C)},
      {'label': 'Meesho', 'color': const Color(0xFF9B2FFF)},
      {'label': '& more', 'color': AppTheme.darkTextMuted},
    ];

    return Wrap(
      spacing: AppTheme.spacingSm,
      runSpacing: AppTheme.spacingSm,
      children: platforms.map((p) {
        final color = p['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            border: Border.all(color: color.withOpacity(0.25), width: 1),
          ),
          child: Text(
            p['label'] as String,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color == AppTheme.darkTextMuted
                  ? (isDark
                  ? AppTheme.darkTextMuted
                  : AppTheme.lightTextMuted)
                  : color,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Offline Form ──
  Widget _buildOfflineForm(bool isDark) {
    return Container(
      key: const ValueKey('offline'),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(
                  Icons.store_rounded,
                  size: 17,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offline Purchase',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Enter item details manually',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Item name
          CustomTextField(
            label: 'Item Name',
            hint: 'e.g. Sony WH-1000XM5 Headphones',
            controller: _itemNameController,
            fieldType: FieldType.text,
            prefixIcon: Icons.shopping_bag_outlined,
            focusNode: _itemNameFocus,
            textInputAction: TextInputAction.next,
            validator: FieldValidators.itemName,
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_itemPriceFocus),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Item price
          CurrencyInputField(
            label: 'Item Price',
            hint: '0.00',
            helperText: 'Enter the price you saw at the store',
            controller: _itemPriceController,
            focusNode: _itemPriceFocus,
            textInputAction: TextInputAction.done,
            validator: FieldValidators.itemPrice,
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Tip
          _buildTip(
            isDark,
            icon: Icons.info_outline_rounded,
            text:
            'We\'ll compare this price against your budget and spending limit to give you a reality check.',
            color: AppTheme.accentColor,
          ),
        ],
      ),
    );
  }

  // ── Tip Widget ──
  Widget _buildTip(
      bool isDark, {
        required IconData icon,
        required String text,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Selector ──
  Widget _buildCategorySelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingMd),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: AppTheme.spacingSm),
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final isSelected = _selectedCategory == cat['label'];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedCategory = cat['label']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.primaryGradient() : null,
                    color: isSelected
                        ? null
                        : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
                    borderRadius:
                    BorderRadius.circular(AppTheme.radiusFull),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (isDark
                          ? AppTheme.darkBorder
                          : AppTheme.lightBorder),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color:
                        AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        size: 15,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Notes Field ──
  Widget _buildNotesField(bool isDark) {
    return CustomTextField(
      label: 'Notes (Optional)',
      hint: 'Why do you want to buy this? Any additional context...',
      controller: _notesController,
      fieldType: FieldType.multiline,
      prefixIcon: Icons.edit_note_rounded,
      focusNode: _notesFocus,
      maxLength: 200,
    );
  }

  // ── CTA Section ──
  Widget _buildCTA(bool isDark) {
    return Column(
      children: [
        // Main CTA
        CustomButton(
          label: 'Get My Reality Check',
          onPressed: _isLoading ? null : _handleCheck,
          isLoading: _isLoading,
          hasGlow: true,
          prefixIcon: Icons.balance_rounded,
          size: ButtonSize.large,
        ),

        const SizedBox(height: AppTheme.spacingMd),

        // Disclaimer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 13,
              color: isDark
                  ? AppTheme.darkTextMuted
                  : AppTheme.lightTextMuted,
            ),
            const SizedBox(width: 5),
            Text(
              'Your data is analysed locally & privately',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Helpers ──
  String _fmt(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}