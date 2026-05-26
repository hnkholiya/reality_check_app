import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {

  // ── User Data (mock — replace with Firebase) ──
  String _name = 'Vanjani Om';
  String _email = 'vanjani@example.com';
  String _phone = '+91 98765 43210';
  double _monthlySalary = 65000;
  double _spendingLimit = 20000;
  double _savingsGoal = 15000;
  String _currency = '₹ INR';
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _weeklyReportEnabled = true;
  String _selectedAvatar = '👨‍💻';

  // ── Edit State ──
  bool _isEditingProfile = false;
  bool _isEditingBudget = false;

  // ── Controllers ──
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _salaryCtrl;
  late TextEditingController _limitCtrl;
  late TextEditingController _savingsCtrl;

  final _profileFormKey = GlobalKey<FormState>();
  final _budgetFormKey = GlobalKey<FormState>();

  // ── Avatars ──
  final List<String> _avatars = [
    '👨‍💻', '👩‍💻', '🧑‍💼', '👨‍🎓', '👩‍🎓',
    '🧑‍🎨', '👨‍🔬', '👩‍🔬', '🧑‍🚀', '👾',
  ];

  // ── Stats (mock) ──
  final int _totalChecks = 12;
  final int _safePurchases = 7;
  final double _moneySaved = 42500;
  final double _avgScore = 0.71;
  final int _streakDays = 14;

  // ── Animation Controllers ──
  late AnimationController _entranceController;
  late AnimationController _avatarController;
  late AnimationController _orbController;
  late AnimationController _editController;

  // ── Entrance ──
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _statsOpacity;
  late Animation<Offset> _statsSlide;
  late Animation<double> _sectionsOpacity;
  late Animation<Offset> _sectionsSlide;

  // ── Avatar ──
  late Animation<double> _avatarScale;
  late Animation<double> _avatarGlow;

  // ── Orbs ──
  late Animation<double> _orbAnim;

  // ── Edit panel ──
  late Animation<double> _editOpacity;
  late Animation<Offset> _editSlide;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _setupAnimations();
    _playEntrance();
  }

  void _initControllers() {
    _nameCtrl = TextEditingController(text: _name);
    _emailCtrl = TextEditingController(text: _email);
    _phoneCtrl = TextEditingController(text: _phone);
    _salaryCtrl =
        TextEditingController(text: _monthlySalary.toStringAsFixed(0));
    _limitCtrl =
        TextEditingController(text: _spendingLimit.toStringAsFixed(0));
    _savingsCtrl =
        TextEditingController(text: _savingsGoal.toStringAsFixed(0));
  }

  void _setupAnimations() {
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

    _statsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
      ),
    );
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.70, curve: Curves.easeOutCubic),
    ));

    _sectionsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
      ),
    );
    _sectionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.4, 0.90, curve: Curves.easeOutCubic),
    ));

    // ── Avatar ──
    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _avatarScale = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );
    _avatarGlow = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
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

    // ── Edit panel ──
    _editController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _editOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _editController, curve: Curves.easeOut),
    );
    _editSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _editController, curve: Curves.easeOutCubic),
    );
  }

  void _playEntrance() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _entranceController.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _salaryCtrl.dispose();
    _limitCtrl.dispose();
    _savingsCtrl.dispose();
    _entranceController.dispose();
    _avatarController.dispose();
    _orbController.dispose();
    _editController.dispose();
    super.dispose();
  }

  // ── Toggle edit profile ──
  void _toggleEditProfile() async {
    HapticFeedback.selectionClick();
    if (_isEditingProfile) {
      await _editController.reverse();
      setState(() => _isEditingProfile = false);
    } else {
      setState(() {
        _isEditingProfile = true;
        _isEditingBudget = false;
      });
      _editController.forward(from: 0);
    }
  }

  // ── Toggle edit budget ──
  void _toggleEditBudget() async {
    HapticFeedback.selectionClick();
    if (_isEditingBudget) {
      await _editController.reverse();
      setState(() => _isEditingBudget = false);
    } else {
      setState(() {
        _isEditingBudget = true;
        _isEditingProfile = false;
      });
      _editController.forward(from: 0);
    }
  }

  // ── Save profile ──
  void _saveProfile() {
    if (!(_profileFormKey.currentState?.validate() ?? false)) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _name = _nameCtrl.text.trim();
      _email = _emailCtrl.text.trim();
      _phone = _phoneCtrl.text.trim();
      _isEditingProfile = false;
    });
    _editController.reverse();
    _showSuccessSnack('Profile updated successfully');
  }

  // ── Save budget ──
  void _saveBudget() {
    if (!(_budgetFormKey.currentState?.validate() ?? false)) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _monthlySalary =
          double.tryParse(_salaryCtrl.text) ?? _monthlySalary;
      _spendingLimit =
          double.tryParse(_limitCtrl.text) ?? _spendingLimit;
      _savingsGoal =
          double.tryParse(_savingsCtrl.text) ?? _savingsGoal;
      _isEditingBudget = false;
    });
    _editController.reverse();
    _showSuccessSnack('Budget settings saved');
  }

  void _showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppTheme.safeGreen, size: 16),
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
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
          _buildBackground(isDark),
          _buildOrbs(isDark, size),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── AppBar ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerOpacity,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _buildAppBar(isDark),
                    ),
                  ),
                ),

                // ── Profile Hero ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerOpacity,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _buildProfileHero(isDark),
                    ),
                  ),
                ),

                // ── Achievement Stats ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _statsOpacity,
                    child: SlideTransition(
                      position: _statsSlide,
                      child: _buildAchievements(isDark),
                    ),
                  ),
                ),

                // ── Budget Overview ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _statsOpacity,
                    child: SlideTransition(
                      position: _statsSlide,
                      child: _buildBudgetOverview(isDark),
                    ),
                  ),
                ),

                // ── Edit Profile Panel ──
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    child: _isEditingProfile
                        ? FadeTransition(
                      opacity: _editOpacity,
                      child: SlideTransition(
                        position: _editSlide,
                        child: _buildEditProfilePanel(isDark),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ),

                // ── Edit Budget Panel ──
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    child: _isEditingBudget
                        ? FadeTransition(
                      opacity: _editOpacity,
                      child: SlideTransition(
                        position: _editSlide,
                        child: _buildEditBudgetPanel(isDark),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ),

                // ── Settings Sections ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _sectionsOpacity,
                    child: SlideTransition(
                      position: _sectionsSlide,
                      child: _buildSettingsSections(isDark),
                    ),
                  ),
                ),

                // ── Danger Zone ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _sectionsOpacity,
                    child: SlideTransition(
                      position: _sectionsSlide,
                      child: _buildDangerZone(isDark),
                    ),
                  ),
                ),

                // ── Sign Out ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _sectionsOpacity,
                    child: SlideTransition(
                      position: _sectionsSlide,
                      child: _buildSignOut(isDark),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 60),
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
          center: Alignment(0, -0.6),
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
            right: -30,
            child: Transform.translate(
              offset: Offset(0, _orbAnim.value * 20),
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
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
          Positioned(
            bottom: 200,
            left: -40,
            child: Transform.translate(
              offset: Offset(0, -_orbAnim.value * 14),
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
            child: Text(
              'My Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const ThemeToggleButton(),
        ],
      ),
    );
  }

  // ── Profile Hero ──
  Widget _buildProfileHero(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingSm,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          gradient: AppTheme.glowGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.30),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            Row(
              children: [
                // Avatar
                AnimatedBuilder(
                  animation: _avatarController,
                  builder: (_, __) => Transform.scale(
                    scale: _avatarScale.value,
                    child: GestureDetector(
                      onTap: () => _showAvatarPicker(isDark),
                      child: Stack(
                        children: [
                          // Glow ring
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(
                                      0.18 * _avatarGlow.value),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          // Avatar container
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _selectedAvatar,
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                          // Edit badge
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 11,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppTheme.spacingMd),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Streak badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius:
                          BorderRadius.circular(AppTheme.radiusFull),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 5),
                            Text(
                              '$_streakDays day streak',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit button
                GestureDetector(
                  onTap: _toggleEditProfile,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _isEditingProfile
                          ? Colors.white
                          : Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _isEditingProfile
                          ? Icons.close_rounded
                          : Icons.edit_rounded,
                      size: 16,
                      color: _isEditingProfile
                          ? AppTheme.primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Achievement Stats ──
  Widget _buildAchievements(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg, 0,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              _achievementCard(
                isDark,
                value: '$_totalChecks',
                label: 'Total\nChecks',
                icon: Icons.fact_check_rounded,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _achievementCard(
                isDark,
                value: '$_safePurchases',
                label: 'Smart\nBuys',
                icon: Icons.check_circle_rounded,
                color: AppTheme.safeGreen,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _achievementCard(
                isDark,
                value: '₹${_fmt(_moneySaved)}',
                label: 'Saved\nTotal',
                icon: Icons.savings_rounded,
                color: AppTheme.accentColor,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _achievementCard(
                isDark,
                value: '${(_avgScore * 100).toInt()}%',
                label: 'Avg\nScore',
                icon: Icons.bar_chart_rounded,
                color: AppTheme.warningAmber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _achievementCard(
      bool isDark, {
        required String value,
        required String label,
        required IconData icon,
        required Color color,
      }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingMd,
          horizontal: AppTheme.spacingXs,
        ),
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
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.15 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
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
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Budget Overview ──
  Widget _buildBudgetOverview(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg, 0,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
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
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Budget Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleEditBudget,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingXs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: _isEditingBudget
                          ? AppTheme.dangerRed.withOpacity(0.12)
                          : AppTheme.primaryColor.withOpacity(0.10),
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(
                        color: _isEditingBudget
                            ? AppTheme.dangerRed.withOpacity(0.3)
                            : AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _isEditingBudget ? 'Cancel' : 'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _isEditingBudget
                            ? AppTheme.dangerRed
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingMd),

            _budgetRow(
              isDark,
              icon: Icons.payments_rounded,
              label: 'Monthly Salary',
              value: '₹${_fmt(_monthlySalary)}',
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _budgetRow(
              isDark,
              icon: Icons.credit_card_rounded,
              label: 'Spending Limit',
              value: '₹${_fmt(_spendingLimit)}',
              color: AppTheme.warningAmber,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _budgetRow(
              isDark,
              icon: Icons.savings_rounded,
              label: 'Savings Goal',
              value: '₹${_fmt(_savingsGoal)}',
              color: AppTheme.safeGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetRow(
      bool isDark, {
        required IconData icon,
        required String label,
        required String value,
        required Color color,
      }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  // ── Edit Profile Panel ──
  Widget _buildEditProfilePanel(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg, 0,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Form(
          key: _profileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.manage_accounts_rounded,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppTheme.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),

              CustomTextField(
                label: 'Full Name',
                hint: 'Your full name',
                controller: _nameCtrl,
                fieldType: FieldType.text,
                prefixIcon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: (val) =>
                    FieldValidators.required(val, fieldName: 'Name'),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              CustomTextField(
                label: 'Email Address',
                hint: 'you@example.com',
                controller: _emailCtrl,
                fieldType: FieldType.text,
                prefixIcon: Icons.mail_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: FieldValidators.email,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              CustomTextField(
                label: 'Phone Number',
                hint: '+91 XXXXX XXXXX',
                controller: _phoneCtrl,
                fieldType: FieldType.text,
                prefixIcon: Icons.phone_outlined,
                textInputAction: TextInputAction.done,
                validator: (val) =>
                    FieldValidators.required(val, fieldName: 'Phone'),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Cancel',
                      onPressed: _toggleEditProfile,
                      variant: ButtonVariant.secondary,
                      size: ButtonSize.medium,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: CustomButton(
                      label: 'Save',
                      onPressed: _saveProfile,
                      variant: ButtonVariant.primary,
                      size: ButtonSize.medium,
                      prefixIcon: Icons.check_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit Budget Panel ──
  Widget _buildEditBudgetPanel(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg, 0,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.safeGreen.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.safeGreen.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Form(
          key: _budgetFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: AppTheme.safeGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Edit Budget',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppTheme.safeGreen),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),

              CurrencyInputField(
                label: 'Monthly Salary',
                controller: _salaryCtrl,
                textInputAction: TextInputAction.next,
                validator: FieldValidators.salary,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              CurrencyInputField(
                label: 'Spending Limit',
                controller: _limitCtrl,
                textInputAction: TextInputAction.next,
                validator: (val) => FieldValidators.spendingLimit(
                  val,
                  salary: double.tryParse(_salaryCtrl.text),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              CurrencyInputField(
                label: 'Savings Goal',
                controller: _savingsCtrl,
                textInputAction: TextInputAction.done,
                validator: (val) => FieldValidators.savingsGoal(
                  val,
                  salary: double.tryParse(_salaryCtrl.text),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Cancel',
                      onPressed: _toggleEditBudget,
                      variant: ButtonVariant.secondary,
                      size: ButtonSize.medium,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: CustomButton(
                      label: 'Save',
                      onPressed: _saveBudget,
                      variant: ButtonVariant.success,
                      size: ButtonSize.medium,
                      prefixIcon: Icons.check_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Settings Sections ──
  Widget _buildSettingsSections(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: Column(
        children: [
          // ── Preferences ──
          _sectionCard(
            isDark,
            title: 'Preferences',
            icon: Icons.settings_rounded,
            iconColor: AppTheme.primaryColor,
            children: [
              _settingsTile(
                isDark,
                icon: Icons.notifications_rounded,
                iconColor: AppTheme.warningAmber,
                title: 'Purchase Notifications',
                subtitle: 'Get alerts for new reality checks',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _notificationsEnabled = val);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _divider(isDark),
              _settingsTile(
                isDark,
                icon: Icons.fingerprint_rounded,
                iconColor: AppTheme.accentColor,
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face ID',
                trailing: Switch(
                  value: _biometricEnabled,
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _biometricEnabled = val);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _divider(isDark),
              _settingsTile(
                isDark,
                icon: Icons.bar_chart_rounded,
                iconColor: AppTheme.safeGreen,
                title: 'Weekly Report',
                subtitle: 'Receive spending summary every week',
                trailing: Switch(
                  value: _weeklyReportEnabled,
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _weeklyReportEnabled = val);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _divider(isDark),
              _settingsTile(
                isDark,
                icon: Icons.currency_rupee_rounded,
                iconColor: AppTheme.primaryColor,
                title: 'Currency',
                subtitle: _currency,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted,
                ),
                onTap: () => _showCurrencySheet(isDark),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // ── Appearance ──
          _sectionCard(
            isDark,
            title: 'Appearance',
            icon: Icons.palette_rounded,
            iconColor: AppTheme.accentColor,
            children: [
              _settingsTile(
                isDark,
                icon: isDark
                    ? Icons.nights_stay_rounded
                    : Icons.wb_sunny_rounded,
                iconColor: isDark
                    ? AppTheme.primaryColor
                    : AppTheme.warningAmber,
                title: isDark ? 'Dark Mode' : 'Light Mode',
                subtitle: 'Tap to switch theme',
                trailing: const ThemeToggleButton(),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // ── About ──
          _sectionCard(
            isDark,
            title: 'About',
            icon: Icons.info_outline_rounded,
            iconColor: AppTheme.darkTextSecondary,
            children: [
              _settingsTile(
                isDark,
                icon: Icons.star_rounded,
                iconColor: AppTheme.warningAmber,
                title: 'Rate the App',
                subtitle: 'Help us improve',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted,
                ),
                onTap: () {},
              ),
              _divider(isDark),
              _settingsTile(
                isDark,
                icon: Icons.share_rounded,
                iconColor: AppTheme.accentColor,
                title: 'Share App',
                subtitle: 'Invite your friends',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted,
                ),
                onTap: () {},
              ),
              _divider(isDark),
              _settingsTile(
                isDark,
                icon: Icons.privacy_tip_rounded,
                iconColor: AppTheme.primaryColor,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted,
                ),
                onTap: () {},
              ),
              _divider(isDark),
              _settingsTile(
                isDark,
                icon: Icons.info_rounded,
                iconColor: AppTheme.darkTextMuted,
                title: 'App Version',
                subtitle: 'Reality Check Purchase v1.0.0',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.safeGreen.withOpacity(0.12),
                    borderRadius:
                    BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: const Text(
                    'Latest',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.safeGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }

  // ── Section Card ──
  Widget _sectionCard(
      bool isDark, {
        required String title,
        required IconData icon,
        required Color iconColor,
        required List<Widget> children,
      }) {
    return Container(
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
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingMd,
              AppTheme.spacingMd,
              AppTheme.spacingMd,
              AppTheme.spacingSm,
            ),
            child: Row(
              children: [
                Icon(icon, size: 15, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // ── Settings Tile ──
  Widget _settingsTile(
      bool isDark, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String subtitle,
        required Widget trailing,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.selectionClick();
          onTap();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingMd,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, size: 18, color: iconColor),
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
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
            ),
            const SizedBox(width: AppTheme.spacingSm),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Container(
        height: 1,
        color: isDark ? AppTheme.darkDivider : AppTheme.lightDivider,
      ),
    );
  }

  // ── Danger Zone ──
  Widget _buildDangerZone(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg, 0,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.dangerRed.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingSm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 15,
                    color: AppTheme.dangerRed,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'DANGER ZONE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.dangerRed,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            _settingsTile(
              isDark,
              icon: Icons.delete_sweep_rounded,
              iconColor: AppTheme.dangerRed,
              title: 'Clear All History',
              subtitle: 'Permanently delete all purchase records',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.dangerRed.withOpacity(0.5),
              ),
              onTap: () => _confirmClearHistory(isDark),
            ),
            _divider(isDark),
            _settingsTile(
              isDark,
              icon: Icons.no_accounts_rounded,
              iconColor: AppTheme.dangerRed,
              title: 'Delete Account',
              subtitle: 'Permanently remove your account',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.dangerRed.withOpacity(0.5),
              ),
              onTap: () => _confirmDeleteAccount(isDark),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sign Out ──
  Widget _buildSignOut(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
      ),
      child: CustomButton(
        label: 'Sign Out',
        onPressed: () => _handleSignOut(isDark),
        variant: ButtonVariant.danger,
        prefixIcon: Icons.logout_rounded,
      ),
    );
  }

  // ── Avatar Picker Sheet ──
  void _showAvatarPicker(bool isDark) {
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
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                borderRadius:
                BorderRadius.circular(AppTheme.radiusFull),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'Choose Avatar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              mainAxisSpacing: AppTheme.spacingMd,
              crossAxisSpacing: AppTheme.spacingMd,
              children: _avatars.map((avatar) {
                final isSelected = _selectedAvatar == avatar;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedAvatar = avatar);
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.15)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        avatar,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom +
                  AppTheme.spacingSm,
            ),
          ],
        ),
      ),
    );
  }

  // ── Currency Sheet ──
  void _showCurrencySheet(bool isDark) {
    final currencies = [
      '₹ INR', '\$ USD', '€ EUR', '£ GBP', '¥ JPY', '﷼ SAR',
    ];
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text('Select Currency',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingMd),
            ...currencies.map((c) {
              final isSelected = _currency == c;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _currency = c);
                  Navigator.pop(ctx);
                  _showSuccessSnack('Currency set to $c');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withOpacity(0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        c,
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
                        const Icon(Icons.check_rounded,
                            size: 18, color: AppTheme.primaryColor),
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

  // ── Confirm Clear History ──
  void _confirmClearHistory(bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text('Clear All History?',
            style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          'All purchase history records will be permanently deleted. This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSuccessSnack('History cleared');
            },
            child: const Text('Clear',
                style: TextStyle(color: AppTheme.dangerRed)),
          ),
        ],
      ),
    );
  }

  // ── Confirm Delete Account ──
  void _confirmDeleteAccount(bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text('Delete Account?',
            style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          'Your account and all data will be permanently deleted. This cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.dangerRed)),
          ),
        ],
      ),
    );
  }

  // ── Sign Out ──
  void _handleSignOut(bool isDark) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text('Sign Out?',
            style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          'You will be signed out of your account.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionDuration: const Duration(milliseconds: 600),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                ),
                    (route) => false,
              );
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.dangerRed),
            ),
          ),
        ],
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
}