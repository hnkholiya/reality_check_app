import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../main.dart'; // imports ThemeController

// ─────────────────────────────────────────────
// Button Variant Enum
// ─────────────────────────────────────────────

enum ButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
  success,
}

enum ButtonSize {
  small,
  medium,
  large,
}

// ─────────────────────────────────────────────
// CustomButton
// ─────────────────────────────────────────────

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final bool hasGlow;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.large,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.hasGlow = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
    _opacityAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails _) => _pressController.reverse();
  void _onTapCancel() => _pressController.reverse();

  double get _height {
    switch (widget.size) {
      case ButtonSize.small:  return 40;
      case ButtonSize.medium: return 50;
      case ButtonSize.large:  return 58;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:  return 12;
      case ButtonSize.medium: return 14;
      case ButtonSize.large:  return 15;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.small:  return 15;
      case ButtonSize.medium: return 17;
      case ButtonSize.large:  return 19;
    }
  }

  double get _borderRadius {
    switch (widget.size) {
      case ButtonSize.small:  return AppTheme.radiusSm;
      case ButtonSize.medium: return AppTheme.radiusMd;
      case ButtonSize.large:  return AppTheme.radiusMd;
    }
  }

  Color _resolveBackground(bool isDark) {
    if (widget.onPressed == null) {
      return isDark ? AppTheme.darkCard : AppTheme.lightBorder;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:   return Colors.transparent;
      case ButtonVariant.secondary: return Colors.transparent;
      case ButtonVariant.ghost:     return Colors.transparent;
      case ButtonVariant.danger:    return AppTheme.dangerRed;
      case ButtonVariant.success:   return AppTheme.safeGreen;
    }
  }

  Color _resolveForeground(bool isDark) {
    if (widget.onPressed == null) {
      return isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:   return Colors.white;
      case ButtonVariant.secondary:
        return isDark ? AppTheme.primaryLight : AppTheme.primaryColor;
      case ButtonVariant.ghost:
        return isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
      case ButtonVariant.danger:    return Colors.white;
      case ButtonVariant.success:   return Colors.white;
    }
  }

  Border? _resolveBorder(bool isDark) {
    if (widget.variant == ButtonVariant.secondary) {
      return Border.all(
        color: widget.onPressed == null
            ? (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
            : AppTheme.primaryColor,
        width: 1.5,
      );
    }
    return null;
  }

  Gradient? _resolveGradient(bool isDark) {
    if (widget.onPressed == null) return null;
    if (widget.variant == ButtonVariant.primary) {
      return AppTheme.primaryGradient();
    }
    return null;
  }

  List<BoxShadow>? _resolveGlow() {
    if (!widget.hasGlow || widget.onPressed == null) return null;
    switch (widget.variant) {
      case ButtonVariant.primary: return AppTheme.glowShadow;
      case ButtonVariant.success:
        return [BoxShadow(
          color: AppTheme.safeGreen.withOpacity(0.4),
          blurRadius: 20, offset: const Offset(0, 6),
        )];
      case ButtonVariant.danger:
        return [BoxShadow(
          color: AppTheme.dangerRed.withOpacity(0.4),
          blurRadius: 20, offset: const Offset(0, 6),
        )];
      default: return null;
    }
  }

  Widget _buildLoadingSpinner(Color color) {
    return SizedBox(
      width: _iconSize + 2,
      height: _iconSize + 2,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildContent(Color foreground) {
    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingSpinner(foreground),
          const SizedBox(width: 10),
          Text(
            'Please wait...',
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w700,
              color: foreground,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefixIcon != null) ...[
          Icon(widget.prefixIcon, size: _iconSize, color: foreground),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w700,
            color: foreground,
            letterSpacing: 0.3,
          ),
        ),
        if (widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.suffixIcon, size: _iconSize, color: foreground),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = _resolveForeground(isDark);
    final background = _resolveBackground(isDark);
    final gradient  = _resolveGradient(isDark);
    final border    = _resolveBorder(isDark);
    final glow      = _resolveGlow();

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: (widget.onPressed == null || widget.isLoading)
          ? null
          : widget.onPressed,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: Opacity(opacity: _opacityAnim.value, child: child),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.isFullWidth ? double.infinity : null,
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: gradient == null ? background : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: border,
            boxShadow: glow,
          ),
          child: Center(child: _buildContent(foreground)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ✅ FIXED ThemeToggleButton
// Uses ThemeController.of(context) — always works
// ─────────────────────────────────────────────

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Reads isDark live from InheritedWidget
    final controller = ThemeController.of(context);
    final isDark = controller.isDark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // ✅ Calls toggleTheme() directly — no tree walking
        controller.toggleTheme();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        width: 52,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          gradient: isDark
              ? const LinearGradient(
            colors: [Color(0xFF1A1A27), Color(0xFF22223A)],
          )
              : const LinearGradient(
            colors: [Color(0xFFEDE9FF), Color(0xFFD8D0FF)],
          ),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              alignment:
              isDark ? Alignment.centerLeft : Alignment.centerRight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isDark
                      ? AppTheme.primaryGradient()
                      : const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppTheme.primaryColor.withOpacity(0.5)
                          : const Color(0xFFF59E0B).withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      isDark
                          ? Icons.nights_stay_rounded
                          : Icons.wb_sunny_rounded,
                      key: ValueKey(isDark),
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// IconActionButton — unchanged
// ─────────────────────────────────────────────

class IconActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const IconActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 42,
    this.tooltip,
  });

  @override
  State<IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<IconActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ??
        (isDark ? AppTheme.darkCard : AppTheme.lightCardElevated);
    final iconClr = widget.iconColor ??
        (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary);

    Widget button = GestureDetector(
      onTapDown: (_) {
        _ctrl.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.42,
              color: iconClr,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

// ─────────────────────────────────────────────
// PillChipButton — unchanged
// ─────────────────────────────────────────────

class PillChipButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PillChipButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm + 2,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient() : null,
          color: isSelected
              ? null
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? Colors.white
                    : (isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
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
  }
}