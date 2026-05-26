import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart'; // ADD THIS LINE
import 'purchase_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {

  // ── Navigation ──
  int _currentIndex = 0;

  // ── Financial Data (mock — replace with real state/service) ──
  double _monthlySalary = 65000;
  double _spendingLimit = 20000;
  double _savingsGoal = 15000;
  double _totalSpent = 8450;
  int _totalChecks = 12;
  int _safePurchases = 7;
  int _thinkPurchases = 3;
  int _waitPurchases = 2;

  // ── Animation Controllers ──
  late AnimationController _entranceController;
  late AnimationController _cardController;
  late AnimationController _fabController;
  late AnimationController _navController;
  late AnimationController _orbController;

  // ── Entrance Animations ──
  late Animation<double> _greetingOpacity;
  late Animation<Offset> _greetingSlide;
  late Animation<double> _balanceCardOpacity;
  late Animation<Offset> _balanceCardSlide;
  late Animation<double> _statsOpacity;
  late Animation<Offset> _statsSlide;
  late Animation<double> _actionsOpacity;
  late Animation<Offset> _actionsSlide;

  // ── Card pulse ──
  late Animation<double> _cardPulse;

  // ── FAB ──
  late Animation<double> _fabScale;
  late Animation<double> _fabOpacity;

  // ── Nav bar ──
  late Animation<Offset> _navSlide;

  // ── Orbs ──
  late Animation<double> _orbAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _playEntrance();
  }

  void _setupAnimations() {
    // ── Entrance ──
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _greetingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _greetingSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));

    _balanceCardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );
    _balanceCardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
    ));

    _statsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOut),
      ),
    );
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
    ));

    _actionsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.90, curve: Curves.easeOut),
      ),
    );
    _actionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
    ));

    // ── Card pulse ──
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _cardPulse = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    // ── FAB ──
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: Curves.elasticOut,
      ),
    );
    _fabOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // ── Nav bar ──
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _navSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _navController,
      curve: Curves.easeOutCubic,
    ));

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
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _entranceController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _navController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _fabController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _cardController.dispose();
    _fabController.dispose();
    _navController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  // ── Navigate to Purchase Screen ──
  void _goToPurchase() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const PurchaseScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(curve: Curves.easeOutCubic, parent: anim),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // ── Computed values ──
  double get _remainingBudget => _spendingLimit - _totalSpent;
  double get _spendingPercent =>
      (_totalSpent / _spendingLimit).clamp(0.0, 1.0);
  double get _savingsPercent =>
      ((_monthlySalary - _totalSpent - _savingsGoal) / _monthlySalary)
          .clamp(0.0, 1.0);

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Color _budgetStatusColor(bool isDark) {
    if (_spendingPercent < 0.5) return AppTheme.safeGreen;
    if (_spendingPercent < 0.8) return AppTheme.warningAmber;
    return AppTheme.dangerRed;
  }

  String _budgetStatusLabel() {
    if (_spendingPercent < 0.5) return 'Healthy Budget';
    if (_spendingPercent < 0.8) return 'Moderate Spending';
    return 'Near Limit!';
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
          _buildOrbs(size),
          _buildBody(isDark, size),
        ],
      ),
      bottomNavigationBar: SlideTransition(
        position: _navSlide,
        child: _buildBottomNav(isDark),
      ),
      floatingActionButton: _buildFAB(isDark),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }

  // ── Background ──
  Widget _buildBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const RadialGradient(
          center: Alignment(0.0, -0.7),
          radius: 0.9,
          colors: [Color(0xFF130B2E), AppTheme.darkBackground],
        )
            : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0EFFE), AppTheme.lightBackground],
        ),
      ),
    );
  }

  // ── Orbs ──
  Widget _buildOrbs(Size size) {
    return AnimatedBuilder(
      animation: _orbAnim,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Transform.translate(
              offset: Offset(0, _orbAnim.value * 18),
              child: Container(
                width: size.width * 0.55,
                height: size.width * 0.55,
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
            bottom: 100,
            left: -60,
            child: Transform.translate(
              offset: Offset(0, -_orbAnim.value * 14),
              child: Container(
                width: size.width * 0.45,
                height: size.width * 0.45,
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

  // ── Body ──
  Widget _buildBody(bool isDark, Size size) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── AppBar ──
          SliverToBoxAdapter(child: _buildAppBar(isDark)),

          // ── Greeting ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _greetingOpacity,
              child: SlideTransition(
                position: _greetingSlide,
                child: _buildGreeting(isDark),
              ),
            ),
          ),

          // ── Balance Card ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _balanceCardOpacity,
              child: SlideTransition(
                position: _balanceCardSlide,
                child: _buildBalanceCard(isDark),
              ),
            ),
          ),

          // ── Stats Row ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _statsOpacity,
              child: SlideTransition(
                position: _statsSlide,
                child: _buildStatsRow(isDark),
              ),
            ),
          ),

          // ── Spending Progress ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _statsOpacity,
              child: SlideTransition(
                position: _statsSlide,
                child: _buildSpendingCard(isDark),
              ),
            ),
          ),

          // ── Quick Actions ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _actionsOpacity,
              child: SlideTransition(
                position: _actionsSlide,
                child: _buildQuickActions(isDark),
              ),
            ),
          ),

          // ── Reality Results Summary ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _actionsOpacity,
              child: SlideTransition(
                position: _actionsSlide,
                child: _buildResultsSummary(isDark),
              ),
            ),
          ),

          // ── CTA Banner ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _actionsOpacity,
              child: SlideTransition(
                position: _actionsSlide,
                child: _buildCTABanner(isDark),
              ),
            ),
          ),

          // Bottom padding for nav bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  // ── AppBar ──
  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingMd,
        AppTheme.spacingLg,
        AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          // Logo mark
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.glowGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.balance_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reality Check',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'PURCHASE',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Notification bell
          IconActionButton(
            icon: Icons.notifications_none_rounded,
            size: 38,
            tooltip: 'Notifications',
            onPressed: () {
              HapticFeedback.lightImpact();
            },
          ),
          const SizedBox(width: 10),

          // Theme toggle
          const ThemeToggleButton(),
        ],
      ),
    );
  }

  // ── Greeting ──
  Widget _buildGreeting(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingSm,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting, 👋',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Vanjani Om',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),

          // Budget status chip
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: _budgetStatusColor(isDark).withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(
                color: _budgetStatusColor(isDark).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _budgetStatusColor(isDark),
                    boxShadow: [
                      BoxShadow(
                        color: _budgetStatusColor(isDark).withOpacity(0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _budgetStatusLabel(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _budgetStatusColor(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Balance Card ──
  Widget _buildBalanceCard(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: AnimatedBuilder(
        animation: _cardPulse,
        builder: (_, child) => Transform.scale(
          scale: _cardPulse.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            gradient: AppTheme.glowGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.35),
                blurRadius: 28,
                offset: const Offset(0, 10),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppTheme.accentColor.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label row
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 15,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Monthly Salary',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Salary amount
                  Text(
                    '₹${_formatAmount(_monthlySalary)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Bottom row — Spent / Remaining
                  Row(
                    children: [
                      _cardStat(
                        'Spent',
                        '₹${_formatAmount(_totalSpent)}',
                        Icons.arrow_upward_rounded,
                        AppTheme.warningAmber,
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white.withOpacity(0.15),
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingLg,
                        ),
                      ),
                      _cardStat(
                        'Remaining',
                        '₹${_formatAmount(_remainingBudget)}',
                        Icons.arrow_downward_rounded,
                        AppTheme.safeGreen,
                      ),
                      const Spacer(),
                      _cardStat(
                        'Savings Goal',
                        '₹${_formatAmount(_savingsGoal)}',
                        Icons.savings_rounded,
                        Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardStat(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ── Stats Row ──
  Widget _buildStatsRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingMd,
        AppTheme.spacingLg,
        0,
      ),
      child: Row(
        children: [
          _statCard(
            isDark,
            label: 'Total Checks',
            value: '$_totalChecks',
            icon: Icons.fact_check_rounded,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          _statCard(
            isDark,
            label: 'Safe',
            value: '$_safePurchases',
            icon: Icons.check_circle_rounded,
            color: AppTheme.safeGreen,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          _statCard(
            isDark,
            label: 'Think',
            value: '$_thinkPurchases',
            icon: Icons.psychology_rounded,
            color: AppTheme.warningAmber,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          _statCard(
            isDark,
            label: 'Wait',
            value: '$_waitPurchases',
            icon: Icons.timer_rounded,
            color: AppTheme.dangerRed,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      bool isDark, {
        required String label,
        required String value,
        required IconData icon,
        required Color color,
      }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingMd,
          horizontal: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.15 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Spending Progress Card ──
  Widget _buildSpendingCard(bool isDark) {
    final statusColor = _budgetStatusColor(isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingMd,
        AppTheme.spacingLg,
        0,
      ),
      child: Container(
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
                Text(
                  'Spending Limit',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(
                    '${(_spendingPercent * 100).toInt()}% used',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _spendingPercent),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (_, value, __) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor: isDark
                        ? AppTheme.darkCardElevated
                        : AppTheme.lightCardElevated,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(statusColor),
                  );
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Amounts
            Row(
              children: [
                _progressLabel(
                  'Spent',
                  '₹${_formatAmount(_totalSpent)}',
                  statusColor,
                  isDark,
                ),
                const Spacer(),
                _progressLabel(
                  'Limit',
                  '₹${_formatAmount(_spendingLimit)}',
                  isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted,
                  isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressLabel(
      String label, String value, Color valueColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color:
            isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ── Quick Actions ──
  Widget _buildQuickActions(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              _actionTile(
                isDark,
                icon: Icons.shopping_cart_checkout_rounded,
                label: 'Check\nPurchase',
                color: AppTheme.primaryColor,
                gradient: AppTheme.primaryGradient(),
                onTap: _goToPurchase,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              _actionTile(
                isDark,
                icon: Icons.history_rounded,
                label: 'View\nHistory',
                color: AppTheme.accentColor,
                gradient: LinearGradient(
                  colors: [AppTheme.accentColor, AppTheme.accentLight],
                ),
                onTap: () {
                  setState(() => _currentIndex = 1);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: AppTheme.spacingMd),
              _actionTile(
                isDark,
                icon: Icons.tune_rounded,
                label: 'Set\nBudget',
                color: AppTheme.safeGreen,
                gradient: LinearGradient(
                  colors: [AppTheme.safeGreen, const Color(0xFF059669)],
                ),
                onTap: () => _showBudgetSheet(isDark),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              _actionTile(
                isDark,
                icon: Icons.person_outline_rounded,
                label: 'My\nProfile',
                color: AppTheme.warningAmber,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.warningAmber,
                    const Color(0xFFD97706),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
      bool isDark, {
        required IconData icon,
        required String label,
        required Color color,
        required Gradient gradient,
        required VoidCallback onTap,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Results Summary ──
  Widget _buildResultsSummary(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        0,
      ),
      child: Container(
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
            Row(
              children: [
                Text(
                  'Reality Results',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  ),
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Bar chart visual
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _resultBar(
                  isDark,
                  label: 'Safe',
                  count: _safePurchases,
                  total: _totalChecks,
                  color: AppTheme.safeGreen,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                _resultBar(
                  isDark,
                  label: 'Think',
                  count: _thinkPurchases,
                  total: _totalChecks,
                  color: AppTheme.warningAmber,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                _resultBar(
                  isDark,
                  label: 'Wait',
                  count: _waitPurchases,
                  total: _totalChecks,
                  color: AppTheme.dangerRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultBar(
      bool isDark, {
        required String label,
        required int count,
        required int total,
        required Color color,
      }) {
    final percent = total == 0 ? 0.0 : count / total;
    final maxHeight = 80.0;

    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) {
              return Container(
                height: maxHeight * value.clamp(0.05, 1.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(isDark ? 0.85 : 0.75),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ── CTA Banner ──
  Widget _buildCTABanner(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        0,
      ),
      child: GestureDetector(
        onTap: _goToPurchase,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient(),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.glowShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ready to check a purchase?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Get your reality check now →',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom Nav ──
  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _navItem(
                isDark,
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _navItem(
                isDark,
                icon: Icons.history_rounded,
                label: 'History',
                index: 1,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
              ),

              // Center FAB space
              const Expanded(child: SizedBox()),

              _navItem(
                isDark,
                icon: Icons.bar_chart_rounded,
                label: 'Stats',
                index: 3,
              ),
              _navItem(
                isDark,
                icon: Icons.person_rounded,
                label: 'Profile',
                index: 4,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      bool isDark, {
        required IconData icon,
        required String label,
        required int index,
        VoidCallback? onTap,
      }) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = index);
          onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryColor.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isActive
                      ? AppTheme.primaryColor
                      : (isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppTheme.primaryColor
                      : (isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted),
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── FAB ──
  Widget _buildFAB(bool isDark) {
    return AnimatedBuilder(
      animation: _fabController,
      builder: (_, __) => Transform.scale(
        scale: _fabScale.value,
        child: Opacity(
          opacity: _fabOpacity.value,
          child: GestureDetector(
            onTap: _goToPurchase,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppTheme.glowGradient,
                shape: BoxShape.circle,
                boxShadow: AppTheme.glowShadow,
              ),
              child: const Icon(
                Icons.add_shopping_cart_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Budget Sheet ──
  void _showBudgetSheet(bool isDark) {
    HapticFeedback.lightImpact();
    final salaryCtrl =
    TextEditingController(text: _monthlySalary.toStringAsFixed(0));
    final limitCtrl =
    TextEditingController(text: _spendingLimit.toStringAsFixed(0));
    final savingsCtrl =
    TextEditingController(text: _savingsGoal.toStringAsFixed(0));
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Update Budget',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  'These values power your reality checks',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                CurrencyInputField(
                  label: 'Monthly Salary',
                  controller: salaryCtrl,
                  validator: FieldValidators.salary,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                CurrencyInputField(
                  label: 'Spending Limit',
                  controller: limitCtrl,
                  validator: (val) => FieldValidators.spendingLimit(
                    val,
                    salary: double.tryParse(salaryCtrl.text),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                CurrencyInputField(
                  label: 'Savings Goal',
                  controller: savingsCtrl,
                  validator: (val) => FieldValidators.savingsGoal(
                    val,
                    salary: double.tryParse(salaryCtrl.text),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                CustomButton(
                  label: 'Save Budget',
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _monthlySalary =
                            double.tryParse(salaryCtrl.text) ??
                                _monthlySalary;
                        _spendingLimit =
                            double.tryParse(limitCtrl.text) ??
                                _spendingLimit;
                        _savingsGoal =
                            double.tryParse(savingsCtrl.text) ??
                                _savingsGoal;
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  prefixIcon: Icons.save_rounded,
                  hasGlow: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom +
                      AppTheme.spacingSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ──
  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}