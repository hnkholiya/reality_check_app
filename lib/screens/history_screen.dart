import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';

// ─────────────────────────────────────────────
// History Item Model (local)
// ─────────────────────────────────────────────

class HistoryItem {
  final String id;
  final String productName;
  final double price;
  final DateTime date;
  final String purchaseType; // 'Online' | 'Offline'
  final String realityResult; // 'Safe Purchase' | 'Think Before Buying' | 'Better Wait'
  final String platform;
  final String category;
  final String? productUrl;
  final double financialScore;

  const HistoryItem({
    required this.id,
    required this.productName,
    required this.price,
    required this.date,
    required this.purchaseType,
    required this.realityResult,
    required this.platform,
    required this.category,
    this.productUrl,
    required this.financialScore,
  });
}

// ─────────────────────────────────────────────
// Mock Data — replace with Firebase service
// ─────────────────────────────────────────────

final List<HistoryItem> _mockHistory = [
  HistoryItem(
    id: '1',
    productName: 'Sony WH-1000XM5 Headphones',
    price: 24990,
    date: DateTime.now().subtract(const Duration(days: 1)),
    purchaseType: 'Online',
    realityResult: 'Think Before Buying',
    platform: 'Amazon',
    category: 'Electronics',
    productUrl: 'https://amazon.in/sony-wh1000xm5',
    financialScore: 0.54,
  ),
  HistoryItem(
    id: '2',
    productName: 'Nike Air Max 270',
    price: 8995,
    date: DateTime.now().subtract(const Duration(days: 3)),
    purchaseType: 'Online',
    realityResult: 'Safe Purchase',
    platform: 'Flipkart',
    category: 'Fashion',
    productUrl: 'https://flipkart.com/nike-airmax',
    financialScore: 0.82,
  ),
  HistoryItem(
    id: '3',
    productName: 'iPhone 15 Pro Max',
    price: 134900,
    date: DateTime.now().subtract(const Duration(days: 5)),
    purchaseType: 'Offline',
    realityResult: 'Better Wait',
    platform: 'Offline Store',
    category: 'Electronics',
    financialScore: 0.12,
  ),
  HistoryItem(
    id: '4',
    productName: 'Lakme Eyeconic Kajal',
    price: 249,
    date: DateTime.now().subtract(const Duration(days: 7)),
    purchaseType: 'Online',
    realityResult: 'Safe Purchase',
    platform: 'Nykaa',
    category: 'Beauty',
    financialScore: 0.95,
  ),
  HistoryItem(
    id: '5',
    productName: 'Atomic Habits — James Clear',
    price: 399,
    date: DateTime.now().subtract(const Duration(days: 10)),
    purchaseType: 'Online',
    realityResult: 'Safe Purchase',
    platform: 'Amazon',
    category: 'Books',
    financialScore: 0.91,
  ),
  HistoryItem(
    id: '6',
    productName: 'Dyson V12 Vacuum Cleaner',
    price: 44900,
    date: DateTime.now().subtract(const Duration(days: 12)),
    purchaseType: 'Offline',
    realityResult: 'Better Wait',
    platform: 'Offline Store',
    category: 'Home',
    financialScore: 0.18,
  ),
  HistoryItem(
    id: '7',
    productName: 'Myntra Ethnic Kurta Set',
    price: 1299,
    date: DateTime.now().subtract(const Duration(days: 15)),
    purchaseType: 'Online',
    realityResult: 'Safe Purchase',
    platform: 'Myntra',
    category: 'Fashion',
    financialScore: 0.88,
  ),
  HistoryItem(
    id: '8',
    productName: 'Protein Whey Supplement',
    price: 2999,
    date: DateTime.now().subtract(const Duration(days: 18)),
    purchaseType: 'Online',
    realityResult: 'Think Before Buying',
    platform: 'Meesho',
    category: 'Sports',
    financialScore: 0.48,
  ),
  HistoryItem(
    id: '9',
    productName: 'Samsung 65" QLED TV',
    price: 89990,
    date: DateTime.now().subtract(const Duration(days: 21)),
    purchaseType: 'Offline',
    realityResult: 'Better Wait',
    platform: 'Offline Store',
    category: 'Electronics',
    financialScore: 0.08,
  ),
  HistoryItem(
    id: '10',
    productName: 'boAt Rockerz 450 Bluetooth',
    price: 1499,
    date: DateTime.now().subtract(const Duration(days: 25)),
    purchaseType: 'Online',
    realityResult: 'Safe Purchase',
    platform: 'Flipkart',
    category: 'Electronics',
    financialScore: 0.86,
  ),
  HistoryItem(
    id: '11',
    productName: 'Nike Dri-Fit T-Shirt',
    price: 2499,
    date: DateTime.now().subtract(const Duration(days: 28)),
    purchaseType: 'Offline',
    realityResult: 'Think Before Buying',
    platform: 'Offline Store',
    category: 'Sports',
    financialScore: 0.61,
  ),
  HistoryItem(
    id: '12',
    productName: 'Prestige Induction Cooktop',
    price: 3499,
    date: DateTime.now().subtract(const Duration(days: 30)),
    purchaseType: 'Online',
    realityResult: 'Safe Purchase',
    platform: 'Amazon',
    category: 'Home',
    financialScore: 0.79,
  ),
];

// ─────────────────────────────────────────────
// History Screen
// ─────────────────────────────────────────────

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {

  // ── State ──
  List<HistoryItem> _allItems = List.from(_mockHistory);
  List<HistoryItem> _filteredItems = List.from(_mockHistory);
  String _selectedFilter = 'All';
  String _selectedSort = 'Newest';
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isGridView = false;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  // ── Filters ──
  final List<String> _filters = [
    'All',
    'Safe Purchase',
    'Think Before Buying',
    'Better Wait',
    'Online',
    'Offline',
  ];

  final List<String> _sortOptions = [
    'Newest',
    'Oldest',
    'Price High',
    'Price Low',
    'Score High',
    'Score Low',
  ];

  // ── Animations ──
  late AnimationController _entranceController;
  late AnimationController _listController;
  late AnimationController _orbController;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _statsOpacity;
  late Animation<Offset> _statsSlide;
  late Animation<double> _orbAnim;

  // Per-item stagger (tracked by index)
  final Map<int, AnimationController> _itemControllers = {};
  final Map<int, Animation<double>> _itemOpacities = {};
  final Map<int, Animation<Offset>> _itemSlides = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _playEntrance();
  }

  void _setupAnimations() {
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    ));

    _statsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.70, curve: Curves.easeOut),
      ),
    );
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
    ));

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _orbAnim = CurvedAnimation(
      parent: _orbController,
      curve: Curves.easeInOut,
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _playEntrance() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _entranceController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _triggerListAnimation();
  }

  void _triggerListAnimation() {
    for (int i = 0; i < _filteredItems.length && i < 15; i++) {
      _animateItem(i);
    }
  }

  void _animateItem(int index) async {
    if (_itemControllers.containsKey(index)) return;

    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _itemControllers[index] = ctrl;
    _itemOpacities[index] = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
    );
    _itemSlides[index] = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
    );

    await Future.delayed(Duration(milliseconds: index * 60));
    if (!mounted) return;
    ctrl.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _entranceController.dispose();
    _listController.dispose();
    _orbController.dispose();
    for (final c in _itemControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Filter + Search Logic ──
  void _applyFilterAndSort() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        // Search
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          if (!item.productName.toLowerCase().contains(q) &&
              !item.platform.toLowerCase().contains(q) &&
              !item.category.toLowerCase().contains(q)) {
            return false;
          }
        }

        // Filter
        switch (_selectedFilter) {
          case 'Safe Purchase':
            return item.realityResult == 'Safe Purchase';
          case 'Think Before Buying':
            return item.realityResult == 'Think Before Buying';
          case 'Better Wait':
            return item.realityResult == 'Better Wait';
          case 'Online':
            return item.purchaseType == 'Online';
          case 'Offline':
            return item.purchaseType == 'Offline';
          default:
            return true;
        }
      }).toList();

      // Sort
      switch (_selectedSort) {
        case 'Oldest':
          _filteredItems.sort((a, b) => a.date.compareTo(b.date));
          break;
        case 'Price High':
          _filteredItems.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Price Low':
          _filteredItems.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Score High':
          _filteredItems
              .sort((a, b) => b.financialScore.compareTo(a.financialScore));
          break;
        case 'Score Low':
          _filteredItems
              .sort((a, b) => a.financialScore.compareTo(b.financialScore));
          break;
        default: // Newest
          _filteredItems.sort((a, b) => b.date.compareTo(a.date));
      }
    });

    // Re-animate list
    _itemControllers.forEach((_, c) => c.dispose());
    _itemControllers.clear();
    _itemOpacities.clear();
    _itemSlides.clear();
    _triggerListAnimation();
  }

  void _deleteItem(String id) {
    HapticFeedback.mediumImpact();
    setState(() {
      _allItems.removeWhere((i) => i.id == id);
      _filteredItems.removeWhere((i) => i.id == id);
    });
  }

  // ── Computed Stats ──
  int get _safeCount =>
      _allItems.where((i) => i.realityResult == 'Safe Purchase').length;
  int get _thinkCount =>
      _allItems.where((i) => i.realityResult == 'Think Before Buying').length;
  int get _waitCount =>
      _allItems.where((i) => i.realityResult == 'Better Wait').length;
  double get _totalChecked =>
      _allItems.fold(0, (sum, i) => sum + i.price);
  double get _avgScore =>
      _allItems.isEmpty
          ? 0
          : _allItems.fold(0.0, (s, i) => s + i.financialScore) /
          _allItems.length;

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
          SafeArea(
            child: Column(
              children: [
                // AppBar
                FadeTransition(
                  opacity: _headerOpacity,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: _buildAppBar(isDark),
                  ),
                ),

                // Search bar (animated)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: _isSearching
                      ? _buildSearchBar(isDark)
                      : const SizedBox.shrink(),
                ),

                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Stats strip
                      SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _statsOpacity,
                          child: SlideTransition(
                            position: _statsSlide,
                            child: _buildStatsStrip(isDark),
                          ),
                        ),
                      ),

                      // Filter chips
                      SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _statsOpacity,
                          child: _buildFilterRow(isDark),
                        ),
                      ),

                      // Sort + view toggle
                      SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _statsOpacity,
                          child: _buildSortRow(isDark),
                        ),
                      ),

                      // Empty state or list
                      if (_filteredItems.isEmpty)
                        SliverFillRemaining(
                          child: _buildEmptyState(isDark),
                        )
                      else if (_isGridView)
                        _buildGridList(isDark)
                      else
                        _buildVerticalList(isDark),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 80),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          center: Alignment(0, -0.5),
          radius: 0.9,
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
            top: -40,
            right: -30,
            child: Transform.translate(
              offset: Offset(0, _orbAnim.value * 18),
              child: Container(
                width: size.width * 0.45,
                height: size.width * 0.45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.09),
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
          IconActionButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 40,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase History',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${_allItems.length} checks recorded',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Search toggle
          IconActionButton(
            icon: _isSearching
                ? Icons.search_off_rounded
                : Icons.search_rounded,
            size: 40,
            tooltip: 'Search',
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                  _applyFilterAndSort();
                } else {
                  Future.delayed(const Duration(milliseconds: 350), () {
                    if (mounted) _searchFocus.requestFocus();
                  });
                }
              });
            },
          ),

          const SizedBox(width: AppTheme.spacingSm),
          const ThemeToggleButton(),
        ],
      ),
    );
  }

  // ── Search Bar ──
  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        0,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: _searchFocus.hasFocus
                ? AppTheme.primaryColor
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: _searchFocus.hasFocus ? 2 : 1,
          ),
          boxShadow: _searchFocus.hasFocus
              ? [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            const SizedBox(width: AppTheme.spacingMd),
            Icon(
              Icons.search_rounded,
              size: 18,
              color: _searchFocus.hasFocus
                  ? AppTheme.primaryColor
                  : (isDark
                  ? AppTheme.darkTextMuted
                  : AppTheme.lightTextMuted),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                  _applyFilterAndSort();
                },
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search products, platforms, categories...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.lightTextMuted,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                  _applyFilterAndSort();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingMd),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.lightTextMuted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Stats Strip ──
  Widget _buildStatsStrip(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingSm,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Row(
        children: [
          _miniStat(isDark, '$_safeCount', 'Safe',
              AppTheme.safeGreen, Icons.check_circle_rounded),
          const SizedBox(width: AppTheme.spacingSm),
          _miniStat(isDark, '$_thinkCount', 'Think',
              AppTheme.warningAmber, Icons.psychology_rounded),
          const SizedBox(width: AppTheme.spacingSm),
          _miniStat(isDark, '$_waitCount', 'Wait',
              AppTheme.dangerRed, Icons.cancel_rounded),
          const SizedBox(width: AppTheme.spacingSm),
          _miniStat(
            isDark,
            '${(_avgScore * 100).toInt()}%',
            'Avg Score',
            AppTheme.primaryColor,
            Icons.bar_chart_rounded,
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
      bool isDark,
      String value,
      String label,
      Color color,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingSm + 2,
          horizontal: AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
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

  // ── Filter Chips Row ──
  Widget _buildFilterRow(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg),
        itemCount: _filters.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: AppTheme.spacingSm),
        itemBuilder: (_, i) {
          final filter = _filters[i];
          final isSelected = _selectedFilter == filter;

          Color chipColor = AppTheme.primaryColor;
          if (filter == 'Safe Purchase') chipColor = AppTheme.safeGreen;
          if (filter == 'Think Before Buying') {
            chipColor = AppTheme.warningAmber;
          }
          if (filter == 'Better Wait') chipColor = AppTheme.dangerRed;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedFilter = filter);
              _applyFilterAndSort();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [chipColor, chipColor.withOpacity(0.75)],
                )
                    : null,
                color: isSelected
                    ? null
                    : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
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
                    color: chipColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Sort Row ──
  Widget _buildSortRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingMd,
        AppTheme.spacingLg,
        AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          Text(
            '${_filteredItems.length} results',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppTheme.darkTextMuted
                  : AppTheme.lightTextMuted,
            ),
          ),
          const Spacer(),

          // Sort dropdown
          GestureDetector(
            onTap: () => _showSortSheet(isDark),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingXs + 2,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                border: Border.all(
                  color:
                  isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 14,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _selectedSort,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacingSm),

          // View toggle
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _isGridView = !_isGridView);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: isDark
                      ? AppTheme.darkBorder
                      : AppTheme.lightBorder,
                ),
              ),
              child: Icon(
                _isGridView
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                size: 18,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Vertical List ──
  Widget _buildVerticalList(bool isDark) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (ctx, i) {
          if (i >= _filteredItems.length) return null;
          final item = _filteredItems[i];

          // Trigger animation for this index
          if (!_itemControllers.containsKey(i)) _animateItem(i);

          final opacityAnim = _itemOpacities[i];
          final slideAnim = _itemSlides[i];

          Widget card = _buildListCard(isDark, item, i);

          if (opacityAnim != null && slideAnim != null) {
            card = FadeTransition(
              opacity: opacityAnim,
              child: SlideTransition(position: slideAnim, child: card),
            );
          }

          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: _buildDismissBackground(isDark),
            confirmDismiss: (_) => _confirmDelete(isDark),
            onDismissed: (_) => _deleteItem(item.id),
            child: card,
          );
        },
        childCount: _filteredItems.length,
      ),
    );
  }

  // ── Grid List ──
  Widget _buildGridList(bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spacingMd,
          mainAxisSpacing: AppTheme.spacingMd,
          childAspectRatio: 0.82,
        ),
        delegate: SliverChildBuilderDelegate(
              (ctx, i) {
            if (i >= _filteredItems.length) return null;
            final item = _filteredItems[i];
            if (!_itemControllers.containsKey(i)) _animateItem(i);

            final opacityAnim = _itemOpacities[i];
            final slideAnim = _itemSlides[i];

            Widget card = _buildGridCard(isDark, item);

            if (opacityAnim != null && slideAnim != null) {
              card = FadeTransition(
                opacity: opacityAnim,
                child: SlideTransition(position: slideAnim, child: card),
              );
            }
            return card;
          },
          childCount: _filteredItems.length,
        ),
      ),
    );
  }

  // ── List Card ──
  Widget _buildListCard(bool isDark, HistoryItem item, int index) {
    final resultColor = AppTheme.resultColor(item.realityResult);
    final dimColor =
    AppTheme.resultColorDim(item.realityResult, isDark);

    return GestureDetector(
      onTap: () => _showItemDetail(isDark, item),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppTheme.spacingLg,
          0,
          AppTheme.spacingLg,
          AppTheme.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
          boxShadow: AppTheme.cardShadow(isDark),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Row(
            children: [
              // Left color bar
              Container(
                width: 4,
                height: 100,
                color: resultColor,
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: item.purchaseType == 'Online'
                                  ? AppTheme.primaryColor.withOpacity(
                                  isDark ? 0.15 : 0.1)
                                  : AppTheme.accentColor.withOpacity(
                                  isDark ? 0.15 : 0.1),
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radiusFull),
                            ),
                            child: Text(
                              item.purchaseType,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: item.purchaseType == 'Online'
                                    ? AppTheme.primaryColor
                                    : AppTheme.accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),

                          // Category
                          Text(
                            item.category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppTheme.darkTextMuted
                                  : AppTheme.lightTextMuted,
                            ),
                          ),
                          const Spacer(),

                          // Date
                          Text(
                            _formatDate(item.date),
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

                      const SizedBox(height: AppTheme.spacingSm),

                      // Product name
                      Text(
                        item.productName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Bottom row
                      Row(
                        children: [
                          // Platform
                          Icon(
                            Icons.storefront_rounded,
                            size: 12,
                            color: isDark
                                ? AppTheme.darkTextMuted
                                : AppTheme.lightTextMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.platform,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary,
                            ),
                          ),
                          const Spacer(),

                          // Price
                          Text(
                            '₹${_fmt(item.price)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingSm),

                      // Result badge + score
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: dimColor,
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radiusFull),
                              border: Border.all(
                                color: resultColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              item.realityResult,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: resultColor,
                              ),
                            ),
                          ),
                          const Spacer(),

                          // Score bar
                          SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${(item.financialScore * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: resultColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusFull),
                                  child: LinearProgressIndicator(
                                    value: item.financialScore,
                                    minHeight: 4,
                                    backgroundColor: isDark
                                        ? AppTheme.darkCardElevated
                                        : AppTheme.lightCardElevated,
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        resultColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Grid Card ──
  Widget _buildGridCard(bool isDark, HistoryItem item) {
    final resultColor = AppTheme.resultColor(item.realityResult);
    final dimColor = AppTheme.resultColorDim(item.realityResult, isDark);

    return GestureDetector(
      onTap: () => _showItemDetail(isDark, item),
      child: Container(
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
            // Top color band
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: resultColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusLg),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Result icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: dimColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _resultIcon(item.realityResult),
                      size: 18,
                      color: resultColor,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingSm),

                  // Product name
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Platform + date
                  Text(
                    '${item.platform} · ${_formatDate(item.date)}',
                    style: TextStyle(
                      fontSize: 9,
                      color: isDark
                          ? AppTheme.darkTextMuted
                          : AppTheme.lightTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppTheme.spacingSm),

                  // Price
                  Text(
                    '₹${_fmt(item.price)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingSm),

                  // Result badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: dimColor,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(
                          color: resultColor.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      item.realityResult,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: resultColor,
                      ),
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

  // ── Dismiss Background ──
  Widget _buildDismissBackground(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg, 0, AppTheme.spacingLg, AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppTheme.dangerRed,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppTheme.spacingLg),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 22),
          SizedBox(height: 4),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkCard
                  : AppTheme.lightCardElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded,
              size: 38,
              color: isDark
                  ? AppTheme.darkTextMuted
                  : AppTheme.lightTextMuted,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Try adjusting your filters or search query',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXl),
          CustomButton(
            label: 'Clear Filters',
            onPressed: () {
              setState(() {
                _selectedFilter = 'All';
                _searchQuery = '';
                _searchController.clear();
              });
              _applyFilterAndSort();
            },
            variant: ButtonVariant.secondary,
            isFullWidth: false,
            prefixIcon: Icons.filter_alt_off_rounded,
            size: ButtonSize.medium,
          ),
        ],
      ),
    );
  }

  // ── Item Detail Sheet ──
  void _showItemDetail(bool isDark, HistoryItem item) {
    HapticFeedback.lightImpact();
    final resultColor = AppTheme.resultColor(item.realityResult);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusXl),
            ),
            border: Border.all(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            ),
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkBorder
                        : AppTheme.lightBorder,
                    borderRadius:
                    BorderRadius.circular(AppTheme.radiusFull),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Result badge
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: resultColor,
                    borderRadius:
                    BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _resultIcon(item.realityResult),
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.realityResult,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Product name
              Text(
                item.productName,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingSm),

              // Price
              Center(
                child: Text(
                  '₹${_fmt(item.price)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: resultColor,
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Detail rows
              _sheetRow(isDark, Icons.category_rounded, 'Category',
                  item.category),
              _sheetRow(isDark, Icons.shopping_bag_rounded, 'Type',
                  item.purchaseType),
              _sheetRow(isDark, Icons.storefront_rounded, 'Platform',
                  item.platform),
              _sheetRow(isDark, Icons.calendar_today_rounded, 'Date',
                  _formatDate(item.date)),
              _sheetRow(
                isDark,
                Icons.bar_chart_rounded,
                'Financial Score',
                '${(item.financialScore * 100).toInt()}%',
              ),
              if (item.productUrl != null)
                _sheetRow(isDark, Icons.link_rounded, 'Product URL',
                    item.productUrl!),

              const SizedBox(height: AppTheme.spacingLg),

              // Score bar
              ClipRRect(
                borderRadius:
                BorderRadius.circular(AppTheme.radiusFull),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: item.financialScore),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (_, val, __) => LinearProgressIndicator(
                    value: val,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? AppTheme.darkCardElevated
                        : AppTheme.lightCardElevated,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(resultColor),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Delete button
              CustomButton(
                label: 'Delete Record',
                onPressed: () {
                  Navigator.pop(ctx);
                  _deleteItem(item.id);
                },
                variant: ButtonVariant.danger,
                prefixIcon: Icons.delete_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetRow(
      bool isDark, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Sort Sheet ──
  void _showSortSheet(bool isDark) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXl),
          ),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text('Sort By', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingMd),
            ..._sortOptions.map((opt) {
              final isSelected = _selectedSort == opt;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedSort = opt);
                  _applyFilterAndSort();
                  Navigator.pop(ctx);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(
                      bottom: AppTheme.spacingSm),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        opt,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : (isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary),
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom +
                  AppTheme.spacingSm,
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirm Delete Dialog ──
  Future<bool> _confirmDelete(bool isDark) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
        isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text(
          'Delete Record?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          'This history record will be permanently deleted.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.dangerRed),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  // ── Helpers ──
  IconData _resultIcon(String result) {
    switch (result) {
      case 'Safe Purchase':
        return Icons.check_circle_rounded;
      case 'Think Before Buying':
        return Icons.psychology_rounded;
      case 'Better Wait':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _fmt(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day} ${months[dt.month - 1]}';
  }
}