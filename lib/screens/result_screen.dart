import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'purchase_screen.dart';
import 'history_screen.dart';

// ─────────────────────────────────────────────
// Reality Result Model (local to this screen)
// ─────────────────────────────────────────────

class RealityResult {
  final String verdict;       // 'Safe Purchase' | 'Think Before Buying' | 'Better Wait'
  final String headline;      // Short punchy message
  final String message;       // Detailed explanation
  final String advice;        // Actionable tip
  final Color color;
  final Color dimColor;
  final IconData icon;
  final double score;         // 0.0 – 1.0 health score

  const RealityResult({
    required this.verdict,
    required this.headline,
    required this.message,
    required this.advice,
    required this.color,
    required this.dimColor,
    required this.icon,
    required this.score,
  });
}

// ─────────────────────────────────────────────
// Reality Calculator Logic
// ─────────────────────────────────────────────

class _RealityCalculator {
  static RealityResult calculate({
    required double productPrice,
    required double monthlySalary,
    required double spendingLimit,
    required double savingsGoal,
    required double totalSpent,
    required bool isDark,
  }) {
    final remainingBudget = spendingLimit - totalSpent;
    final availableAfterSavings =
        monthlySalary - totalSpent - savingsGoal;
    final percentOfSalary = productPrice / monthlySalary;
    final percentOfRemaining =
    remainingBudget > 0 ? productPrice / remainingBudget : 999;
    final wouldExceedLimit =
        (totalSpent + productPrice) > spendingLimit;
    final wouldExceedSavings =
        availableAfterSavings - productPrice < 0;

    // ── Score calculation (higher = healthier) ──
    double score = 1.0;

    if (wouldExceedLimit) score -= 0.45;
    if (wouldExceedSavings) score -= 0.25;
    if (percentOfSalary > 0.3) score -= 0.15;
    if (percentOfSalary > 0.5) score -= 0.15;
    if (percentOfRemaining > 0.7) score -= 0.10;
    if (percentOfRemaining > 1.0) score -= 0.20;
    score = score.clamp(0.0, 1.0);

    // ── Verdict ──
    if (score >= 0.70) {
      return RealityResult(
        verdict: 'Safe Purchase',
        headline: 'Go ahead, you\'ve got this! ✅',
        message:
        'This purchase fits comfortably within your budget. '
            'Your spending limit has enough room and your savings goal '
            'remains intact. You\'re being financially responsible.',
        advice:
        'Great choice! Consider if you still want to wait for a sale '
            'to save even more — but you\'re in a safe zone.',
        color: AppTheme.safeGreen,
        dimColor: isDark ? AppTheme.safeGreenDim : AppTheme.safeGreen.withOpacity(0.1),
        icon: Icons.check_circle_rounded,
        score: score,
      );
    } else if (score >= 0.40) {
      return RealityResult(
        verdict: 'Think Before Buying',
        headline: 'Pause and reflect first 🤔',
        message:
        'This purchase is on the edge of your comfort zone. '
            'It may stretch your spending limit or impact your savings goal. '
            'Ask yourself — do you truly need this right now?',
        advice:
        'Try waiting 48 hours. If you still feel the same, '
            'check if there\'s a cheaper alternative or wait for next month\'s budget.',
        color: AppTheme.warningAmber,
        dimColor: isDark ? AppTheme.warningAmberDim : AppTheme.warningAmber.withOpacity(0.1),
        icon: Icons.psychology_rounded,
        score: score,
      );
    } else {
      return RealityResult(
        verdict: 'Better Wait',
        headline: 'Hold on — your wallet disagrees ⛔',
        message:
        'This purchase would significantly strain your finances. '
            'It either exceeds your spending limit, eats into your savings goal, '
            'or takes up too large a portion of your monthly salary.',
        advice:
        'Save for it over 2–3 months, look for a more affordable '
            'alternative, or re-evaluate if this is truly a priority right now.',
        color: AppTheme.dangerRed,
        dimColor: isDark ? AppTheme.dangerRedDim : AppTheme.dangerRed.withOpacity(0.1),
        icon: Icons.cancel_rounded,
        score: score,
      );
    }
  }
}

// ─────────────────────────────────────────────
// Result Screen
// ─────────────────────────────────────────────

class ResultScreen extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String platform;
  final String purchaseType;
  final String category;
  final double monthlySalary;
  final double spendingLimit;
  final double savingsGoal;
  final double totalSpent;
  final String? productUrl;
  final String? notes;

  const ResultScreen({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.platform,
    required this.purchaseType,
    required this.category,
    required this.monthlySalary,
    required this.spendingLimit,
    required this.savingsGoal,
    required this.totalSpent,
    this.productUrl,
    this.notes,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {

  late RealityResult _result;

  // ── Animation Controllers ──
  late AnimationController _heroController;
  late AnimationController _contentController;
  late AnimationController _scoreController;
  late AnimationController _pulseController;
  late AnimationController _orbController;
  late AnimationController _confettiController;

  // ── Hero ──
  late Animation<double> _heroScale;
  late Animation<double> _heroOpacity;
  late Animation<double> _iconBounce;

  // ── Content ──
  late Animation<double> _verdictOpacity;
  late Animation<Offset> _verdictSlide;
  late Animation<double> _messageOpacity;
  late Animation<Offset> _messageSlide;
  late Animation<double> _breakdownOpacity;
  late Animation<Offset> _breakdownSlide;
  late Animation<double> _actionsOpacity;
  late Animation<Offset> _actionsSlide;

  // ── Score ring ──
  late Animation<double> _scoreAnim;

  // ── Pulse glow ──
  late Animation<double> _pulseAnim;

  // ── Orbs ──
  late Animation<double> _orbAnim;

  // ── Confetti particles ──
  late Animation<double> _confettiAnim;
  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _computeResult();
    _generateParticles();
    _setupAnimations();
    _playSequence();
  }

  void _computeResult() {
    _result = _RealityCalculator.calculate(
      productPrice: widget.productPrice,
      monthlySalary: widget.monthlySalary,
      spendingLimit: widget.spendingLimit,
      savingsGoal: widget.savingsGoal,
      totalSpent: widget.totalSpent,
      isDark: true, // resolved later in build
    );
  }

  void _generateParticles() {
    if (_result.score < 0.70) return; // only for safe results
    for (int i = 0; i < 18; i++) {
      _particles.add(_ConfettiParticle(
        x: (i / 18) + (i % 3) * 0.1,
        delay: i * 0.04,
        color: [
          AppTheme.safeGreen,
          AppTheme.primaryColor,
          AppTheme.accentColor,
          AppTheme.warningAmber,
          Colors.white,
        ][i % 5],
        size: 5.0 + (i % 4) * 2.0,
      ));
    }
  }

  void _setupAnimations() {
    // ── Hero ──
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heroScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 0.94)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_heroController);

    _heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _iconBounce = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -18.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -18.0, end: 6.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 6.0, end: -6.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -6.0, end: 0.0),
        weight: 20,
      ),
    ]).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );

    // ── Content stagger ──
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _verdictOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _verdictSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    ));

    _messageOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _messageSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 0.65, curve: Curves.easeOutCubic),
    ));

    _breakdownOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOut),
      ),
    );
    _breakdownSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
    ));

    _actionsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );
    _actionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
    ));

    // ── Score ring ──
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scoreAnim = Tween<double>(begin: 0.0, end: _result.score).animate(
      CurvedAnimation(
        parent: _scoreController,
        curve: Curves.easeOutCubic,
      ),
    );

    // ── Pulse glow ──
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
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

    // ── Confetti ──
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _confettiAnim = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    );
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    // Hero icon entrance
    _heroController.forward();
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    // Content stagger
    _contentController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Score ring fills
    _scoreController.forward();

    // Confetti for safe
    if (_result.score >= 0.70) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _confettiController.forward();
    }
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _scoreController.dispose();
    _pulseController.dispose();
    _orbController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Recompute with correct isDark
    _result = _RealityCalculator.calculate(
      productPrice: widget.productPrice,
      monthlySalary: widget.monthlySalary,
      spendingLimit: widget.spendingLimit,
      savingsGoal: widget.savingsGoal,
      totalSpent: widget.totalSpent,
      isDark: isDark,
    );

    return Scaffold(
      backgroundColor:
      isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: Stack(
        children: [
          _buildBackground(isDark),
          _buildOrbs(isDark, size),
          if (_result.score >= 0.70) _buildConfetti(size),
          _buildContent(isDark, size),
        ],
      ),
    );
  }

  // ── Background ──
  Widget _buildBackground(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.4),
          radius: 1.0,
          colors: isDark
              ? [
            _result.color.withOpacity(0.08),
            AppTheme.darkBackground,
          ]
              : [
            _result.color.withOpacity(0.05),
            AppTheme.lightBackground,
          ],
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
            top: -60,
            right: -40,
            child: Transform.translate(
              offset: Offset(0, _orbAnim.value * 22),
              child: Container(
                width: size.width * 0.55,
                height: size.width * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _result.color.withOpacity(0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: -50,
            child: Transform.translate(
              offset: Offset(0, -_orbAnim.value * 16),
              child: Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _result.color.withOpacity(0.07),
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

  // ── Confetti ──
  Widget _buildConfetti(Size size) {
    return AnimatedBuilder(
      animation: _confettiAnim,
      builder: (_, __) {
        return Stack(
          children: _particles.map((p) {
            final progress =
            (_confettiAnim.value - p.delay).clamp(0.0, 1.0);
            if (progress == 0) return const SizedBox.shrink();

            return Positioned(
              left: p.x * size.width,
              top: -20 + (progress * size.height * 0.55),
              child: Opacity(
                opacity: (1.0 - progress * 0.8).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: progress * 6.28 * (p.x > 0.5 ? 1 : -1),
                  child: Container(
                    width: p.size,
                    height: p.size,
                    decoration: BoxDecoration(
                      color: p.color,
                      shape: p.x > 0.5
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: p.x > 0.5
                          ? BorderRadius.circular(2)
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ── Main Content ──
  Widget _buildContent(bool isDark, Size size) {
    return SafeArea(
      child: Column(
        children: [
          // AppBar
          _buildAppBar(isDark),

          // Scrollable
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingMd),

                  // Hero section
                  _buildHeroSection(isDark),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Verdict card
                  FadeTransition(
                    opacity: _verdictOpacity,
                    child: SlideTransition(
                      position: _verdictSlide,
                      child: _buildVerdictCard(isDark),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Message + advice
                  FadeTransition(
                    opacity: _messageOpacity,
                    child: SlideTransition(
                      position: _messageSlide,
                      child: _buildMessageCard(isDark),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Financial breakdown
                  FadeTransition(
                    opacity: _breakdownOpacity,
                    child: SlideTransition(
                      position: _breakdownSlide,
                      child: _buildBreakdownCard(isDark),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Purchase details
                  FadeTransition(
                    opacity: _breakdownOpacity,
                    child: SlideTransition(
                      position: _breakdownSlide,
                      child: _buildPurchaseDetails(isDark),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXl),

                  // Action buttons
                  FadeTransition(
                    opacity: _actionsOpacity,
                    child: SlideTransition(
                      position: _actionsSlide,
                      child: _buildActions(isDark),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXxl),
                ],
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
          const Spacer(),
          Text(
            'Reality Check Result',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          const ThemeToggleButton(),
        ],
      ),
    );
  }

  // ── Hero Section ──
  Widget _buildHeroSection(bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_heroController, _pulseController]),
      builder: (_, __) {
        return Column(
          children: [
            // Glow ring + icon
            Transform.scale(
              scale: _heroScale.value,
              child: Opacity(
                opacity: _heroOpacity.value.clamp(0.0, 1.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                      width: 140 + (_pulseAnim.value * 14),
                      height: 140 + (_pulseAnim.value * 14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _result.color.withOpacity(
                                0.18 * _pulseAnim.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Score ring
                    SizedBox(
                      width: 116,
                      height: 116,
                      child: AnimatedBuilder(
                        animation: _scoreAnim,
                        builder: (_, __) {
                          return CustomPaint(
                            painter: _ScoreRingPainter(
                              progress: _scoreAnim.value,
                              color: _result.color,
                              backgroundColor: isDark
                                  ? AppTheme.darkCardElevated
                                  : AppTheme.lightCardElevated,
                            ),
                          );
                        },
                      ),
                    ),

                    // Icon
                    Transform.translate(
                      offset: Offset(0, _iconBounce.value),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: _result.dimColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _result.color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _result.icon,
                          size: 42,
                          color: _result.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingMd),

            // Score label
            AnimatedBuilder(
              animation: _scoreAnim,
              builder: (_, __) {
                return Text(
                  '${(_scoreAnim.value * 100).toInt()}% Financial Health',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _result.color,
                    letterSpacing: 0.3,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // ── Verdict Card ──
  Widget _buildVerdictCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: _result.dimColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: _result.color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Verdict badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: _result.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_result.icon, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  _result.verdict,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Headline
          Text(
            _result.headline,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppTheme.darkTextPrimary
                  : AppTheme.lightTextPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingSm),

          // Product info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 13,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${_fmt(widget.productPrice)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _result.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Message Card ──
  Widget _buildMessageCard(bool isDark) {
    return Container(
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
          // Analysis header
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _result.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  size: 16,
                  color: _result.color,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Analysis',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          Text(
            _result.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.65,
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Divider
          Container(
            height: 1,
            color: isDark ? AppTheme.darkDivider : AppTheme.lightDivider,
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Advice row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  size: 14,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Advice',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _result.advice,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Financial Breakdown Card ──
  Widget _buildBreakdownCard(bool isDark) {
    final remaining = widget.spendingLimit - widget.totalSpent;
    final afterPurchase = remaining - widget.productPrice;
    final percentOfSalary =
    (widget.productPrice / widget.monthlySalary * 100)
        .clamp(0, 100);

    return Container(
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
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  size: 16,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Financial Breakdown',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          _breakdownRow(
            isDark,
            label: 'Monthly Salary',
            value: '₹${_fmt(widget.monthlySalary)}',
            color: AppTheme.primaryColor,
            icon: Icons.payments_rounded,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: 'Spending Limit',
            value: '₹${_fmt(widget.spendingLimit)}',
            color: AppTheme.accentColor,
            icon: Icons.credit_card_rounded,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: 'Already Spent',
            value: '₹${_fmt(widget.totalSpent)}',
            color: AppTheme.warningAmber,
            icon: Icons.arrow_upward_rounded,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: 'Budget Remaining',
            value: '₹${_fmt(remaining)}',
            color: remaining > 0 ? AppTheme.safeGreen : AppTheme.dangerRed,
            icon: Icons.account_balance_wallet_rounded,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: 'Item Price',
            value: '₹${_fmt(widget.productPrice)}',
            color: _result.color,
            icon: Icons.shopping_bag_rounded,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: 'After Purchase',
            value: '₹${_fmt(afterPurchase)}',
            color: afterPurchase >= 0
                ? AppTheme.safeGreen
                : AppTheme.dangerRed,
            icon: afterPurchase >= 0
                ? Icons.check_rounded
                : Icons.warning_rounded,
            isBold: true,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: '% of Salary',
            value: '${percentOfSalary.toStringAsFixed(1)}%',
            color: percentOfSalary < 20
                ? AppTheme.safeGreen
                : percentOfSalary < 40
                ? AppTheme.warningAmber
                : AppTheme.dangerRed,
            icon: Icons.percent_rounded,
          ),
          _breakdownDivider(isDark),
          _breakdownRow(
            isDark,
            label: 'Savings Goal',
            value: '₹${_fmt(widget.savingsGoal)}',
            color: isDark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary,
            icon: Icons.savings_rounded,
          ),
        ],
      ),
    );
  }

  Widget _breakdownRow(
      bool isDark, {
        required String label,
        required String value,
        required Color color,
        required IconData icon,
        bool isBold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownDivider(bool isDark) {
    return Container(
      height: 1,
      color: isDark
          ? AppTheme.darkDivider
          : AppTheme.lightDivider,
    );
  }

  // ── Purchase Details ──
  Widget _buildPurchaseDetails(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Purchase Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _detailRow(isDark, 'Product', widget.productName),
          _detailRow(isDark, 'Type', widget.purchaseType),
          _detailRow(isDark, 'Platform', widget.platform),
          _detailRow(isDark, 'Category', widget.category),
          _detailRow(
            isDark,
            'Date',
            _formatDate(DateTime.now()),
          ),
          if (widget.notes != null && widget.notes!.isNotEmpty)
            _detailRow(isDark, 'Notes', widget.notes!),
        ],
      ),
    );
  }

  Widget _detailRow(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ──
  Widget _buildActions(bool isDark) {
    return Column(
      children: [
        // Check another
        CustomButton(
          label: 'Check Another Purchase',
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const PurchaseScreen(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
              ),
                  (route) => route.isFirst,
            );
          },
          variant: ButtonVariant.primary,
          prefixIcon: Icons.refresh_rounded,
          hasGlow: true,
        ),

        const SizedBox(height: AppTheme.spacingMd),

        // View history
        CustomButton(
          label: 'View History',
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HistoryScreen(),
              ),
            );
          },
          variant: ButtonVariant.secondary,
          prefixIcon: Icons.history_rounded,
        ),

        const SizedBox(height: AppTheme.spacingMd),

        // Share result
        CustomButton(
          label: 'Share Result',
          onPressed: () {
            HapticFeedback.lightImpact();
            _shareResult();
          },
          variant: ButtonVariant.ghost,
          prefixIcon: Icons.share_rounded,
        ),
      ],
    );
  }

  // ── Share Result ──
  void _shareResult() {
    final text =
        '🧾 Reality Check Result\n\n'
        'Product: ${widget.productName}\n'
        'Price: ₹${_fmt(widget.productPrice)}\n'
        'Verdict: ${_result.verdict}\n\n'
        '${_result.headline}\n\n'
        'Checked with Reality Check Purchase App';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, maxLines: 3, overflow: TextOverflow.ellipsis),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        margin: const EdgeInsets.all(AppTheme.spacingMd),
        duration: const Duration(seconds: 3),
      ),
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

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

// ─────────────────────────────────────────────
// Score Ring Painter
// ─────────────────────────────────────────────

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    const strokeWidth = 7.0;
    const startAngle = -1.5708; // -π/2 (12 o'clock)

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progress * 2 * 3.14159,
      false,
      fgPaint,
    );

    // Glow layer
    final glowPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progress * 2 * 3.14159,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
// Confetti Particle Model
// ─────────────────────────────────────────────

class _ConfettiParticle {
  final double x;
  final double delay;
  final Color color;
  final double size;

  const _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.color,
    required this.size,
  });
}