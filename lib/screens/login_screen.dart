import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  // ── Form ──
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameFocus = FocusNode();

  // ── State ──
  bool _isLogin = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  // ── Animation Controllers ──
  late AnimationController _entranceController;
  late AnimationController _formSwitchController;
  late AnimationController _orbController;
  late AnimationController _shakeController;

  // ── Entrance Animations ──
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _footerOpacity;

  // ── Form Switch ──
  late Animation<double> _formOpacity;
  late Animation<Offset> _formSlide;

  // ── Orb float ──
  late Animation<double> _orbAnim;

  // ── Shake (wrong credentials) ──
  late Animation<double> _shakeAnim;

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
      duration: const Duration(milliseconds: 900),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
      ),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Form Switch ──
    _formSwitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _formSwitchController,
        curve: Curves.easeOut,
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _formSwitchController,
        curve: Curves.easeOutCubic,
      ),
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

    // ── Shake ──
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  void _playEntrance() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _entranceController.forward();
    _formSwitchController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _entranceController.dispose();
    _formSwitchController.dispose();
    _orbController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  // ── Toggle Login / Register ──
  void _toggleMode() async {
    HapticFeedback.selectionClick();
    await _formSwitchController.reverse();
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
    _formSwitchController.forward();
  }

  // ── Submit ──
  Future<void> _handleSubmit() async {

    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeController.forward(from: 0);
      HapticFeedback.mediumImpact();
      return;
    }

    setState(() => _isLoading = true);

    HapticFeedback.lightImpact();

    try {

      // ───────────── LOGIN ─────────────
      if (_isLogin) {

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

      }

      // ───────────── REGISTER ─────────────
      else {

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

      }

      if (!mounted) return;

      setState(() => _isLoading = false);

      // ───────────── NAVIGATE ─────────────
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, anim, __, child) {

            return FadeTransition(
              opacity: anim,

              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.04),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    curve: Curves.easeOutCubic,
                    parent: anim,
                  ),
                ),

                child: child,
              ),
            );
          },
        ),
      );

    }

    // ───────────── FIREBASE ERRORS ─────────────
    on FirebaseAuthException catch (e) {

      if (mounted) {
        setState(() => _isLoading = false);
      }

      String message = 'Authentication failed';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      }

      else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      }

      else if (e.code == 'email-already-in-use') {
        message = 'Email already registered';
      }

      else if (e.code == 'weak-password') {
        message = 'Password must be at least 6 characters';
      }

      else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      _shakeController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    // ───────────── OTHER ERRORS ─────────────
    catch (e) {

      if (mounted) {
        setState(() => _isLoading = false);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
  // ── Google Sign In (UI only) ──
  void _handleGoogleSignIn() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Google Sign-In coming soon'),
          ],
        ),
        backgroundColor: AppTheme.darkCardElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        margin: const EdgeInsets.all(AppTheme.spacingMd),
        duration: const Duration(seconds: 2),
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
          // ── Background ──
          _buildBackground(isDark, size),

          // ── Floating Orbs ──
          _buildOrbs(size),

          // ── Scrollable Content ──
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildHeader(isDark),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildCard(isDark),
                      const Spacer(),
                      const SizedBox(height: AppTheme.spacingLg),
                      _buildFooter(isDark),
                      const SizedBox(height: AppTheme.spacingXl),
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

  // ── Background ──
  Widget _buildBackground(bool isDark, Size size) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const RadialGradient(
          center: Alignment(0.0, -0.5),
          radius: 1.0,
          colors: [
            Color(0xFF160D2E),
            AppTheme.darkBackground,
          ],
        )
            : const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0EFFE),
            AppTheme.lightBackground,
          ],
        ),
      ),
    );
  }

  // ── Orbs ──
  Widget _buildOrbs(Size size) {
    return AnimatedBuilder(
      animation: _orbAnim,
      builder: (_, __) {
        return Stack(
          children: [
            Positioned(
              top: -size.width * 0.2,
              right: -size.width * 0.2,
              child: Transform.translate(
                offset: Offset(0, _orbAnim.value * 20),
                child: Container(
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.1,
              left: -size.width * 0.25,
              child: Transform.translate(
                offset: Offset(0, -_orbAnim.value * 15),
                child: Container(
                  width: size.width * 0.55,
                  height: size.width * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentColor.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Header ──
  Widget _buildHeader(bool isDark) {
    return FadeTransition(
      opacity: _headerOpacity,
      child: SlideTransition(
        position: _headerSlide,
        child: Column(
          children: [
            // Mini logo
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.glowGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.balance_rounded,
                size: 26,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Text(
                _isLogin ? 'Welcome Back' : 'Create Account',
                key: ValueKey(_isLogin),
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppTheme.spacingSm),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _isLogin
                    ? 'Sign in to your Reality Check account'
                    : 'Start making smarter purchase decisions',
                key: ValueKey('sub_$_isLogin'),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main Card ──
  Widget _buildCard(bool isDark) {
    return FadeTransition(
      opacity: _cardOpacity,
      child: SlideTransition(
        position: _cardSlide,
        child: AnimatedBuilder(
          animation: _shakeAnim,
          builder: (_, child) => Transform.translate(
            offset: Offset(_shakeAnim.value, 0),
            child: child,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              border: Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                width: 1,
              ),
              boxShadow: AppTheme.cardShadow(isDark),
            ),
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Form(
              key: _formKey,
              child: FadeTransition(
                opacity: _formOpacity,
                child: SlideTransition(
                  position: _formSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Mode Tabs ──
                      _buildModeTabs(isDark),
                      const SizedBox(height: AppTheme.spacingLg),

                      // ── Name field (register only) ──
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: !_isLogin
                            ? Column(
                          children: [
                            CustomTextField(
                              label: 'Full Name',
                              hint: 'Vanjani Om',
                              controller: _nameController,
                              fieldType: FieldType.text,
                              prefixIcon: Icons.person_outline_rounded,
                              focusNode: _nameFocus,
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  FieldValidators.required(
                                    val,
                                    fieldName: 'Full name',
                                  ),
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_emailFocus),
                            ),
                            const SizedBox(height: AppTheme.spacingMd),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),

                      // ── Email ──
                      CustomTextField(
                        label: 'Email Address',
                        hint: 'you@example.com',
                        controller: _emailController,
                        fieldType: FieldType.text,
                        prefixIcon: Icons.mail_outline_rounded,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        validator: FieldValidators.email,
                        onSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_passwordFocus),
                      ),

                      const SizedBox(height: AppTheme.spacingMd),

                      // ── Password ──
                      CustomTextField(
                        label: 'Password',
                        hint: 'Min. 6 characters',
                        controller: _passwordController,
                        fieldType: FieldType.password,
                        prefixIcon: Icons.lock_outline_rounded,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        validator: FieldValidators.password,
                        onSubmitted: (_) => _handleSubmit(),
                      ),

                      // ── Remember Me / Forgot Password ──
                      const SizedBox(height: AppTheme.spacingMd),
                      _buildRememberRow(isDark),
                      const SizedBox(height: AppTheme.spacingLg),

                      // ── Submit Button ──
                      CustomButton(
                        label: _isLogin ? 'Sign In' : 'Create Account',
                        onPressed: _isLoading ? null : _handleSubmit,
                        isLoading: _isLoading,
                        hasGlow: true,
                        prefixIcon: _isLogin
                            ? Icons.login_rounded
                            : Icons.person_add_rounded,
                      ),

                      const SizedBox(height: AppTheme.spacingMd),

                      // ── Divider ──
                      _buildDivider(isDark),

                      const SizedBox(height: AppTheme.spacingMd),

                      // ── Google Button ──
                      _buildGoogleButton(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Mode Tabs (Login / Register) ──
  Widget _buildModeTabs(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardElevated : AppTheme.lightCardElevated,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTab('Sign In', _isLogin, isDark, () {
            if (!_isLogin) _toggleMode();
          }),
          _buildTab('Register', !_isLogin, isDark, () {
            if (_isLogin) _toggleMode();
          }),
        ],
      ),
    );
  }

  Widget _buildTab(
      String label,
      bool isActive,
      bool isDark,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isActive ? AppTheme.primaryGradient() : null,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm + 2),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? Colors.white
                  : (isDark
                  ? AppTheme.darkTextMuted
                  : AppTheme.lightTextMuted),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  // ── Remember Me Row ──
  Widget _buildRememberRow(bool isDark) {
    return Row(
      children: [
        // Remember me
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _rememberMe = !_rememberMe);
          },
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  gradient: _rememberMe ? AppTheme.primaryGradient() : null,
                  color: _rememberMe
                      ? null
                      : (isDark ? AppTheme.darkCardElevated : AppTheme.lightCardElevated),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: _rememberMe
                        ? Colors.transparent
                        : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                    width: 1.5,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Forgot password
        if (_isLogin)
          GestureDetector(
            onTap: () => _showForgotPassword(isDark),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryLight,
              ),
            ),
          ),
      ],
    );
  }

  // ── Divider ──
  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? AppTheme.darkDivider : AppTheme.lightDivider,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? AppTheme.darkDivider : AppTheme.lightDivider,
          ),
        ),
      ],
    );
  }

  // ── Google Button ──
  Widget _buildGoogleButton(bool isDark) {
    return GestureDetector(
      onTap: _handleGoogleSignIn,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCardElevated : AppTheme.lightCardElevated,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google G icon
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.g_mobiledata_rounded,
                size: 26,
                color: Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Footer ──
  Widget _buildFooter(bool isDark) {
    return FadeTransition(
      opacity: _footerOpacity,
      child: Column(
        children: [
          // Toggle mode text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin
                    ? "Don't have an account? "
                    : 'Already have an account? ',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
              GestureDetector(
                onTap: _toggleMode,
                child: Text(
                  _isLogin ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Terms
          Text(
            'By continuing, you agree to our Terms & Privacy Policy',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Forgot Password Sheet ──
  void _showForgotPassword(bool isDark) {
    final resetController = TextEditingController();
    HapticFeedback.lightImpact();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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

              Text(
                'Reset Password',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                'We\'ll send a reset link to your email.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingLg),

              CustomTextField(
                label: 'Email Address',
                hint: 'you@example.com',
                controller: resetController,
                fieldType: FieldType.text,
                prefixIcon: Icons.mail_outline_rounded,
                validator: FieldValidators.email,
                autofocus: true,
              ),

              const SizedBox(height: AppTheme.spacingLg),

              CustomButton(
                label: 'Send Reset Link',
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: AppTheme.safeGreen, size: 16),
                          SizedBox(width: 8),
                          Text('Reset link sent!'),
                        ],
                      ),
                      backgroundColor: isDark
                          ? AppTheme.darkCardElevated
                          : AppTheme.lightCard,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      margin: const EdgeInsets.all(AppTheme.spacingMd),
                    ),
                  );
                },
                prefixIcon: Icons.send_rounded,
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
    );
  }
}