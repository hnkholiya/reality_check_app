import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Animation Controllers ──
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _progressController;
  late AnimationController _exitController;

  // ── Logo Animations ──
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotate;
  late Animation<double> _glowPulse;

  // ── Text Animations ──
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleSlide;

  // ── Tagline Animations ──
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  // ── Progress ──
  late Animation<double> _progressAnim;

  // ── Exit ──
  late Animation<double> _exitOpacity;
  late Animation<double> _exitScale;

  // ── Orb Particles ──
  late AnimationController _orbController;
  late Animation<double> _orbAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // Logo — bouncy entrance
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_logoController);

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Glow pulse — looping after logo appears
    _glowPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Title text
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Tagline
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Exit fade + shrink
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _exitScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    // Floating orbs — continuous loop
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _orbAnim = CurvedAnimation(parent: _orbController, curve: Curves.easeInOut);
  }

  Future<void> _startSequence() async {
    // Immersive dark status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Step 1 — Logo entrance
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _logoController.forward();

    // Step 2 — Title slides in
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _textController.forward();

    // Step 3 — Tagline appears
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineController.forward();

    // Step 4 — Progress bar fills
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _progressController.forward();

    // Step 5 — Wait for progress then exit
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    await _exitController.forward();

    // Step 6 — Navigate to login
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(curve: Curves.easeOutCubic, parent: animation),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _progressController.dispose();
    _exitController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  // ── Floating Orb Widget ──
  Widget _buildOrb({
    required double size,
    required Color color,
    required AlignmentGeometry alignment,
    required Animation<double> anim,
    required double verticalShift,
    double opacity = 0.18,
  }) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: Offset(0, anim.value * verticalShift),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(opacity),
                    color.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Logo Widget ──
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (_, __) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotate.value,
            child: Opacity(
              opacity: _logoOpacity.value.clamp(0.0, 1.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow ring
                  AnimatedBuilder(
                    animation: _orbController,
                    builder: (_, __) {
                      return Container(
                        width: 120 + (_orbAnim.value * 10),
                        height: 120 + (_orbAnim.value * 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.25),
                              AppTheme.primaryColor.withOpacity(0.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Main logo container
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.glowGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.25),
                          blurRadius: 50,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),

                  // Orbit ring
                  IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _orbController,
                      builder: (_, __) {
                        return Transform.rotate(
                          angle: _orbAnim.value * 0.5,
                          child: Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(
                                  0.15 + (_orbAnim.value * 0.1),
                                ),
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Progress Bar ──
  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnim,
      builder: (context, _) {
        return Column(
          children: [
            // Bar track
            Container(
              height: 3,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _progressAnim.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.glowGradient,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusFull),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Loading label
            Text(
              _progressLabel(_progressAnim.value),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.45),
                letterSpacing: 1.2,
              ),
            ),
          ],
        );
      },
    );
  }

  String _progressLabel(double progress) {
    if (progress < 0.33) return 'INITIALIZING...';
    if (progress < 0.66) return 'LOADING PROFILE...';
    if (progress < 0.90) return 'ALMOST READY...';
    return 'WELCOME';
  }

  // ── Reality Check Badge ──
  Widget _buildRealityBadge() {
    return FadeTransition(
      opacity: _taglineOpacity,
      child: SlideTransition(
        position: _taglineSlide,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.safeGreen,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.safeGreen.withOpacity(0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Smart Financial Decisions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Three Result Pills ──
  Widget _buildResultPills() {
    return FadeTransition(
      opacity: _taglineOpacity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pill('Safe Purchase', AppTheme.safeGreen),
          const SizedBox(width: 8),
          _pill('Think Before', AppTheme.warningAmber),
          const SizedBox(width: 8),
          _pill('Better Wait', AppTheme.dangerRed),
        ],
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _exitController,
      builder: (context, child) {
        return Opacity(
          opacity: _exitOpacity.value,
          child: Transform.scale(
            scale: _exitScale.value,
            child: child,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: Stack(
          children: [

            // ── Background Gradient ──
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.3),
                  radius: 1.2,
                  colors: [
                    Color(0xFF1A0D3D),
                    Color(0xFF0A0A0F),
                  ],
                ),
              ),
            ),

            // ── Floating Orbs ──
            _buildOrb(
              size: size.width * 0.7,
              color: AppTheme.primaryColor,
              alignment: const Alignment(-0.8, -0.8),
              anim: _orbAnim,
              verticalShift: -30,
              opacity: 0.12,
            ),
            _buildOrb(
              size: size.width * 0.5,
              color: AppTheme.accentColor,
              alignment: const Alignment(0.9, 0.5),
              anim: _orbAnim,
              verticalShift: 25,
              opacity: 0.10,
            ),
            _buildOrb(
              size: size.width * 0.4,
              color: AppTheme.primaryLight,
              alignment: const Alignment(0.2, 1.0),
              anim: _orbAnim,
              verticalShift: 20,
              opacity: 0.08,
            ),

            // ── Main Content ──
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  _buildLogo(),
                  const SizedBox(height: AppTheme.spacingXl),

                  // App Name
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppTheme.glowGradient.createShader(bounds),
                            child: const Text(
                              'Reality Check',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -1.0,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const Text(
                            'PURCHASE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 6.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Subtitle
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: SlideTransition(
                      position: _subtitleSlide,
                      child: Text(
                        'Buy smarter. Save better.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.55),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXl),

                  // Reality badge
                  _buildRealityBadge(),

                  const SizedBox(height: AppTheme.spacingMd),

                  // Result pills
                  _buildResultPills(),

                  const Spacer(flex: 2),

                  // Progress bar
                  _buildProgressBar(),

                  const SizedBox(height: AppTheme.spacingXl),

                  // Bottom caption
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: Text(
                      'Powered by financial intelligence',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.25),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom +
                        AppTheme.spacingLg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}